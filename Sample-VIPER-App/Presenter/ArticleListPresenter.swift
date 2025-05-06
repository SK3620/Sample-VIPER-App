//
//  ArticleListPresenter.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/04/21.
//

/*
 Presenterを実装する際には、ひとつの原則を意識するようにしたほうがいい
 ・Presenterには、クラスの元々の定義はViewの参照と依存性、そしてそのイニシャライザのみ
 ・Presenterには、原則として「アプリでこうされたときには、こうなる」というものだけを落とし込まれた状態にする（要するにアプリの仕様書みたいなもの）
 （例えば、Presenterプロトコルの実装部分を見ていきます。 didLoadが呼ばれたとき、つまり「画面が初期表示しようとするとき」に「データ取得を実行」し、「成功した場合、数が0件ならばエンプティ表示、それ以外ならデータを表示させる」「失敗した場合は、エラーを表示する」という記述になっていると思います。 didSelectについても「選ばれたときには、記事詳細を表示する」としています。）
 */

import Foundation

protocol ArticleListPresenterProtocol: AnyObject {
    
    func didLoad()
    func didSelect(articleEntity: ArticleEntity)
}

protocol ArticleListViewProtocol: AnyObject {
    
    func showArticles(_ articleEntities: [ArticleEntity])
    func showEmpty()
    func showError(_ error: Error)
}

class ArticleListPresenter {
    
    struct Dependency {
        let router: ArticleListRouterProtocol!
        let getArticlesArrayUseCase: UseCase<Void, [ArticleEntity], Error> // UseCase<Parameter, Success, Failure: Error>          これにより、3つのアソシエートタイプが合わない限りはエラーになるので、タイプセーフ(型安全)な状態になる
        
        /*
         実体としては、GetArticlesArrayUseCaseを差し込むが、そのGetArticlesArrayUseCaseの型を指定するのではなく、UseCaseクラスを使ってこのようにParameterとResultの成功と失敗の型のみで指定することができる。これによりPresenterは、GetArticlesArrayUseCaseクラスに依存しなくなる。
         */
    }
    
    weak var view: ArticleListViewProtocol!
    // ArticleListViewController: ArticleListViewProtocolで、Output用のメソッドをVCで呼ぶ必要がある
    
    private var di: Dependency
    
    init(view: ArticleListViewProtocol, inject dependency: Dependency) {
        self.view = view
        self.di = dependency
    }
}

extension ArticleListPresenter: ArticleListPresenterProtocol {
        
    func didLoad() {
        /*
         ・GetArticlesArrayUseCaseのインスタンスをPresenter自身が生成しており、つまり、これはPresenterがInteractorのクラスを知ってしまっているがために起きる「密結合」という状態
         ・「密結合」はクラス単体のテストがしにくくなるなどのデメリットが大きな状態です。 これを解消するために、VIPERは「依存性注入」(Dependency Injection)によって、 外から使用するインスタンスを差し込んでやることで密結合の問題を解決させます。
         
         ・機能の「取り外し」と「差し替え」が容易になる
         ・依存性注入によってユースケースを仮実装のものから本実装のものに変えていけますし、あるいはテスト用のスタブに変えてテストさせることも容易にできるようになるのです。ただし、この方法はファイル数がどんどん膨れ上がっていきます。実装の手間も大きいので、アプリの規模と残りスケジュールなどを相談する必要もあると思います。
         */
        
        // 仮のデータを返すユースケース（MockGetArticlesArrayUseCaseみたいなのを作る？）
        // GetArticlesArrayUseCase().execute(()) { [weak self] result in ... }
        
        // 仮のデータを返すユースケースから、実際にAPIを叩いてデータを返すユースケースが簡単にすり替えることができる
        di.getArticlesArrayUseCase.execute(()) { [weak self] result in

            guard let self = self else { return }
            
            switch result {
            case .success(let articleEntities):
                if articleEntities.isEmpty {
                    self.view.showEmpty()
                    return
                }
                self.view.showArticles(articleEntities)
            case .failure(let error):
                self.view.showError(error)
            }
        }
    }
    
    func didSelect(articleEntity: ArticleEntity) {
        di.router.showArticleDetail(articleEntity: articleEntity)
    }
}

