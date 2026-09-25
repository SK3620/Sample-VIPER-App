//
//  ArticleListViewModel2.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2026/09/26.
//

import Combine

class ArticleListViewModel2 {
    
    // UI側のバインディング用に公開する状態
    @Published private(set) var articles: [ArticleEntity] = []
    @Published private(set) var isEmpty: Bool = false
    @Published private(set) var errorMessage: String? = nil
    
    private let getArticlesUseCase2: GetArticlesUseCaseProtocol
    
    init(getArticlesUseCase: GetArticlesUseCaseProtocol) {
        self.getArticlesUseCase2 = getArticlesUseCase
    }
    
    func onViewDidLoad() {
        getArticlesUseCase2.execute { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let articles):
                if articles.isEmpty {
                    self.isEmpty = true
                } else {
                    self.articles = articles
                }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
