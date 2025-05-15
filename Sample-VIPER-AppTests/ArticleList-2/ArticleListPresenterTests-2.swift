//
//  Untitled.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/05/15.
//

import Testing
@testable import Sample_VIPER_App
import Foundation

extension Tag {
    @Tag static var ArticleListPresenterTests_2: Tag
}


@Suite(.tags(.ArticleListPresenterTests_2))
struct ArticleListPresenterTests_2 {
    
    @Test("記事が存在する場合、showArticlesが呼ばれること")
    func showArticles_whenArticlesExist() {
        let articles = [ArticleEntity(id: 1, userId: 1, title: "Title", body: "Body")]
        let view = ArticleListViewMock()
        let router = ArticleListRouterMock()
        let useCase = UseCase(GetArticlesArrayUseCaseMock(result: .success(articles)))

        let presenter = ArticleListPresenter(
            view: view,
            inject: .init(router: router, getArticlesArrayUseCase: useCase)
        )

        presenter.didLoad()

        #expect(view.callCount_showArticles == 1)
        #expect(view.lastShownArticles == articles)
    }

    @Test("記事が空の場合、showEmptyが呼ばれること")
    func showEmpty_whenArticlesEmpty() {
        let view = ArticleListViewMock()
        let router = ArticleListRouterMock()
        let useCase = UseCase(GetArticlesArrayUseCaseMock(result: .success([])))

        let presenter = ArticleListPresenter(
            view: view,
            inject: .init(router: router, getArticlesArrayUseCase: useCase)
        )

        presenter.didLoad()

        #expect(view.callCount_showEmpty == 1)
    }

    @Test("取得失敗時にshowErrorが呼ばれること")
    func showError_whenUseCaseFails() {
        let expectedError = NSError(domain: "Test", code: 1)
        let view = ArticleListViewMock()
        let router = ArticleListRouterMock()
        let useCase = UseCase(GetArticlesArrayUseCaseMock(result: .failure(expectedError)))

        let presenter = ArticleListPresenter(
            view: view,
            inject: .init(router: router, getArticlesArrayUseCase: useCase)
        )

        presenter.didLoad()

        #expect(view.callCount_showError == 1)
        #expect((view.lastError as NSError?)?.code == 1)
    }

    @Test("記事選択時にRouterが呼ばれること")
    func showDetail_whenArticleSelected() {
        let article = ArticleEntity(id: 1, userId: 1, title: "Test", body: "Body")
        let view = ArticleListViewMock()
        let router = ArticleListRouterMock()
        let useCase = UseCase(GetArticlesArrayUseCaseMock(result: .success([])))

        let presenter = ArticleListPresenter(
            view: view,
            inject: .init(router: router, getArticlesArrayUseCase: useCase)
        )

        presenter.didSelect(articleEntity: article)

        #expect(router.lastShownArticle?.id == article.id)
    }
}

// MARK: - Mock 実装

final class ArticleListViewMock: ArticleListOutput {

    private(set) var callCount_showArticles = 0
    private(set) var callCount_showEmpty = 0
    private(set) var callCount_showError = 0

    private(set) var lastShownArticles: [ArticleEntity]?
    private(set) var lastError: Error?

    func showArticles(_ articleEntities: [ArticleEntity]) {
        callCount_showArticles += 1
        lastShownArticles = articleEntities
    }

    func showEmpty() {
        callCount_showEmpty += 1
    }

    func showError(_ error: Error) {
        callCount_showError += 1
        lastError = error
    }
}

final class ArticleListRouterMock: ArticleListRouterProtocol {
    private(set) var lastShownArticle: ArticleEntity?

    func showArticleDetail(articleEntity: ArticleEntity) {
        lastShownArticle = articleEntity
    }
}

final class GetArticlesArrayUseCaseMock: UseCaseProtocol {
    let result: Result<[ArticleEntity], Error>

    init(result: Result<[ArticleEntity], Error>) {
        self.result = result
    }

    func execute(_ parameter: Void, completion: ((Result<[ArticleEntity], Error>) -> ())?) {
        completion?(result)
    }
}
