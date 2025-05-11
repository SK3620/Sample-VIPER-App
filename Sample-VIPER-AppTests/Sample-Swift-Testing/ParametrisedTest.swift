//
//  parametrisedTest.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/05/11.
//

import Testing

// MARK: - パラメタライズドテスト

struct MathUtil {
    static func isEven(_ value: Int) -> Bool {
        return value % 2 == 0
    }
}

// MARK: - パラメタライズドテストを使わない冗長なテストケース

@Suite("冗長なテストコード")
struct IsEvenTestLegacy {

    @Test
    func 値が2のときはtrueを返す() throws {
        #expect(MathUtil.isEven(2) == true)
    }

    @Test
    func 値が4のときはtrueを返す() throws {
        #expect(MathUtil.isEven(4) == true)
    }

    @Test
    func 値が3のときはfalseを返す() throws {
        #expect(MathUtil.isEven(3) == false)
    }

    @Test
    func 値が5のときはfalseを返す() throws {
        #expect(MathUtil.isEven(5) == false)
    }

    /*
     ❌ 問題点：
     - テスト対象ロジック（MathUtil.isEven）はすべて同じなのに、テストメソッドが分かれており冗長。
     - ケースが増えるほど同じようなコードを量産することになる。
     - 保守性・可読性ともに低下。
     */
}

// MARK: - パラメタライズドテストを使った簡潔なテストケース

// IsEvenTestParametrized 失敗😔
@Suite("簡素化されたテストコード")
struct IsEvenTestParametrized {

    // 値の偶数判定に失敗！
    @Test("簡素化されたテストコード" ,arguments: [
        (2, true),
        (4, true),
        (3, false),
        (5, false),
        (7, true) // あえて失敗
    ])
    func 値が偶数かどうかを判定する(
        value: Int,
        expected: Bool
    ) throws {
        #expect(MathUtil.isEven(value) == expected)
    }

    /*
     ✅ 改善点：
     - @Test(arguments:) に配列形式で入力値と期待値のペアを定義。
     - テスト対象ロジックを1つのメソッドでカバー。
     - ケース追加が容易（配列に1行追加するだけ）。
     - 保守性と可読性が大きく向上。
     */
}

