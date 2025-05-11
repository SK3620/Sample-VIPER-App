//
//  ArticleListUITests.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/05/11.
//

import XCTest

final class ArticleListUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    // 記事が一覧に表示されるか
    func test_articleList_showsArticles() {
        let articleListTableView = app.tables["articleListTableView"]
        XCTAssertTrue(articleListTableView.waitForExistence(timeout: 5), "記事一覧のテーブルが表示されない")
        
        XCTAssertGreaterThan(articleListTableView.cells.count, 0, "記事が表示されていない")
    }

    // 記事押下後、記事詳細画面へ遷移するか
    func test_articleSelection_showsDetailScreen() {
        let articleListTableView = app.tables["articleListTableView"]
        XCTAssertTrue(articleListTableView.waitForExistence(timeout: 5), "記事一覧が表示されない")

        let firstCell = articleListTableView.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists, "1件目の記事が存在しない")
        
        firstCell.tap()
        
        // NavigationBar の[Back]ボタンの取得
        // VC にて self.title = "記事一覧" としている
        let backButton = app.buttons["記事一覧"]
        XCTAssert(backButton.waitForExistence(timeout: 5))
        
        backButton.tap()
        
        let articleListTableView2 = app.tables["articleListTableView"]
        XCTAssertTrue(articleListTableView2.waitForExistence(timeout: 5), "記事一覧が表示されない")

        let firstCell2 = articleListTableView2.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell2.exists, "1件目の記事が存在しない")
    }
}
