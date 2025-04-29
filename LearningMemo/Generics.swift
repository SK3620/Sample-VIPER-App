//
//  Generics.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/04/29.
//

protocol HogeUseCaseProtocol where Failure: Error {
    associatedtype Parameter
    associatedtype Success
    associatedtype Failure
    
    func execute(_ parameter: Parameter, completion: ((Result<Success, Failure>) -> ())?)
}

class HogeUseCase<Parameter, Success, Failure: Error> {
        
    init<T: HogeUseCaseProtocol>(_ useCase: T) where T: HogeUseCaseProtocol, T.Parameter == Parameter, T.Success == Success, T.Failure == Failure
    {
        print("initialized")
    }
    
    /*
     T.Parameter == UseCaseクラスのParameter
     T.Success == UseCaseクラスのSuccess
     T.Failure == UseCaseクラスのFailure

     */
}

class HogeGetArticlesArrayUseCase: HogeUseCaseProtocol {
    /*
     結論: わざわざtypealiasを明示的に宣言する必要はない
     ① typealiasで明示的に宣言する    （例） typealias Parameter = Void
     ② プロトコル内のメソッドやプロパティの使い方で推論される    （例） executeメソッドのシグネチャから勝手に判定される
     */
    
//    typealias Parameter = Void
//    typealias Success = String
//    typealias Failure = Error
    
    func execute(_ parameter: Void, completion: ((Result<String, Error>) -> ())?) {
        
    }
}

/*
同じ型の UseCaseProtocol を持ってきたやつだけ受け取れる
 UseCaseクラス<ParamA, SuccessA, FailureA>
           ↑
           ↑ もらう 型が一致している必要がある
           ↑
 （GetArticlesArrayUseCase）UseCaseProtocol<ParamA, SuccessA, FailureA>
*/
class Hoge {
    func main() {
        var getArticlesArrayUseCase1: HogeUseCase<Void, String, Error>
        var getArticlesArrayUseCase2: HogeUseCase<Void, Int, Error>

        getArticlesArrayUseCase1 = HogeUseCase(HogeGetArticlesArrayUseCase())
        // getArticlesArrayUseCase2 = UseCase(GetArticlesArrayUseCase()) // UseCase<Void, String, Error>との型ズレ コンパイルエラー
    }
}
