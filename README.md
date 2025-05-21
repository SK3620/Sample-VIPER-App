# 📱 VIPER学習用サンプルアプリ

iOSアーキテクチャ「VIPER（View, Presenter, Interactor, Entity, Router）」の学習を目的としたサンプルアプリ

**※ 復習し、理解度が深められるよう、学習用のコメントアウトを多く記述しています。**

## 主な実装済み機能
- API通信で取得した記事を一覧に表示
- 記事一覧画面から記事詳細画面への遷移　など...
- 単体テスト（XCTest, Swift-Testing）
- 簡易的なUIテスト

## 今やっていること/今後やること
- 共通化されたインターフェースである UseCase クラス内で、継承クラスを用いて、ジェネリクスを隠蔽している理由やメリットを学習中。
- **[Swift テストを行う。](https://qiita.com/airy_flutter/items/a3d2a7b31f7bce68bccf)**, **[Swift-Testing を始めたい](https://qiita.com/stotic-dev/items/f9fe0211f34b7c04c440)** を参考に、コードを書きながら、ユニットテスト、UIテスト、Swit-Testingを学習中。

- 将来的には、CI/CL SwiftLint, Danger で、Pull Request をトリガーに、ユニットテストや静的解析を自動実行し、その結果を Danger でレビュー結果としてフィードバックするところまでを簡単にやってみる。

## 📚 参考リンク

- 🎥 YouTube： [iOSアーキテクチャVIPERとは](https://www.youtube.com/watch?v=ieqNIySokxI&t=74s)
- 📖 記事： [DevelopersIO: VIPERアーキテクチャの導入](https://dev.classmethod.jp/articles/developers-io-2020-viper-architecture)
