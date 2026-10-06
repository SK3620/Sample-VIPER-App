//
//  aaa.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2026/10/06.
//

import Foundation

// =================================================================
// 開放/閉鎖の原則 (OCP: Open/Closed Principle)
// =================================================================

/*
 💡 要するにどういうこと？
 -----------------------------------------------------------------
 「ソフトウェアの構成要素（クラス、モジュール等）は、
   拡張に対して開いて（Open）いなければならず、
   修正に対して閉じて（Closed）いなければならない」という原則。

 1. 拡張に対して開いている (Open)
    -> 新しい機能（例: Google検索、楽天検索など）をいくらでも「追加・拡張」できる状態。
 2. 修正に対して閉じている (Closed)
    -> 新機能を追加する際に、既存のテスト済みコード（`SearchService` 等）を「1行も書き換える必要がない」状態。

 🚨 違反した時の問題点（Before）:
   - 新しいデータ取得先を1つ増やすたびに、`SearchService` 内の `switch` 文や `if` 文を書き換える（修正する）必要がある。
   - 既存のコードをいじるため、すでに動いていた他の検索処理（Yahoo等）をバグらせる（デグレ）リスクが常に付きまとう。

 ⭕️ 解決策（After）:
   - プロトコル（抽象）に依存させ、依存性注入（DI）を活用する。
   - 新機能の追加は「新クラスの作成」だけで完結させ、既存クラスには指一本触れない。
 -----------------------------------------------------------------
 */


// MARK: - ❌ 【Before】OCPに違反したコード（機能追加のたびに既存コードを修正）
// -----------------------------------------------------------------
enum OCP_Before {

    class YahooRepository {
        func fetch(keyword: String) -> [String] {
            return ["Yahoo結果: \(keyword)"]
        }
    }

    class GoogleRepository {
        func fetch(keyword: String) -> [String] {
            return ["Google結果: \(keyword)"]
        }
    }

    // 🚨 検索プロバイダの種類
    enum SearchType {
        case yahoo
        case google
        // 🚨 「楽天検索を追加したい！」となったらここに `.rakuten` を追加して...
    }

    class SearchService {
        private let yahooRepo = YahooRepository()
        private let googleRepo = GoogleRepository()

        // 🚨 違反ポイント: 新しい検索機能を追加するたびに、この `search` メソッド内（既存コード）を修正する必要がある！
        func search(keyword: String, type: SearchType) -> [String] {
            switch type {
            case .yahoo:
                return yahooRepo.fetch(keyword: keyword)
            case .google:
                return googleRepo.fetch(keyword: keyword)
            // 🚨 新機能追加のたびに case を書き足さなければならず「修正に対して閉じられていない（Closedになっていない）」
            }
        }
    }
}


// MARK: - ⭕️ 【After】OCPに準拠したコード（新クラス追加だけで拡張完了）
// -----------------------------------------------------------------
enum OCP_After {

    // ⭕️ 1. 抽象（プロトコル）を定義
    protocol SearchRepositoryProtocol {
        func fetch(keyword: String) -> [String]
    }

    // ⭕️ 2. 具象クラス（Yahoo）
    class YahooRepository: SearchRepositoryProtocol {
        func fetch(keyword: String) -> [String] {
            return ["Yahoo結果: \(keyword)"]
        }
    }

    // ⭕️ 3. 具象クラス（Google）
    class GoogleRepository: SearchRepositoryProtocol {
        func fetch(keyword: String) -> [String] {
            return ["Google結果: \(keyword)"]
        }
    }

    // ⭕️ 4. 利用側はプロトコル（抽象）だけに依存させる
    class SearchService {
        private let repository: SearchRepositoryProtocol

        init(repository: SearchRepositoryProtocol) {
            self.repository = repository
        }

        func search(keyword: String) -> [String] {
            // switch文による分岐は一切なし！
            return repository.fetch(keyword: keyword)
        }
    }

    // -------------------------------------------------------------
    // 💡 【拡張の実戦】「楽天検索機能を追加したい！」という要求が来た場合
    // -------------------------------------------------------------
    
    // ✨ 既存のコード（`SearchService` や `YahooRepository` など）は【1行も修正不要】！
    // 完全に新しいクラスを作成（＝拡張に対してOpen）するだけで完了する。
    class RakutenRepository: SearchRepositoryProtocol {
        func fetch(keyword: String) -> [String] {
            return ["楽天結果: \(keyword)"]
        }
    }
}


// MARK: - 🧪 動作確認（Playground等で実行可能）
// -----------------------------------------------------------------
func testOCP() {
    // 1. Yahooで検索
    let yahooService = OCP_After.SearchService(repository: OCP_After.YahooRepository())
    print(yahooService.search(keyword: "Swift"))

    // 2. 新しく追加した 楽天 で検索（SearchServiceのコード変更ゼロで拡張できている）
    let rakutenService = OCP_After.SearchService(repository: OCP_After.RakutenRepository())
    print(rakutenService.search(keyword: "Swift"))
}
