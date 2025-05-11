//
//  ResultCompare.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/05/11.
//

import Testing

// MARK: - 結果の比較

/*
 XCTest では結果の比較を行うのに、XCTAssertEqualeやXCTAssertTrue、XCTAssertThrowsError
 など検証する結果の型などによってメソッド名が複数ありました。
 Swift Testing では#expectでまとまっているので、結果の検証をするときに何のメソッドを使おうか悩むことが減るのかなと思いました。

 */

// MARK: - 非同期処理の検証

// 非同期でイベントを送信するクラス テスト内ではなく、View側に書かれている想定
class EventEmitter {
    var onEvent: ((String) -> Void)?

    func sendEvent(after seconds: Double, value: String) {
        Task {
            try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            onEvent?(value)
        }
    }
}

struct EventEmitterTest {

    @Test
    func イベント送信後に値を受け取れることを検証する() async throws {
        let emitter = EventEmitter()
        
        /*
         func confirmation<R>(
             _ comment: Comment? = nil,
             expectedCount: Int = 1,
             isolation: isolated (any Actor)? = #isolation,
             sourceLocation: SourceLocation = #_sourceLocation,
             _ body: (Confirmation) async throws -> sending R
         ) async rethrows -> R
         */
        await confirmation { complete in
            emitter.onEvent = { value in // クロージャを渡しておく
                #expect(value == "hello") // 値を検証
                complete()                // 検証成功の合図
            }

            emitter.sendEvent(after: 1, value: "hello")
        }
    }

    /*
     ✅ 特徴:
     - confirmation のクロージャが `async` なため、自然な非同期コードが書ける
     - Swift Concurrency と相性が良く、非同期処理とテストの親和性が高い
     - テストの意図（何を検証し、何を待つか）が明確に読み取れる
     */
}


// MARK: - オプショナル検証

// アプリ側にあるユースケースの想定
struct UserManager {
    private let users = [
        1: "Alice",
        2: "Bob",
        3: "Charlie"
    ]
    
    func getUserName(for id: Int) -> String? {
        users[id]
    }
}

struct UserManagerTest {

    @Test
    func 存在するユーザーIDでユーザー名を取得できること() throws {
        let manager = UserManager()

        // #require によって Optional をアンラップ
        // nil の場合は即座にテスト失敗
        let userName = try #require(manager.getUserName(for: 2))

        // 値の検証
        #expect(userName == "Bob")
    }

    @Test
    func 存在しないユーザーIDではテストが失敗すること() throws {
        let manager = UserManager()

        // ID 99 は存在しないため nil を返す
        // よってこのテストは失敗する（意図的な失敗テストとして記述）
        _ = try #require(manager.getUserName(for: 99))
    }

    @Test
    func 条件によってBoolをrequireで検証する例() throws {
        let age = 18

        // 条件が false の場合もテストは失敗する
        try #require(age >= 18)
    }
}

