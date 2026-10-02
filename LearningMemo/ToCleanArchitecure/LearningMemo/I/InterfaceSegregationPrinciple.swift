//
//  InterfaceSegregationPrinciple.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2026/10/01.
//

// =================================================================
// インターフェース分離の原則 (DIP: Interface Segregation Principle)
// =================================================================

/**
 SOLID原則の「I」に当たる部分。
 「インターフェース分離の原則」は、「クライアントに対し、利用しないインターフェースへの依存を強制しないべき」という原則です。
 */

/*
 💡 要するにどういうこと？
 -----------------------------------------------------------------
 「クライアント（使う側・実装する側）に対し、利用しない不必要な機能（プロトコル）への依存を強制すべきではない」という設計原則。

 🚨 違反した時の問題点（Before）:
   1. 実装側: 不要なメソッドの実装を強要され、`preconditionFailure` や空実装で誤魔化すハメになる。
   2. 利用側: 巨大なプロトコルを受け取るため、使わない機能まで見えてしまったり、特定クラス（`as?`）での条件分岐が必要になる。

 ⭕️ 解決策（After）:
   1. 巨大なプロトコルを、役割ごとに小さく単一なプロトコル（`Vehicle`, `Aircraft` など）へ分割する。
   2. 必要な機能だけを組み合わせて適合（コンポジション）させる。
 -----------------------------------------------------------------
 */


// MARK: - ❌ 【Before】ISPに違反したコード（巨大すぎるプロトコル）
// -----------------------------------------------------------------
enum ISP_Before {

    // ❌ 乗り物プロトコルに「飛ぶ (fly)」まで詰め込んでしまっている
    protocol Vehicle {
        func startEngine()
        func run()
        func fly() // 🚨 車など飛ばない乗り物には不要なメソッド！
    }

    // 自動車クラス（飛べないのに fly() の実装を強制される）
    class Car: Vehicle {
        func startEngine() { print("エンジン始動") }
        func run() { print("走行中") }
        
        // 🚨 使わないのに実装させられるため、クラッシュさせるなどのバッドノウハウになる
        func fly() {
            preconditionFailure("車は飛びません！")
        }
    }

    // 飛行機クラス（走ることも飛ぶこともできる）
    class Airplane: Vehicle {
        func startEngine() { print("エンジン始動") }
        func run() { print("滑走中") }
        func fly() { print("飛行中") }
    }

    // 運転手（自動車も飛行機もまとめて Vehicle として扱う）
    class Driver {
        func drive(vehicle: Vehicle) {
            vehicle.startEngine()
            vehicle.run()
            
            // 🚨 車か飛行機かをダウンキャストして判定せざるを得ず、コードが汚くなる
            if let plane = vehicle as? Airplane {
                plane.fly()
            }
        }
    }
}


// MARK: - ⭕️ 【After】ISPに準拠したコード（プロトコルの分離）
// -----------------------------------------------------------------
enum ISP_After {

    // ⭕️ 1. 基本的な「陸上乗り物」の役割だけに限定
    protocol Vehicle {
        func startEngine()
        func run()
    }

    // ⭕️ 2. 「空を飛ぶ機能」を別のプロトコルに分離（Vehicleを継承してもOK）
    protocol Aircraft: Vehicle {
        func fly()
    }

    // 自動車は Vehicle だけに適合（fly() の実装を強制されない！）
    class Car: Vehicle {
        func startEngine() { print("エンジン始動") }
        func run() { print("走行中") }
    }

    // 飛行機は Aircraft（Vehicle + fly）に適合
    class Airplane: Aircraft {
        func startEngine() { print("エンジン始動") }
        func run() { print("滑走中") }
        func fly() { print("飛行中") }
    }

    // ⭕️ 3. 利用する側（Driver / Pilot）も必要なインターフェースだけに依存する
    
    // 一般の運転手は「陸上乗り物 (Vehicle)」だけ知っていれば良い
    class Driver {
        func drive(vehicle: Vehicle) {
            vehicle.startEngine()
            vehicle.run()
            // fly() の存在自体を知らない（見えない）ため安全！
        }
    }

    // パイロットは「航空機 (Aircraft)」を扱う
    class Pilot {
        func fly(aircraft: Aircraft) {
            aircraft.startEngine()
            aircraft.run()
            aircraft.fly()
        }
    }
}


// MARK: -  Swiftでの実践：プロトコル合成（Protocol Composition）
// -----------------------------------------------------------------
/*
 Swiftではインターフェースを小さく分けておき、必要に応じて `&` で合成するのが強力です。
 */
enum ISP_Advanced {
    
    protocol Runnable { func run() }
    protocol Flyable { func fly() }
    protocol Swimmable { func swim() }

    // 陸空両用車なら必要なものだけ選んで適合できる
    class FlyingCar: Runnable, Flyable {
        func run() { print("走る") }
        func fly() { print("飛ぶ") }
    }

    // 受け取り側も合成して指定可能（走れて泳げるもの）
    func inspectAmphibian(vehicle: Runnable & Swimmable) {
        vehicle.run()
        vehicle.swim()
    }
}
