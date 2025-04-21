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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        presenter.didLoad()
    }
}

extension ArticleListViewController: UITableViewDelegate, UITableViewDataSource {
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "記事のタイトル"
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
