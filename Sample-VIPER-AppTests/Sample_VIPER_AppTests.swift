//
//  Sample_VIPER_AppTests.swift
//  Sample-VIPER-AppTests
//
//  Created by 鈴木 健太 on 2025/04/20.
//

import XCTest

// @testable import CRUD（アプリ名）と記載することで（CRUD）アプリ内のpublic,internalシンボルのテストが可能になります。
// 今回のアプリ名は「Sample_VIPER_App」
@testable import Sample_VIPER_App

final class Sample_VIPER_AppTests: XCTestCase {
    
    /*
     setUpWithError()
     →各テストを実行する前に毎回呼ばれます。
     
     tearDownWithError()`
     →各テスト実行後に毎回呼ばれます。
     
     testExample()
     →テストコードのサンプルです。<test + テスト対象のメソッド名>
     
     testPerformanceExample()
     →パフォーマンステストのサンプルです。<testPerformance + テスト対象のメソッド名>
     
     
     実行順番
     setUpWithError()
     testExample()
     tearDownWithError()
     setUpWithError()
     testCulcAdd() （test任意のメソッド名()）
     tearDownWithError()
     */

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // MARK: - 練習
    // 足し算
    func testCulcAdd() throws {
        XCTAssertEqual(Calculator().calcAdd(a: 27 , b: 2) , 29)
        XCTAssertEqual(Calculator().calcAdd(a: 2 , b: 2) , 4)
    }

    // 引き算
    func testCulcSub() throws {
        XCTAssertEqual(Calculator().calcSub(a: 27 , b: 2) , 25)
        XCTAssertEqual(Calculator().calcSub(a: 2 , b: 22) , -20)
    }

    // 割り算
    func testCulcDiv() throws {
        XCTAssertEqual(Calculator().calcDiv(a: 27 , b: 2) , 13)
        XCTAssertEqual(Calculator().calcDiv(a: 2 , b: 2) , 1)
    }

    // 掛け算
    func testCulcMulti()throws {
        XCTAssertEqual(Calculator().calcMulti(a: 27 , b: 2) , 54)
        XCTAssertEqual(Calculator().calcMulti(a: 3 , b: 2) , 6)
    }
}
