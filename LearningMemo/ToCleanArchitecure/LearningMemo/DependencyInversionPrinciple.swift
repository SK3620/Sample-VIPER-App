//
//  DependencyInversionPrinciple.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2026/09/28.
//


// =================================================================
// 依存関係逆転の原則 (DIP: Dependency Inversion Principle)
// =================================================================
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
// 【改善点】サブクラスを作ればモックを注入してテスト可能になった。
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
        private let repository: YahooRepository

        // イニシャライザ経由で外から注入（DI）
        init(repository: YahooRepository) {
            self.repository = repository
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
        
    }
}
