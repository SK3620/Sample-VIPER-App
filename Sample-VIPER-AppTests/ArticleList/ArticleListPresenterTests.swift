//
//  ArticleListPresenter.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/05/06.
//

import XCTest
@testable import Sample_VIPER_App

final class ArticleListPresenterTests: XCTestCase {

    func test_didLoad_whenArticlesExist_shouldShowArticles() {
        let articles = [ArticleEntity(id: 1, userId: 1, title: "Title", body: "Body")]
        let view = MockArticleListViewController()
        let router = MockArticleListRouter()
        let useCase = UseCase(MockGetArticlesArrayUseCase(result: .success(articles)))

        let presenter = ArticleListPresenter(
            view: view,
            inject: .init(router: router, getArticlesArrayUseCase: useCase)
        )

        presenter.didLoad()

        XCTAssertEqual(view.shownArticles, articles)
    }

    func test_didLoad_whenArticlesEmpty_shouldShowEmpty() {
        let view = MockArticleListViewController()
        let router = MockArticleListRouter()
        let useCase = UseCase(MockGetArticlesArrayUseCase(result: .success([])))

        let presenter = ArticleListPresenter(
            view: view,
            inject: .init(router: router, getArticlesArrayUseCase: useCase)
        )

        presenter.didLoad()

        XCTAssertTrue(view.didShowEmpty)
    }

    func test_didLoad_whenFailure_shouldShowError() {
        let expectedError = NSError(domain: "test", code: 1)
        let view = MockArticleListViewController()
        let router = MockArticleListRouter()
        let useCase = UseCase(MockGetArticlesArrayUseCase(result: .failure(expectedError)))

        let presenter = ArticleListPresenter(
            view: view,
            inject: .init(router: router, getArticlesArrayUseCase: useCase)
        )

        presenter.didLoad()

        XCTAssertEqual(view.shownError as NSError?, expectedError)
    }

    func test_didSelect_shouldCallRouter() {
        let article = ArticleEntity(id: 1, userId: 1, title: "Test", body: "Body")
        let view = MockArticleListViewController()
        let router = MockArticleListRouter()
        let useCase = UseCase(MockGetArticlesArrayUseCase(result: .success([])))

        let presenter = ArticleListPresenter(
            view: view,
            inject: .init(router: router, getArticlesArrayUseCase: useCase)
        )

        presenter.didSelect(articleEntity: article)

        XCTAssertEqual(router.didShowDetailWith?.id, article.id)
    }
}
