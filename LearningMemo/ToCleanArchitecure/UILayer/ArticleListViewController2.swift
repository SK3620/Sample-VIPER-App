//
//  ArticleListViewController.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2026/09/26.
//

import UIKit
import Combine

class ArticleListViewController2: UIViewController {
    
    private var viewModel: ArticleListViewModel2!
    private var cancellables = Set<AnyCancellable>()
    private var tableView: UITableView!
    
    // Dependency Injection
    convenience init(viewModel: ArticleListViewModel2) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        
        viewModel.onViewDidLoad()
    }
    
    private func bindViewModel() {
        // ViewModelの状態変化を購読して描画を自動更新
        viewModel.$articles
            .sink { [weak self] _ in self?.tableView.reloadData() }
            .store(in: &cancellables)
        
        viewModel.$isEmpty
            .sink { [weak self] isEmpty in self?.tableView.isHidden = isEmpty }
            .store(in: &cancellables)
    }
    
    private func setupTableView() {
        // テーブルビューの制約やDelegate設定（省略）
    }
}
