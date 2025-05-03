//
//  UseCase.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/05/03.
//


import UIKit

// UseCaseを共通化する意味を理解する
// 注目ポイントは、以下のコード
/*
struct HugaDependency {
     var getDataUseCase: any HugaUseCaseProtocol // これがダメ
}
 */


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

// MARK: - Presenter HugaDependencyがタイプセーフでない問題を引き起こす

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
    
    var hugaDependency: HugaDependency!
    
    struct HugaDependency {
        var getDataUseCase: any HugaUseCaseProtocol
    }
    
    init(viewController: HugaOutputProtocol, dependency: HugaDependency) {
        self.viewController = viewController
        self.hugaDependency = dependency
    }
}

extension HugaPresenter: HugaInputProtocol {
    func didLoad() {
        
        /*
         API通信処理を行い、結果を取得
         */
        
        
        /*
        var getDataUseCase: any HugaUseCaseProtocolの場合、
         ・開発者自身が気を付ける必要がある
         ・以下のように引数に渡したい型がわからない
         ・取得した結果のデータの型がわからない
         ・わざわざ、castできるかを判断して、castする必要がある
         ・そもそもタイプセーフではない
         
        hugaDependency.getDataUseCase.execute(<#T##parameter: any HugaUseCaseProtocol.Parameter##any HugaUseCaseProtocol.Parameter#>, completion: <#T##(Result<any HugaUseCaseProtocol.Success, any HugaUseCaseProtocol.Failure>) -> Void#>)
        
        hugaDependency.getDataUseCase.execute(parameter: Void) { [weak self] result in
            switch result {
            case .success(<#T##Any#>):
            case.failure(<#T##Error#>)
            }
        }
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

// MARK: - UseCase

protocol HugaUseCaseProtocol: AnyObject {
    associatedtype Parameter
    associatedtype Success
    associatedtype Failure: Error
    
    func execute(_ parameter: Parameter, completion: @escaping (Result<Success, Failure>) -> Void)
}

class GetDataUseCase: HugaUseCaseProtocol {
    func execute(_ parameter: Void, completion: @escaping (Result<[HugaDataEntity], Error>) -> Void) {
        let res = [
            HugaDataEntity(id: 1, text: "あ", createdAt: Date()),
            HugaDataEntity(id: 2, text: "い", createdAt: Date()),
            HugaDataEntity(id: 3, text: "う", createdAt: Date())
            ]
        completion(.success(res))
    }
}

// MARK: - Entity

struct HugaDataEntity {
    var id: Int
    var text: String
    var createdAt: Date
}

// MARK: - エントリーポイント 依存性注入

class HugaEntryPoint {
    func main() {
        let hugaViewController = HugaViewController()
        hugaViewController.presenter = HugaPresenter(
            viewController: hugaViewController,
            dependency: .init(
                getDataUseCase: GetDataUseCase()
            )
        )
    }
}
