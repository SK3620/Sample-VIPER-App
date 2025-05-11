//
//  Sample_VIPER_AppUITests.swift
//  Sample-VIPER-AppUITests
//
//  Created by 鈴木 健太 on 2025/04/20.
//

import XCTest

// このクラスは、Sample-VIPER-App のUIテストを定義するクラスです。
final class Sample_VIPER_AppUITests: XCTestCase {

    override func setUpWithError() throws {
        // 各テストメソッド実行前に呼び出されるセットアップ処理。
        // UIテストでは、失敗時に即座にテストを停止する設定が一般的です。
        continueAfterFailure = false

        // 初期状態（インターフェースの向きなど）を設定するのに適しています。
    }

    override func tearDownWithError() throws {
        // 各テストメソッド実行後に呼び出されるクリーンアップ処理。
    }

    @MainActor
    func testExample() throws {
        // UIテストの基本例。
        // テスト対象アプリを起動し、最低限の確認を行うテンプレート。
        let app = XCUIApplication()
        app.launch()

        // XCTAssert などを使ってテスト結果を検証できます。
    }

    @MainActor
    func testLaunchPerformance() throws {
        // アプリの起動パフォーマンスを測定するテスト。
        // iOS 13 以降などの特定のOSバージョンでのみ実行されます。
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
