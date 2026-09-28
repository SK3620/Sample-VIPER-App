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
    }
}
