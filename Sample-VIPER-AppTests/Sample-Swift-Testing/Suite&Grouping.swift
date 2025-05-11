//
//  Sample_Swift_Testing.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/05/11.
//

import Testing

@Suite("サンプルテスト関連のテストスイート")
struct Sample_Swift_Testing {
    
    @Test("サンプルテスト！！！")
    func testExample() throws {
        
    }
}

// MARK: - テストスイートやテストケースをグルーピングできるようになった

/*
テストケースメソッド(@Testのついた関数)を持つ型(struct や class,enum など)はテストスイートとして扱われます。
テストスイートは、XCTest でいうところのXCTestCaseに準拠した型です。
テストスイートはネストさせると、階層構造を持つテストスイートを作ることができます。
 */

@Suite("計算テスト") // @Suite なしだと、「CalculatorTest」が表示名となる
struct CalculatorTest {

    struct MultiplicationTest {

        @Test
        func 掛け算は左辺と右辺を掛けた値を返す() throws {

            #expect(10 == Calculator2.multiplication(2, 5))
        }
    }

    struct DivisionTest {

        @Test
        func 割り算は右辺が0でなければ左辺を右辺で割った値を返す() throws {

            #expect(5 == Calculator2.division(10, 2))
        }

        @Test
        func 割り算は右辺が0の場合はnilを返す() throws {

            #expect(nil == Calculator2.division(10, 0))
        }
    }
}

enum Calculator2 {

    static func division(_ value1: Double, _ value2: Double) -> Double? {

        if value2 == .zero {

            return nil
        }

        return value1 / value2
    }
    
    static func multiplication(_ value1: Double, _ value2: Double) -> Double? {

        if value2 == .zero {

            return nil
        }

        return value1 * value2
    }

}


// MARK: - Tag でテストスイートやテストケースをグルーピングもできる

extension Tag {
    @Tag static var stable: Tag
}

@Suite(.tags(.stable))
struct CalculatorTest2 {

    struct MultiplicationTest {

        @Test
        func 掛け算は左辺と右辺を掛けた値を返す() throws {

            #expect(10 == Calculator2.multiplication(2, 5))
        }
    }

    struct DivisionTest {

        @Test
        func 割り算は右辺が0でなければ左辺を右辺で割った値を返す() throws {

            #expect(5 == Calculator2.division(10, 2))
        }

        @Test
        func 割り算は右辺が0の場合はnilを返す() throws {

            #expect(nil == Calculator2.division(10, 0))
        }
    }
}

