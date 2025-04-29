//
//  ArticleListPresenter.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/04/21.
//

import Foundation

protocol ArticleListPresenterProtocol: AnyObject {
    
    func didLoad()
    func didSelect(articleEntity: ArticleEntity)
}

protocol ArticleListViewProtocol: AnyObject {
    
    func showArticles(_ articleEntities: [ArticleEntity])
    func showEmpty()
    func showError(_ error: Error)
}

class ArticleListPresenter {
    
    struct Dependency {
        let router: ArticleListRouterProtocol!
        let getArticlesArrayUseCase: UseCase<Void, [ArticleEntity], Error> // UseCase<Parameter, Success, Failure: Error>
        
        /*
         実体としては、GetArticlesArrayUseCaseを差し込むが、そのGetArticlesArrayUseCaseの型を指定するのではなく、UseCaseクラスを使ってこのようにParameterとResultの成功と失敗の型のみで指定することができる。これによりPresenterは、GetArticlesArrayUseCaseクラスに依存しなくなる。
         */
    }
    
    weak var view: ArticleListViewProtocol!
    private var di: Dependency
    
    init(view: ArticleListViewProtocol, inject dependency: Dependency) {
        self.view = view
        self.di = dependency
    }
}

extension ArticleListPresenter: ArticleListPresenterProtocol {
        
    func didLoad() {
        // GetArticlesArrayUseCase().execute(()) { [weak self] result in
        
        // getArticlesArrayUseCase: UseCase<Void, [ArticleEntity], any Error> GetArticlesArrayUseCase型ではない
        di.getArticlesArrayUseCase.execute(()) { [weak self] result in

            guard let self = self else { return }
            
            switch result {
            case .success(let articleEntities):
                if articleEntities.isEmpty {
                    self.view.showEmpty()
                    return
                }
                self.view.showArticles(articleEntities)
            case .failure(let error):
                self.view.showError(error)
            }
        }
    }
    
    func didSelect(articleEntity: ArticleEntity) {
        di.router.showArticleDetail(articleEntity: articleEntity)
    }
}

