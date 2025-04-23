//
//  UsecaseProtocol.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/04/21.
//

import Foundation

// ユースケースの共通化
// 簡潔かつ疎結合なユースケースを実現する
protocol UseCaseProtocol where Failure: Error {
    associatedtype Parameter
    associatedtype Success
    associatedtype Failure
    
    func execute(_ parameter: Parameter, completion: ((Result<Success, Failure>) -> ())?)
}

class UseCase<Parameter, Success, Failure: Error> {
    
    private let instance: UseCaseInstanceBase<Parameter, Success, Failure>
    
    init<T: UseCaseProtocol>(_ useCase: T) where T: UseCaseProtocol, T.Parameter == Parameter, T.Success == Success, T.Failure == Failure
    {
        self.instance = UseCaseInstance<T>(useCase)
    }
    
    func execute(_ parameter: Parameter, completion: ((Result<Success, Failure>) -> ())?) {
        instance.execute(parameter, completion: completion)
    }
}

private extension UseCase {
    
    class UseCaseInstanceBase<Parameter, Success, Failure: Error> {
        
        // このexecuteメソッドは通常通り使用すると、通ることのないデッドコードになりますので、この中身の実装はfatalErrorになることにする
        func execute(_ parameter: Parameter, completion: ((Result<Success, Failure>) -> ())?) {
            fatalError()
        }
    }
    
    class UseCaseInstance<T: UseCaseProtocol>: UseCaseInstanceBase<T.Parameter, T.Success, T.Failure> {
        
        private let useCase: T
        
        init(_ useCase: T) {
            self.useCase = useCase
        }
                
        // UseCaseInstanceはUseCaseInstanceBaseを継承しているためoverride可能
        override func execute(_ parameter: T.Parameter, completion: ((Result<T.Success, T.Failure>) -> ())?) {
            useCase.execute(parameter, completion: completion)
        }
    }
}
