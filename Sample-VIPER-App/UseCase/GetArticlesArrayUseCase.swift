//
//  GetArticlesArrayUseCase.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/04/21.
//

import Foundation

/*
class GetArticlesArrayUseCase: UseCaseProtocol {
    
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

class GetArticlesArrayUseCase: UseCaseProtocol {
    
    typealias Parameter = Void
    typealias Success = [ArticleEntity]
    typealias Failure = Error
    
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

