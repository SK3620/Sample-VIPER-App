//
//  MockGetArticlesArrayUseCase.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/05/06.
//

import Foundation
@testable import Sample_VIPER_App

class MockGetArticlesArrayUseCase: UseCaseProtocol {
    var result: Result<[ArticleEntity], Error>

    init(result: Result<[ArticleEntity], Error>) {
        self.result = result
    }

    func execute(_ parameter: Void, completion: ((Result<[ArticleEntity], Error>) -> ())?) {
        completion?(result)
    }
}
