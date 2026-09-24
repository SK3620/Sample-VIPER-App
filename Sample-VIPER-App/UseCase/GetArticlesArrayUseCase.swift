//
//  GetArticlesArrayUseCase.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/04/21.
//

import Foundation

/*
class MockGetArticlesArrayUseCase: UseCaseProtocol {
    
    func execute(_ parameter: Void, completion: ((Result<[ArticleEntity], Error>) -> ())?) {
        let res: [ArticleEntity] = [
            ArticleEntity(id: 1, userId: 1, title: "タイトル", body: "本文"),
            ArticleEntity(id: 2, userId: 1, title: "タイトル2", body: "本文2"),
            ArticleEntity(id: 3, userId: 1, title: "タイトル3", body: "本文3"),
        ]
        
        completion?(.success(res))
    }
}
*/

/**
 Interactor（UseCase）
 見た目とは関係のないロジックの部分を処理する役割を担当
 主にはデータのやりとり、すなわちクラッド(CRUD)についての仕事をすることが多くなる
 「単一責任の原則」が強く意識される
 */

/**
 「単一責任の原則」
「クラスの中身を変更する理由は複数存在しない」という原則
 例えば、ビジネスロジックで「データを取得する」「計算する」「結果を送信する」といった処理を(まとめて)ひとつのクラス/メソッドに行わせると、 互いの処理に干渉する可能性が高くなる。
 1つのビジネスロジックは1つのクラスで行わせることにより、責務を切り離して検証することができるようになる
 */

class GetArticlesArrayUseCase: UseCaseProtocol {
    
    /*
     メソッドの引数に型を指定することで、自動で型推論
     下記のように typealias を定義必要なし
     */
//    typealias Parameter = Void
//    typealias Success = [ArticleEntity]
//    typealias Failure = Error
    
    func execute(_ parameter: Void, completion: ((Result<[ArticleEntity], Error>) -> ())?) {
        let session = URLSession(configuration: .default)
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion?(.failure(error))
                }
                return
            }
            guard
                let data = data,
                let decoded = try? JSONDecoder().decode([ArticleEntity].self,
                                                        from: data)
                else {
                    let error = NSError(
                        domain: "parse-error",
                        code: 1,
                        userInfo: nil
                    )
                    DispatchQueue.main.async {
                        completion?(.failure(error))
                    }
                    return
            }
            
            DispatchQueue.main.async {
                completion?(.success(decoded))
            }
        }
        task.resume()
    }
}

