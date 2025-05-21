//
//  Type_Erasure①.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/05/16.
//


protocol Printer {
    associatedtype Item
    func printItem(_ item: Item)
}

struct StringPrinter: Printer {
    func printItem(_ item: String) {
        print("文字列: \(item)")
    }
}

struct IntPrinter: Printer {
    func printItem(_ item: Int) {
        print("数字: \(item)")
    }
}

struct URLPrinter: Printer {
    func printItem(_ item: Int) {
        print("URL: \(item)")
    }
}


struct Huga {
    func huga() {
        
        /*
         以下は、Item の型が String（Int） の Printer プロトコルを包む type erasure
         */
        var stringPrinter: AnyPrinter<String> // AnyPrinter の Item の型が決定する
        var intPrinter: AnyPrinter<Int> // AnyPrinter の Item の型が決定する
        
        /*
         異なる Item を持つ Printer プロトコルたちを共通の箱（type-erased なラッパー）に包んで、共通化する

         .init で、StringPrinter（Int） の associatedtype Item = String（Int） を見て、「これは AnyPrinter<String> に合うかどうか判断する
         */
        stringPrinter = .init(StringPrinter())
        intPrinter = .init(IntPrinter())
    
        stringPrinter.printItem("こんにちは") // OK
        intPrinter.printItem(123)           // OK
        
        
        
        
        /*
         以下では、
         Swiftはこの時点で「Printer の Item が何の型か分からない」
         Printer の Item が何かわからないまま使おうとしてるのでエラー
         */
        
        // let printer: Printer = URLPrinter() → ❌
        // func hugaHuga(printer: Printer) {} → ❌
        
        /*
         ただし、以下はエラーじゃない
         しかし、型がプロトコルじゃなくなる
         */
        let printer2 = URLPrinter()
        func hugaHuga2(printer: URLPrinter) {}
    }
}

class AnyPrinter<Item> {
    private let _print: (Any) -> Void

    /*
     Type Erasure（型消去）
     異なる Item を持つ Printer プロトコルを同じ箱に入れて扱いたいときに使用
     AnyPrinter は「Printer を型消去して使えるようにしたラッパー」なので、associatedtype を隠蔽
     */
    init<P: Printer>(_ printer: P) where P: Printer, P.Item == Item {
        self._print = { item in
            if let typedItem = item as? P.Item {
                printer.printItem(typedItem)
            } else {
                print("型が違う")
            }
        }
    }
    
    // 以下はエラー
    // init(_ printer: Printer) { // 処理 }

    func printItem(_ item: Any) {
        _print(item)
    }
}
