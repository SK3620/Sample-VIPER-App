//
//  Type_Erasure②.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/05/16.
//

/*
 🎯 まず結論：「型を抽象化して、共通の型として扱いたいから」
 具体的には、associatedtype を持つプロトコルの値を、変数や引数としてまとめて扱うために type erasure を使います。

 🧩 例で考えよう
 プロトコルに associatedtype があると…
 swift
 コピーする
 編集する
 protocol Printer {
     associatedtype Item
     func printItem(_ item: Item)
 }
 これに従う2つの型：

 swift
 コピーする
 編集する
 struct StringPrinter: Printer {
     func printItem(_ item: String) {
         print("文字列: \(item)")
     }
 }

 struct IntPrinter: Printer {
     func printItem(_ item: Int) {
         print("整数: \(item)")
     }
 }
 このとき、共通の変数に格納したくてもできない：

 swift
 コピーする
 編集する
 let printers: [Printer] = [StringPrinter(), IntPrinter()] // ❌ エラー！！
 → Printer は associatedtype を持っているから、「具体的な型が決まらない」ので 値として扱えない。

 ✅ 解決策が Type Erasure
 swift
 コピーする
 編集する
 let printers: [AnyPrinterProtocol] = [AnyPrinter(StringPrinter()), AnyPrinter(IntPrinter())]
 こうすると、異なる Item を持つ Printer たちを共通の箱（type-erased なラッパー）に包んで、1つの配列で管理できます。


 */
