//
//  Type_Erasure③.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/05/21.
//

protocol UseCaseProtocol3 {
    associatedtype Parameter
    associatedtype Success
    
    func excute(_ parameter: Parameter, completion: (Success) -> Void)
}

class UseCase3<Parameter, Success> {
    
    /*
     これだとダメ ❌
    private let _useCase: any UseCaseProtocol3
     */
    
    /*
     これもダメ そもそも T がない ❌
    private let _useCase: UseCaseInstance<<#T: UseCaseProtocol3#>>
     */
    
    private let _useCase: UseCaseInstanceBase<Parameter, Success>
     
    init<T: UseCaseProtocol3>(_ useCase: T) where T.Parameter == Parameter, T.Success == Success {
        /*
         _useCase = UseCaseInstance<T>.init(useCase: useCase)
         の <T> は init<T: UseCaseProtocol3>... の T のこと
         この T をジェネリクスとして指定する
         この T は渡されてきた、具体的な処理を含む実体の T のこと。
         */
        _useCase = UseCaseInstance<T>.init(useCase: useCase)
    }
   
    /*
    private let _useCase: any UseCaseProtocol3 だと any 型になるので、型の不一致 ❌
    func excute(parameter: Parameter, completion: (Success) -> Void) {
        _useCase.excute(<#T##parameter: any UseCaseProtocol3.Parameter##any UseCaseProtocol3.Parameter#>, completion: <#T##(any UseCaseProtocol3.Success) -> Void#>)
    }
     */
    
    
    /*
     Presenter 内からこの excute に具体的な引数を指定して、呼び出す
     MessageTester の main の「UseCase3.init(SendMessageUseCase3())」によって、
     この excute のメソッドの引数の型（Parameter, Success）の具体的な型が決定される
     よって、この excute の呼び出し側は、具体的にどんな型の値を渡せばいいかがわかるようになる
     */
    func excute(parameter: Parameter, completion: (Success) -> Void) {
        _useCase.excute(paramter: parameter, completion: completion)
    }
}

/*
 UseCase3 クラス内の private let _useCase: UseCaseInstance<<#T: UseCaseProtocol3#>>
 でやろうとしてもダメ T を指定できない ❌

private extension UseCase3 {
    
    class UseCaseInstance<T: UseCaseProtocol3> {
        
        private let useCase: T
        
        init(useCase: T) {
            self.useCase = useCase
        }
        
        func excute(paramter: T.Parameter, completion: (T.Success) -> Void) {
            useCase.excute(paramter, completion: completion)
        }
    }
}
 */

/*
 これもダメ ❌
 なぜなら、UseCase3 クラス内の
 private let _useCase: UseCaseInstanceBase<Parameter, Success> は、
 型が UseCaseInstanceBase クラスなので、_useCase.excute を呼び出せない！
 UseCaseInstanceBase に、excute メソッドを定義しておく必要がある

private extension UseCase3 {
    
    class UseCaseInstanceBase<Parameter, Success> {}
    
    class UseCaseInstance<T: UseCaseProtocol3>: UseCaseInstanceBase<T.Parameter, T.Success> {
        
        private let useCase: T
        
        init(useCase: T) {
            self.useCase = useCase
        }
        
        func excute(paramter: T.Parameter, completion: (T.Success) -> Void) {
            useCase.excute(paramter, completion: completion)
        }
    }
}
 */

private extension UseCase3 {
    
    class UseCaseInstanceBase<Parameter, Success> {
        
        func excute(paramter: Parameter, completion: (Success) -> Void) {
            fatalError()
        }
    }
    
    class UseCaseInstance<T: UseCaseProtocol3>: UseCaseInstanceBase<T.Parameter, T.Success> {
        
        private let useCase: T
        
        init(useCase: T) {
            self.useCase = useCase
        }
        
        override func excute(paramter: T.Parameter, completion: (T.Success) -> Void) {
            useCase.excute(paramter, completion: completion)
        }
        
        /*
         自前で実装は _useCase.excute を呼び出せないため overrideすること ❌
        func excute(paramter: T.Parameter, completion: (T.Success) -> Void) {
            useCase.excute(paramter, completion: completion)
        }
         */
    }
}



class SendMessageUseCase3: UseCaseProtocol3 {
    typealias Parameter = (userId: Int, message: String)
    typealias Success = Bool
    
    func excute(_ parameter: Parameter, completion: (Bool) -> Void) {
        let (userId, message) = parameter
        
        // 擬似的なロジック（例：非同期API通信ではなく単純な成功判定）
        print("Sending message to \(userId): \(message)")
        
        // 仮にメッセージが空でなければ成功とする
        let isSuccess = true
        completion(isSuccess)
    }
}


struct MessageTester {
    
    func main() {
        
        var sendMessageUseCase3: UseCase3<(userId: Int, message: String), Bool>
        
        sendMessageUseCase3 = UseCase3.init(SendMessageUseCase3())
        
        sendMessageUseCase3.excute(parameter: (1, "こんにちは")) { succeeded in
            if succeeded {
                print("送信完了")
            } else {
                print("送信失敗")
            }
        }
    }
}
