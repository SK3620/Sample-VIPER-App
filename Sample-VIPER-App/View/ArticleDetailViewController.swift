//
//  ArticleDetailViewController.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/04/20.
//

import UIKit

class ArticleDetailViewController: UIViewController {
    
    enum Row: String {
        case title
        case body
        
        static var rows: [Row] {
            return [.title, .body]
        }
    }
    
    var articleEntity: ArticleEntity!
    var presenter: ArticleDetailPresenterProtocol!

    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Row.title.rawValue)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Row.body.rawValue)
        
        presenter.didLoad(articleEntity: articleEntity)
    }
}

extension ArticleDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = Row.rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.rawValue, for: indexPath)
        
        if row == .title {
            cell.textLabel?.text = articleEntity.title
        }
        if row == .body {
            cell.textLabel?.text = articleEntity.body
        }
        return cell
    }
}

extension ArticleDetailViewController: ArticleDetailViewProtocol {
    
    func showArticle(_ articleEntity: ArticleEntity) {
        self.articleEntity = articleEntity
        tableView.reloadData()
    }
    
    func showError(_ error: Error) {
        // 今回はスキップ
    }
}

