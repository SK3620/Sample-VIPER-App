//
//  BugAssociation.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/05/11.
//

import Testing

// MARK: - テストとバグを関連づけられるようになった

/*
@Testマクロにbugの引数に、バグトラッキングツールで管理しているバグの URL であったり ID を指定することで、バグとテストを関連づけることができます。
 */

@Suite("計算テスト4")
struct CalculatorTest4 {

    struct MultiplicationTest {

        @Test(.bug("https://developer.apple.com/documentation/testing/trait/bug(_:_:)", "バグID:123"))
        func 掛け算は左辺と右辺を掛けた値を返す() throws {

            #expect(11 == Calculator2.multiplication(2, 5))
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
