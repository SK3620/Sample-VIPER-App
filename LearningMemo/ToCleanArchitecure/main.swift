//
//  main.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2026/09/26.
//

// MARK: - 呼び出し（初期化・依存性注入）の流れ
/*
 【生成順序のルール】
 依存関係の「末端」から順にインスタンスを作って渡していく。
 1. DataStore (最深部: API / DB)
 2. Repository (DataStoreを注入)
 3. UseCase (Repositoryを注入)
 4. ViewModel (UseCaseを注入)
 5. ViewController (ViewModelを注入)
 */

import UIKit

/*
class AppComposer {
    
    // 例: 画面を生成して返す処理（SceneDelegateやRouterで行う）
    static func makeArticleListViewController() -> ArticleListViewController {
        
        // 1. DataStoreの生成（技術的な依存）
        let remoteDataStore = ArticleRemoteDataStore()
        let localDataStore = ArticleLocalDataStore()
        
        // 2. Repositoryの生成（DataStoreを注入）
        let articleRepository = ArticleRepository(
            remoteDataStore: remoteDataStore,
            localDataStore: localDataStore
        )
        let favoriteRepository = FavoriteRepository()
        let userRepository = UserRepository()
        let analyticsService = AnalyticsService()
        
        // 3. UseCaseの生成（Repositoryを注入）
        let getArticlesUseCase = GetArticlesUseCase(
            articleRepository: articleRepository,
            favoriteRepository: favoriteRepository,
            userRepository: userRepository,
            analyticsService: analyticsService
        )
        
        // 4. ViewModelの生成（UseCaseを注入）
        let viewModel = ArticleListViewModel(
            getArticlesUseCase: getArticlesUseCase
        )
        
        // 5. ViewControllerの生成（ViewModelを注入）
        let viewController = ArticleListViewController(
            viewModel: viewModel
        )
        
        return viewController
    }
}

// MARK: - 実際に処理が動く時の呼び出しスタック（流れ）
/*
 【ユーザー操作時のデータの流れ】
  1. [UI] ViewController (viewDidLoad)
     ↓ `viewModel.onViewDidLoad()` を実行
  2. [Presentation] ViewModel
     ↓ `getArticlesUseCase.execute(...)` を実行
  3. [Domain] UseCase
     ↓ ビジネスルール処理 ＋ `articleRepository.fetchArticles(...)` を実行
  4. [Data] Repository
     ↓ キャッシュ判断 ＋ `remoteDataStore.fetchArticles(...)` を実行
  5. [Data] DataStore
     ↓ `URLSession.shared.dataTask(...)` で実際に通信して元データを取得
     
 (データが返る時はこの逆順でUIまで通知される)
 */

*/
