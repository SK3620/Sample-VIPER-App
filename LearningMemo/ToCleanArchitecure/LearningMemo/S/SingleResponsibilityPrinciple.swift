
//
//  aaa.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2026/10/03.
//

import Foundation

// =================================================================
// 単一責任の原則 (SRP) における「テスタブル」と「拡張性」
// =================================================================

/*
 💡 要点サマリー
 -----------------------------------------------------------------
 1. テスタブル（テストのしやすさ）
    - 責任が混ざっていると、テストしたいロジックの裏で「DB保存」などの副作用が走り、
      テストが複雑化・不安定になる。
    - 責任を分離すれば、関係ない処理（副作用）を気にせず、そのクラス単体のロジックだけを
      ピンポイントかつ高速に単体テスト（Unit Test）できる。

 2. 拡張性（変更・追加のしやすさ）
    - 責任が混ざっていると、1つの機能を拡張（修正）した際に関係ない機能まで破壊する（デグレ）。
    - 責任を分離すれば、影響範囲がそのクラス内だけに閉じるため、
      他の動いている機能を一切壊さずに安全にコードを追加・拡張できる。
 -----------------------------------------------------------------
 */


// MARK: - ❌ 【Before】SRP違反：テスタブルでも拡張性も低いコード
// -----------------------------------------------------------------
enum SRP_Metrics_Before {

    class SearchService {
        
        // 🚨 1つのクラス・メソッドの中に「検索処理」「データ加工」「DB保存」「ログ送信」が混在
        func search(keyword: String) -> [String] {
            // 1. 検索処理
            let results = ["Yahoo: \(keyword)"]
            
            // 2. データ加工
            let processed = results.map { "[加工] " + $0 }
            
            // 3. ローカルDB（UserDefaults等）への保存（副作用）
            UserDefaults.standard.set(keyword, forKey: "last_search_query")
            
            // 4. アナリティクスへのログ送信（副作用）
            print("[Analytics] Event: search, Keyword: \(keyword)")
            
            return processed
        }
    }

    /*
     🚨 【なぜテストしづらいのか？】
     - 「データ加工ロジック」だけをテストしたいのに、裏で `UserDefaults` の書き換えや
       ログ送信が勝手に走ってしまう。
     - テストの前に DB をクリーンアップする等の前処理・後処理が必要になり、テストコードが肥大化する。

     🚨 【なぜ拡張しづらいのか？】
     - 「ログ送信にユーザーIDも含めたい」というアナリティクス側の機能拡張が入った時、
       関係ない `SearchService` 自体を修正しなければならない。
     - ログ送信コードを直した拍子に、うっかりデータ加工ロジックをバグらせるリスクが生じる。
     */
}


// MARK: - ⭕️ 【After】SRP準拠：テスタブルで拡張性が高いコード
// -----------------------------------------------------------------
enum SRP_Metrics_After {

    // --- 責務ごとに分離されたコンポーネント ---

    // ⭕️ 1. データ加工ロジック担当（純粋な関数・副作用なし）
    class SearchDataProcessor {
        func process(results: [String]) -> [String] {
            return results.map { "[加工] " + $0 }
        }
    }

    // ⭕️ 2. 履歴の保存担当
    protocol HistoryStoreProtocol {
        func save(keyword: String)
    }
    class LocalHistoryStore: HistoryStoreProtocol {
        func save(keyword: String) {
            UserDefaults.standard.set(keyword, forKey: "last_search_query")
        }
    }

    // ⭕️ 3. アナリティクス担当
    protocol AnalyticsLoggerProtocol {
        func logSearch(keyword: String)
    }
    class AnalyticsLogger: AnalyticsLoggerProtocol {
        func logSearch(keyword: String) {
            print("[Analytics] Event: search, Keyword: \(keyword)")
        }
    }


    // MARK: - 💡 1. 「テスタブル（テストしやすい）」の実証
    // -------------------------------------------------------------
    /*
     `SearchDataProcessor` はDBや通信などの副作用を持たないため、
     1ミリ秒＆完全に孤立した環境でテストが可能！
     */
    static func test_SearchDataProcessor_加工ロジックの単体テスト() {
        let processor = SearchDataProcessor()
        let input = ["Yahoo: Swift"]
        
        // ⭕️ 副作用（DB保存や通信）が一切発生しないため、超高速＆超安全にテストできる！
        let output = processor.process(results: input)
        
        assert(output == ["[加工] Yahoo: Swift"])
        print("✅ テスト成功: 副作用なしでロジックのみを検証できた！")
    }


    // MARK: - 💡 2. 「拡張性が高い（安全に拡張できる）」の実証
    // -------------------------------------------------------------
    /*
     【拡張シナリオ】
     「アナリティクスログの送信先を Firebase に変更し、ユーザーIDも送るように拡張したい」
     */
    
    // ⭕️ 既存の検索機能や加工ロジックには1行も触れず、新しいクラスを追加・修正するだけで拡張完了！
    class FirebaseAnalyticsLogger: AnalyticsLoggerProtocol {
        private let userId: String
        
        init(userId: String) {
            self.userId = userId
        }
        
        func logSearch(keyword: String) {
            // ✨ 検索ロジックを壊すリスクゼロで、ログ送信の仕様変更・拡張ができる！
            print("[Firebase] User: \(userId), Event: search, Keyword: \(keyword)")
        }
    }
}


// MARK: - 🧪 動作確認（Playground等で実行可能）
// -----------------------------------------------------------------
func testSRP_Metrics() {
    // 1. テストの実行
    SRP_Metrics_After.test_SearchDataProcessor_加工ロジックの単体テスト()
    
    // 2. 拡張した Logger を差し替えて実行
    let extendedLogger = SRP_Metrics_After.FirebaseAnalyticsLogger(userId: "USER_12345")
    extendedLogger.logSearch(keyword: "Swift DIP")
}
