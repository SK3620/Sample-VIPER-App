//
//  Untitled.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2026/09/30.
//

import Foundation


// DependencyInversionPrinciple.swift の続き
// =================================================================
// 【詳細比較】Phase4 vs Phase5：何が進化し、どう「変更に強く」なったのか？
// =================================================================

/*
 💡 結論サマリー
 -----------------------------------------------------------------
 Phase4：【クラスの依存関係を切断した段階】
   - メリット: プロトコル（抽象）を挟むことで Mock 化や具象クラスの差し替えが可能になった。
   - 限界    : 引数や返り値が [String] 等に固定されているため、「個別のパラメータ追加」や
               「型安全なデータ構造（モデルクラス）の返却」といった仕様変更が起きると
               プロトコル自体を書き換える必要があり、全体へ破綻が連鎖する。

 Phase5：【データ構造や機能拡張の変化（変更）にも強くなった完成形】
   - メリット: associatedtype と Generics を組み合わせることで、引数・返り値・エラー型を
               各リポジトリの都合で自由に変更できる。
   - 変更への強さ: 特定のリポジトリ（Google等）に仕様変更が起きても、プロトコル本体や
                  他リポジトリ（Yahoo等）、SearchService 側のコードは【修正ゼロ】で済む。
 -----------------------------------------------------------------
 */


// MARK: - ❌ 【Phase4】クラスの依存は切れたが、型が固定で変更に弱い設計
// -----------------------------------------------------------------
enum Phase4_Comparison {

    // ❌ 問題点: 引数や返り値の型が固定されている
    // 「Google検索だけ page（ページ数）を指定したい」「YahooResult モデル型で返したい」ができない
    protocol SearchServiceRepositoryInterface {
        func get() -> [String]
    }

    class SearchService {
        private let repository: SearchServiceRepositoryInterface
        init(repository: SearchServiceRepositoryInterface) { self.repository = repository }
        
        func getResult() -> [String] {
            return repository.get()
        }
    }

    class YahooRepository: SearchServiceRepositoryInterface {
        func get() -> [String] { return ["Yahoo結果1"] }
    }

    class GoogleRepository: SearchServiceRepositoryInterface {
        func get() -> [String] { return ["Google結果1"] }
    }

    /*
     🚨 【仕様変更が発生したときどうなるか？】
     「Google検索に page (Int) パラメータを追加し、画像URLも返したい」という変更が入った場合：

     1. プロトコルを `func get(page: Int) -> [String]` に変更せざるを得ない。
     2. 巻き添えで YahooRepository もコンパイルエラーになり、使わない page 引数の実装を強制される。
     3. 画像URLを返したいが [String] 固定のため、"Google結果1,https://..." のように文字列結合するハメになり型安全性が崩壊する。
     */
}


// MARK: - ⭕️ 【Phase5】associatedtype + Generics による「変更に強い」完成設計
// -----------------------------------------------------------------
enum Phase5_Comparison {

    // ⭕️ ポイント1: associatedtype で「パラメータ」「成功型」「エラー型」を抽象化
    public protocol RepositoryInterface {
        associatedtype Parameter
        associatedtype Success
        associatedtype Failure: Error
        
        func execute(_ parameter: Parameter, completion: ((Result<Success, Failure>) -> Void)?)
    }


    // --- 各リポジトリの実装（それぞれの都合に合わせて自由に型を決定） ---

    // 1. Yahooリポジトリ（単純な Keyword 検索）
    public struct YahooResult { let title: String }
    public enum YahooError: Error { case networkError }

    public class YahooRepository: RepositoryInterface {
        // Parameter = String, Success = [YahooResult], Failure = YahooError と推論される
        public func execute(_ parameter: String, completion: ((Result<[YahooResult], YahooError>) -> Void)?) {
            completion?(.success([YahooResult(title: "Yahoo結果")]))
        }
    }


    // 2. Googleリポジトリ（構造体パラメータ ＆ 専用モデル型 ＆ 独自エラー）
    public struct GoogleSearchQuery {
        let keyword: String
        let page: Int // ✨ 複雑なパラメータも構造体で丸ごと渡せる
    }
    public struct GoogleResult {
        let title: String
        let imageUrl: String // ✨ 型安全なプロパティを持てる
    }
    public enum GoogleError: Error { case apiLimitExceeded }

    public class GoogleRepository: RepositoryInterface {
        public func execute(_ parameter: GoogleSearchQuery, completion: ((Result<[GoogleResult], GoogleError>) -> Void)?) {
            completion?(.success([GoogleResult(title: "Google結果", imageUrl: "https://example.com/1.jpg")]))
        }
    }


    // ⭕️ ポイント2: SearchService は Generics でどんな RepositoryInterface にも対応
    public class SearchService<Repository: RepositoryInterface> {
        private let repository: Repository
        
        public init(repository: Repository) {
            self.repository = repository
        }
        
        public func execute(
            param: Repository.Parameter,
            completion: ((Result<Repository.Success, Repository.Failure>) -> Void)?
        ) {
            // 下位レイヤー（Repository）の具体的な型を知らなくても、そのまま安全に呼び出せる
            repository.execute(param, completion: completion)
        }
    }

    /*
     ✨ 【仕様変更が発生したときどうなるか？】
     「Google検索に sortOption (ソート順) を追加し、検索件数 (totalCount) も受け取りたい」場合：

     1. GoogleSearchQuery 構造体に `let sortOption: SortEnum` を追加。
     2. GoogleResult 構造体に `let totalCount: Int` を追加。

     👉 影響範囲は Google 関連の型・クラス内だけに閉じ閉鎖される！
        `RepositoryInterface`（プロトコル）、`YahooRepository`、`SearchService` 側のコードは【修正不要（修正ゼロ）】。
     */
}


// MARK: - 動作比較・利用コード例
// -----------------------------------------------------------------
func runComparisonExample() {
    
    // --- Phase5 の利用 ---
    
    // Yahooの実行
    let yahooRepo = Phase5_Comparison.YahooRepository()
    let yahooService = Phase5_Comparison.SearchService(repository: yahooRepo)
    
    yahooService.execute(param: "Swift DIP") { result in
        if case .success(let items) = result {
            print("Yahooタイトル: \(items.first?.title ?? "")")
        }
    }
    
    // Googleの実行（リクエスト型もレスポンス型も違うが、同じ SearchService 構造で扱える）
    let googleRepo = Phase5_Comparison.GoogleRepository()
    let googleService = Phase5_Comparison.SearchService(repository: googleRepo)
    let query = Phase5_Comparison.GoogleSearchQuery(keyword: "Swift DIP", page: 1)
    
    googleService.execute(param: query) { result in
        switch result {
        case .success(let items):
            // キャスト不要（as? などの危険な変換なし）でプロパティに直接アクセスできる！
            print("Google画像URL: \(items.first?.imageUrl ?? "")")
            
        case .failure(let error):
            // Google固有のエラーとして型安全に判定可能
            if error == .apiLimitExceeded {
                print("API上限エラー")
            }
        }
    }
}
