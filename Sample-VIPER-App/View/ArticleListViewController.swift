//
//  ViewController.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/04/20.
//

import UIKit

class ArticleListViewController: UIViewController {
    
    var presenter: ArticleListPresenterProtocol!
    
    private var tableView: UITableView!
    
    private var articleEntities = [ArticleEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "記事一覧"
        
        tableView = UITableView()
        tableView.accessibilityIdentifier = "articleListTableView"
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.backgroundColor = .systemGroupedBackground
        tableView.layer.cornerRadius = 12
        tableView.layer.masksToBounds = true
        
        presenter.didLoad()
    }
}

extension ArticleListViewController: UITableViewDelegate, UITableViewDataSource {
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleEntities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = articleEntities[indexPath.row].title
        content.textProperties.font = .systemFont(ofSize: 16, weight: .medium)
        content.textProperties.color = .label
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter.didSelect(articleEntity: articleEntities[indexPath.row])
    }
}

extension ArticleListViewController: ArticleListViewProtocol {
    
    func showArticles(_ articleEntities: [ArticleEntity]) {
        self.articleEntities = articleEntities
        tableView.reloadData()
    }
    
    func showEmpty() {
        tableView.isHidden = true
        showArticles([])
    }
    
    func showError(_ error: Error) {
        // 今回はスキップ
    }
}
