//
//  UseCase共通化意味②.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/05/03.
//

import UIKit

// UseCaseを共通化する意味を理解する②

// MARK: - ViewController

class HogeHogeViewController: UIViewController {
     
    var presenter: HogeHogeInputProtocol!
    
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

extension HogeHogeViewController: HogeHogeOutputProtocol {
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

// MARK: - Presenter HogeHogeDependencyがタイプセーフでない問題を引き起こす

protocol HogeHogeInputProtocol: AnyObject {
    func didLoad()
    func didAuthButtonTapped()
    func didSelectRow(at indexPath: IndexPath)
}

protocol HogeHogeOutputProtocol: AnyObject {
    func showData()
    func showEmpty()
    func showError()
}

class HogeHogePresenter {

    var viewController: HogeHogeOutputProtocol!
    
    var HogeHogeDependency: HogeHogeDependency!
    
    struct HogeHogeDependency {
        var getDataUseCase: any HogeHogeUseCaseProtocol
    }
    
    init(viewController: HogeHogeOutputProtocol, dependency: HogeHogeDependency) {
        self.viewController = viewController
        self.HogeHogeDependency = dependency
    }
}

extension HogeHogePresenter: HogeHogeInputProtocol {
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

// MARK: - UseCase

protocol HogeHogeUseCaseProtocol where Failure: Error {
    associatedtype Parameter
    associatedtype Success
    associatedtype Failure
    
    func execute(_ parameter: Parameter, completion: @escaping (Result<Success, Failure>) -> Void)
}

class GetDataHogeHogeUseCase: HogeHogeUseCaseProtocol {
    func execute(_ parameter: Void, completion: @escaping (Result<[HogeHogeDataEntity], Error>) -> Void) {
        // API通信処理
        let res = [
            HogeHogeDataEntity(id: 1, text: "あ", createdAt: Date()),
            HogeHogeDataEntity(id: 2, text: "い", createdAt: Date()),
            HogeHogeDataEntity(id: 3, text: "う", createdAt: Date())
            ]
        completion(.success(res))
    }
}

// MARK: - UseCase 共通化

class HogeHogeUseCase<Parameter, Success, Failure: Error> {
    
    // private let useCase: HogeHogeUseCaseInstance<<#T: HogeHogeUseCaseProtocol#>>
    
    init<T: HogeHogeUseCaseProtocol>(_ useCase: T) where T: UseCaseProtocol, T.Parameter == Parameter, T.Success == Success, T.Failure == Failure
    {
        // self.useCase = HogeHogeUseCaseInstance<T>(useCase)
    }
    
    func execute(_ parameter: Parameter, completion: @escaping ((Result<Success, Failure>) -> ())) {
        
    }
}

private extension HogeHogeUseCase {
    class HogeHogeUseCaseInstance<T: HogeHogeUseCaseProtocol> {
        
        private let useCase: T
        
        init(_ useCase: T) {
            self.useCase = useCase
        }
                
        // UseCaseInstanceはUseCaseInstanceBaseを継承しているためoverride可能
        func execute(_ parameter: T.Parameter, completion: @escaping ((Result<T.Success, T.Failure>) -> ())) {
            // ここで実際のロジック処理を読んでいる
            useCase.execute(parameter, completion: completion)
            /*
             useCaseの型は以下になる
             ・GetArticlesArrayUseCase
             ・GetArticleByIdUseCase
             */
        }
    }
}

// MARK: - Entity

struct HogeHogeDataEntity {
    var id: Int
    var text: String
    var createdAt: Date
}

// MARK: - エントリーポイント 依存性注入

class HogeHogeEntryPoint {
    func main() {
        let HogeHogeViewController = HogeHogeViewController()
        HogeHogeViewController.presenter = HogeHogePresenter(
            viewController: HogeHogeViewController,
            dependency: .init(
                getDataUseCase: GetDataUseCase() as! (any HogeHogeUseCaseProtocol)
            )
        )
    }
}
