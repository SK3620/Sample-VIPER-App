//
//  MockArticleListViewController.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/05/06.
//

import Foundation
@testable import Sample_VIPER_App

class MockArticleListViewController: ArticleListViewProtocol {
    var shownArticles: [ArticleEntity]?
    var didShowEmpty = false
    var shownError: Error?
    
    func showArticles(_ articleEntities: [ArticleEntity]) {
        shownArticles = articleEntities
    }

    func showEmpty() {
        didShowEmpty = true
    }

    func showError(_ error: Error) {
        shownError = error
    }
}
