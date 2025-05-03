//
//  OutputProtocol.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/05/03.
//

import UIKit

/*
// Output編
// プロトコルによって要素間をつなぎ合わせて、依存性を注入していく例
// View（HogeViewController）がPresenterに依存しないように、プロトコル（HogeInputProtocol）を介してPresenterと連携

// MARK: - ViewController

class HugaViewController: UIViewController {
     
   // var presenter: HogePresenter! これはダメ
    var presenter: HugaInputProtocol! // プロトコルに準拠させて、Input用のメソッドを呼び出せるようにする
    
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

extension HugaViewController: HugaOutputProtocol {
    func showData() {
        // データ表示
    }
    
    func showEmpty() {
        // 空データ表示
    }
    
    func showError() {
        // エラー表示
    }
}

// MARK: - Presenter

protocol HugaInputProtocol: AnyObject {
    func didLoad()
    func didAuthButtonTapped()
    func didSelectRow(at indexPath: IndexPath)
}

protocol HugaOutputProtocol: AnyObject {
    func showData()
    func showEmpty()
    func showError()
}

class HugaPresenter {
    // プロトコルに準拠させて、Output用のメソッドを呼び出せるようにする
    var viewController: HugaOutputProtocol!
    
    init(viewController: HugaOutputProtocol) {
        self.viewController = viewController
    }
}

extension HugaPresenter: HugaInputProtocol {
    func didLoad() {
        
        /*
         API通信処理を行い、結果を取得
         */
        
        let result: String = "Data"
        
        // プロトコル経由で呼び出す
        switch result {
        case "Data":
            viewController.showData()
        case "Empty":
            viewController.showEmpty()
        case "Error":
            viewController.showEmpty()
        default:
            print("")
        }
    }
    
    func didAuthButtonTapped() {
        // プロトコル経由で呼び出す
        // 任意の処理を行い、VCに通知を行う
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        // プロトコル経由で呼び出す
        // 任意の処理を行い、VCに通知を行う
    }
}
// MARK: - エントリーポイント 依存性注入

class HugaEntryPoint {
    func main() {
        let hugaViewController = HugaViewController()
        hugaViewController.presenter = HugaPresenter(
            viewController: hugaViewController
        )
    }
}
*/
