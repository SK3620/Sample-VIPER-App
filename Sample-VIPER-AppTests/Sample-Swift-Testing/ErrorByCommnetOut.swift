//
//  ErrorByCommnetOut.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/05/11.
//

import Testing

// MARK: - テストコードにコメントを付与することで、テスト失敗時にコメントの内容を表示

// 計算ロジックの検証に失敗しちゃったよ
@Suite("計算ロジックの検証")
struct CalculatorTest3 {

    // 掛け算の検証に失敗しちゃったよ
    // ⚠️ エラー時、テスト結果ログに「掛け算の検証に失敗しちゃったよ」を出力させるには @Suite を付与する
    struct MultiplicationTest {

        // 掛け算の結果を検証
        // 失敗した場合は　Calculator2.multiplication　に問題あり！
        @Test
        func 掛け算は左辺と右辺を掛けた値を返す() throws {

            #expect(11 == Calculator2.multiplication(2, 5))
            // #expect(10 == Calculator2.multiplication(2, 5))
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

