//
//  Sample_VIPER_AppUITestsLaunchTests.swift
//  Sample-VIPER-AppUITests
//
//  Created by 鈴木 健太 on 2025/04/20.
//

import XCTest

// このクラスは、アプリ起動後の状態をスクリーンショット付きで検証するUIテストを定義します。
final class Sample_VIPER_AppUITestsLaunchTests: XCTestCase {

    // 各ターゲットアプリのUI構成ごとにこのテストを実行する必要があるかを指定します。
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        // 各テストメソッドの実行前に呼び出されるセットアップ処理。
        // テスト失敗時に即座に中断するように設定します。
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        // アプリを起動し、起動直後の画面をスクリーンショットとして保存するUIテスト。
        let app = XCUIApplication()
        app.launch()

        // アプリ起動後に実行する処理をここに記述（例：テストアカウントでログイン、画面遷移など）

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"  // スクリーンショットの名前を指定
        attachment.lifetime = .keepAlways  // スクリーンショットを常に保持する設定
        add(attachment)
    }
}
