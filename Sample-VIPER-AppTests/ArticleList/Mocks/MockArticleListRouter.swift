//
//  MockArticleListRouter.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/05/06.
//

import Foundation
@testable import Sample_VIPER_App

class MockArticleListRouter: ArticleListRouterProtocol {
    var didShowDetailWith: ArticleEntity?

    func showArticleDetail(articleEntity: ArticleEntity) {
        didShowDetailWith = articleEntity
    }
}
