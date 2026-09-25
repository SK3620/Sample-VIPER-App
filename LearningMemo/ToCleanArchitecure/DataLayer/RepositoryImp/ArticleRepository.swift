//
//  ArticleRepository.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2026/09/26.
//

import Foundation

class ArticleRepository2: ArticleRepositoryProtocol {
    
    func fetchArticles(completion: @escaping (Result<[ArticleEntity], Error>) -> Void) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            guard let data = data,
                  let decoded = try? JSONDecoder().decode([ArticleEntity].self, from: data) else {
                let parseError = NSError(domain: "parse-error", code: 1, userInfo: nil)
                DispatchQueue.main.async { completion(.failure(parseError)) }
                return
            }
            
            DispatchQueue.main.async { completion(.success(decoded)) }
        }
        task.resume()
    }
}
