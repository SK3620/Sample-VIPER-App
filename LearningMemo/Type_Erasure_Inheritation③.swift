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
    
    // private let _useCase: UseCaseProtocol3
     
    init<T: UseCaseProtocol3>(_ useCase: T) where T.Parameter == Parameter, T.Success == Success {
        // _useCase = useCase
    }
   
    /*
    private let _useCase: any UseCaseProtocol3 だと any 型になるので、型の不一致 ❌
    func excute(parameter: Parameter, completion: (Success) -> Void) {
        _useCase.excute(<#T##parameter: any UseCaseProtocol3.Parameter##any UseCaseProtocol3.Parameter#>, completion: <#T##(any UseCaseProtocol3.Success) -> Void#>)
    }
     */
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
        
    }
}
