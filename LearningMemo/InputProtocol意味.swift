//
//  InputProtocol.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/05/03.
//

import UIKit

// Input編
// プロトコルによって要素間をつなぎ合わせて、依存性を注入していく例
// View（HogeViewController）がPresenterに依存しないように、プロトコル（HogeInputProtocol）を介してPresenterと連携

/*
 1. HogeViewControllerはユーザー操作を受け取り、Presenterに通知（プロトコルを通じて）⬇︎
 HogeViewController は HogePresenter ではなく HogeInputProtocol に依存 → 疎結合の実現し、密結合を解消している
 （密結合とは、例えば、Presenterクラス内で直接Interactorのクラスのインスタンを生成しているが故に、PresenterがInteracterを知っている状態のこと。これでは、クラス単体でのテストがしにくくなるデメリットがあるため、依存性注入で、例えば、外から、テスト用or本番用のInteracterクラスのインスタンスを切り替えて、差し込むようにしてあげる）
 
 2. PresenterはViewからの通知を受け取り、ロジックを実行
 */

// MARK: - ViewController

class HogeViewController: UIViewController {
     
   // var presenter: HogePresenter! これはダメ
    // プロトコルに準拠させて、Input用のメソッドを呼び出せるようにする
    var presenter: HogeInputProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // プロトコル経由で呼び出す
        presenter.didLoad()
    }
    
    @IBAction func authButtonTapped(_ sender: Any) {
        // プロトコル経由で呼び出す
        presenter.didAuthButtonTapped()
    }
    
    @IBAction func tableViewSelectedRow(_ sender: Any) {
        let indexPath = IndexPath(row: 0, section: 0)
        // プロトコル経由で呼び出す
        presenter.didSelectRow(at: indexPath)
    }
}

// MARK: - Presenter

protocol HogeInputProtocol {
    func didLoad()
    func didAuthButtonTapped()
    func didSelectRow(at indexPath: IndexPath)
}

class HogePresenter {
    
}

extension HogePresenter: HogeInputProtocol {
    func didLoad() {
        
    }
    
    func didAuthButtonTapped() {
        
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        
    }
}

// MARK: - エントリーポイント

class EntryPoint {
    func main() {
        let hogeViewController = HogeViewController()
        hogeViewController.presenter = HogePresenter()
    }
}
