//
//  GetArticlesUseCase.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2026/09/26.
//

protocol ArticleRepositoryProtocol {
    func fetchArticles(completion: @escaping (Result<[ArticleEntity], Error>) -> Void)
}

protocol GetArticlesUseCaseProtocol {
    func execute(completion: @escaping (Result<[ArticleEntity], Error>) -> Void)
}

class GetArticlesUseCase2: GetArticlesUseCaseProtocol {
    private let repository: ArticleRepositoryProtocol
    
    // RepositoryをDI（依存性注入）
    init(repository: ArticleRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(completion: @escaping (Result<[ArticleEntity], Error>) -> Void) {
        // ビジネスロジックをここに書く（例: 取得結果のフィルタリングなど）
        repository.fetchArticles(completion: completion)
    }
}

// MARK: - UseCase（ユースケース）の役割
/*
 【単語の定義】
 - Application/Domain Logic（画面や通信に依存しない、アプリ固有のルール）
 
 【UseCaseが担う5つの具体的な役割】
 1. 複数データ源の集約（API結果 ＋ ローカル保存データ など）
 2. ビジネスルールの適用（会員ランクによる権限チェック、フィルタリング）
 3. データの加工・変換（APIレスポンスからアプリ用Domainモデルへの変換）
 4. 副作用の実行（取得成功時のアナリティクス/ログ送信）
 5. キャッシュ制御（オフライン時はローカルDB、オンライン時はAPI）

 */

/*
class GetArticlesUseCase3: GetArticlesUseCaseProtocol {
    
    private let articleRepository: ArticleRepositoryProtocol
    private let favoriteRepository: FavoriteRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    private let analyticsService: AnalyticsServiceProtocol
    
    init(
        articleRepository: ArticleRepositoryProtocol,
        favoriteRepository: FavoriteRepositoryProtocol,
        userRepository: UserRepositoryProtocol,
        analyticsService: AnalyticsServiceProtocol
    ) {
        self.articleRepository = articleRepository
        self.favoriteRepository = favoriteRepository
        self.userRepository = userRepository
        self.analyticsService = analyticsService
    }
    
    func execute(completion: @escaping (Result<[ArticleEntity], Error>) -> Void) {
        // 役割5: ユーザー状態（ビジネス条件）の取得
        let currentUser = userRepository.getCurrentUser()
        
        // 役割1: 記事データ（API等）の取得
        articleRepository.fetchArticles { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let rawArticles):
                // 役割1: ローカルデータ（お気に入りID）の取得と合体
                let favoriteIds = self.favoriteRepository.getFavoriteIds()
                
                let processedArticles = rawArticles
                    // 役割2: ビジネスルール（無料ユーザーには有料記事を隠す）
                    .filter { article in
                        article.isPremium ? currentUser.isPremiumMember : true
                    }
                    // 役割3: データの加工・判定（お気に入りフラグを付与）
                    .map { article -> ArticleEntity in
                        var item = article
                        item.isFavorite = favoriteIds.contains(article.id)
                        return item
                    }
                
                // 役割4: 副作用（アナリティクス送信）
                self.analyticsService.logEvent("articles_fetched", count: processedArticles.count)
                
                completion(.success(processedArticles))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
*/
