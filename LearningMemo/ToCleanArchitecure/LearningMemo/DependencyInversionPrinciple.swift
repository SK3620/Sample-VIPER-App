//
//  DependencyInversionPrinciple.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2026/09/28.
//


// =================================================================
// 依存関係逆転の原則 (DIP: Dependency Inversion Principle)
// =================================================================

/**
 「使う側（上位）が『こういうインターフェースが欲しい』とルールを決め、使われる側（下位）がそのルールに従う」という設計ルール
 */


import Foundation

// MARK: - 【フェーズ1】下位レイヤー（具体クラス）に直接依存したコード
// -----------------------------------------------------------------
// 解説:
// SearchService 内で YahooRepository を直接生成している。
// 【問題点】
// 1. SearchService 単体でのテスト（モック化）ができない。
// 2. YahooRepository のメソッド名などが変わると、SearchService も修正が必要。→ 変更に弱い

enum Phase1 {
    class YahooRepository {
        func getSearchResults() -> [String] {
            return ["Yahoo結果1", "Yahoo結果2"]
        }
    }

    class SearchService {
        // 具体クラスに直接依存
        private let repository = YahooRepository()

        func getResult() -> [String] {
            return repository.getSearchResults()
        }
    }
}

// MARK: - 【フェーズ2】Dependency Injection (DI: 依存性の注入) の導入
// -----------------------------------------------------------------
// 解説:
// repository を外部（init）から渡せるようにした。
// 【改善点】
// サブクラスを作ればモックを注入してテスト可能になった。
// 【問題点】
// 1. 親クラスの init() 内で特殊な処理（通信等）をしているとモック作成時に影響を受ける。
// 2. final クラスの場合はサブクラス化できずモックが作れない。
// 3. 型が YahooRepository のままなので、Google検索への変更に弱い。

enum Phase2 {
    class YahooRepository {
        func getSearchResults() -> [String] {
            return ["Yahoo結果1", "Yahoo結果2"]
        }
    }

    class SearchService {
        
        //「YahooRepository」という型名を直接書いてしまっている
        // 型がガチガチに固定されている
        private let repository: YahooRepository

        // イニシャライザ経由で外から注入（DI）
        init(repository: YahooRepository) {
            self.repository = repository
            
            /**
             1. 親クラスの init() 内で特殊な処理（通信等）をしているとモック作成時に影響を受ける。
             例えばこの辺りで、全く別の、実際のサーバーへのAPI通信処理を行なっている場合は、よくない。
             */
        }

        func getResult() -> [String] {
            return repository.getSearchResults()
        }
    }
    
    // MARK: 具体例テストコード
    class MockYahooRepository: YahooRepository {
        override func getSearchResults() -> [String] {
                        
            return ["Mock Yahoo結果1", "Mock Yahoo結果2"]
        }
    }
    
    func test() {
        let reository = SearchService(repository: MockYahooRepository())
        let result = reository.getResult()
        // expect(result).toBe(["Mock Yahoo結果1", "Mock Yahoo結果2"])
    }
}


// MARK: - 【フェーズ3】プロトコル指向（インターフェースの導入）
// -----------------------------------------------------------------
// 💡 解説:
// YahooRepositoryInterface を作成し、プロトコル（抽象）に依存させた。
// 【改善点】
// サブクラス化ではなくプロトコル適合でモックが作れるため、finalでも対応可能。
// 【問題点】
// プロトコルが「Yahoo（外部）」の都合で作られている。
// 例：YahooのAPI仕様変更で APIキーや追加でリクエスト引数等が が必要になると…
//      → YahooRepositoryInterface に apiKey 引数が追加される
//      → 巻き添えで SearchService 側もコード修正が必要になる！（アンコントローラブル）
// 結局、下位レイヤーの変更が、上位レイヤーにまで影響しちゃう...

enum Phase3 {
    // ❌ 外部（Yahoo）の都合で定義されたプロトコル
    protocol YahooRepositoryInterface {
        func getSearchResults() -> [String]
    }

    class YahooRepository: YahooRepositoryInterface {
        
        // 仮にここで引数追加になったら、、、 func getResult() -> [String] {} も引数追加の記載が必要になってしまう、、
        func getSearchResults() -> [String] {
            return ["Yahoo結果1", "Yahoo結果2"]
        }
    }

    class SearchService {
        private let repository: YahooRepositoryInterface

        init(repository: YahooRepositoryInterface) {
            self.repository = repository
        }

        func getResult() -> [String] {
            return repository.getSearchResults()
        }
    }
    
    // MARK: 具体例テストコード
    class MockYahooRepository: YahooRepositoryInterface {
        func getSearchResults() -> [String] {
            return ["Mock Yahoo結果1", "Mock Yahoo結果2"]
        }
    }
    
    func test() {
        /**
         フェーズ3の1 の解決: 親クラスを継承しない（ゼロからモックを作る）ため、親クラスの init() で重い通信処理が走る問題がなくなります。予期せぬ副作用がなくなる
         */
        let reository = SearchService(repository: MockYahooRepository())
        let result = reository.getResult()
        // expect(result).toBe(["Mock Yahoo結果1", "Mock Yahoo結果2"])
    }
}

// MARK: - 【フェーズ4】依存関係逆転の原則 (DIP) の適用
// -----------------------------------------------------------------
// 💡 解説:
// 主役を「SearchService（自分側）」にし、SearchService が欲しいインターフェースを宣言する。SearchService都合/身勝手で、欲しいインターフェースを定義
// 下位レイヤー（Yahoo/Google）がこのプロトコルに適合する形にする。
//
// 【メリット】
// 1. Yahoo側のAPI仕様変更（APIキー追加等）が起きても、YahooRepository 内部で吸収すれば良く、
//    SearchService や プロトコル（SearchServiceRepositoryInterface）は影響を受けない。
// 2. Google検索やテスト用モックへの差し替えが SearchService のコード修正なしで可能。
//
// 【問題点】
// 1. [Any] を使っていた場合の問題：型安全性が失われる
// Any は何でも入れられる反面、受け取る側（SearchService や UI 側）でキャスト（as? YahooResult など）が必要になり、型チェックの恩恵を受けられなくなります。また、万が一キャストを失敗するとクラッシュやバグの原因になります。
//
// 2. [String] や特定の型（例: [YahooResult]）に固定していた場合の問題
// もし SearchService が [YahooResult] を返す設計になっていると、後から GoogleRepository（[GoogleResult] を返す）に差し替えたい時に、リポジトリごとに返すデータの型（クラス）が異なるため、型が合わずに差し替えができなくなってしまいます。

enum Phase4 {
    // ⭕️ 利用者（SearchService）側の都合で定義したプロトコル
    // 「裏で何を使おうが、とにかく検索結果のString型で帰ってくる配列をくれれば良い」という姿勢
    protocol SearchServiceRepositoryInterface {
        func get() -> [String]
    }

    // --- 利用する側のサービス ---
    class SearchService {
        private let repository: SearchServiceRepositoryInterface

        init(repository: SearchServiceRepositoryInterface) {
            self.repository = repository
        }

        func getResult() -> [String] {
            return repository.get()
        }
    }

    // --- 各具象クラス（下位レイヤー） ---

    // 1. Yahoo実装（内部でAPIキーが必要になっても、ここで完結する）
    class YahooRepository: SearchServiceRepositoryInterface {
        private let apiKey = "SECRET_YAHOO_KEY"

        func get() -> [String] {
            // Yahoo独自の通信処理・APIキー設定などはここに隠蔽される
            return ["Yahoo検索結果1", "Yahoo検索結果2"]
        }
    }

    // 2. Google実装への差し替えも容易
    class GoogleRepository: SearchServiceRepositoryInterface {
        func get() -> [String] {
            return ["Google検索結果1", "Google検索結果2"]
        }
    }

    // 3. テスト用モック（外部通信を行わない偽物）
    class MockRepository: SearchServiceRepositoryInterface {
        func get() -> [String] {
            return ["Mockデータ1", "Mockデータ2"]
        }
    }
}


enum Phase5 {
    
    // MARK: 汎用的な Repository インターフェース
    // データアクセス層（API通信やDB取得）の実行処理を抽象化するプロトコル
    public protocol RepositoryInterface {
        associatedtype Parameter
        associatedtype Success
        associatedtype Failure: Error
        
        func excute(_ parameter: Parameter, completion: ((Result<Success, Failure>) -> Void)?)
    }


    // MARK: 1. Yahoo検索リポジトリ

    public struct YahooResult {} // Entity
    public enum YahooError: Error { case networkError }

    public class YahooRepository: RepositoryInterface {
        /*
        public typealias Parameter = String
        public typealias Success = [YahooResult]
        public typealias Failure = YahooError
         */
        
        public func excute(_ parameter: String, completion: ((Result<[YahooResult], YahooError>) -> Void)?) {
            print("Yahooで '\(parameter)' を検索中...")
            // 成功
            completion?(.success([YahooResult()]))
            // 失敗
            completion?(.failure(.networkError))
        }
    }


    // MARK: - 2. Google検索リポジトリ（パラメータが構造体の場合）

    public struct GoogleSearchQuery {
        let keyword: String
        let page: Int
    }
    public struct GoogleResult {} // Entity
    public enum GoogleError: Error { case apiLimitExceeded }

    public class GoogleRepository: RepositoryInterface {
        /*
        public typealias Parameter = GoogleSearchQuery
        public typealias Success = [GoogleResult]
        public typealias Failure = GoogleError
         */
        
        public func excute(_ parameter: GoogleSearchQuery, completion: ((Result<[GoogleResult], GoogleError>) -> Void)?) {
            print("Googleで '\(parameter.keyword)' (Page: \(parameter.page)) を検索中...")
            // 成功
            completion?(.success([GoogleResult()]))
            // 失敗
            completion?(.failure(.apiLimitExceeded))
        }
    }


    // MARK: - 3. 検索サービス（上位レイヤー）
    // RepositoryInterface を受け取ることで、特定の検索実装（Yahoo/Google/Mock）に依存しない
    public class SearchService<Repository: RepositoryInterface> {
        
        private let repository: Repository
        
        public init(repository: Repository) {
            self.repository = repository
        }
        
        public func excute(
            param: Repository.Parameter,
            completion: ((Result<Repository.Success, Repository.Failure>) -> Void)?
        ) {
            // 下位層（Repository）の具体的な実装を意識せず、インターフェース経由で呼び出す
            repository.excute(param, completion: completion)
        }
    }
    
    // MARK: 動作確認・使用例
    func main() {

        // Yahooリポジトリを使う場合
        let yahooRepo = YahooRepository()
        let yahooService = SearchService(repository: yahooRepo)
        yahooService.excute(param: "Swift DIP") { result in
            print("Yahoo検索完了: \(result)")
        }

        // Googleリポジトリを使う場合
        let googleRepo = GoogleRepository()
        let googleService = SearchService(repository: googleRepo)
        let query = GoogleSearchQuery(keyword: "Swift DIP", page: 1)
        googleService.excute(param: query) { result in
            print("Google検索完了: \(result)")
        }
    }
}
