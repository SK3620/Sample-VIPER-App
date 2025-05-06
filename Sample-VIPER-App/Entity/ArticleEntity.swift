//
//  ArticleEntity.swift
//  Sample-VIPER-App
//
//  Created by 鈴木 健太 on 2025/04/20.
//

import Foundation

struct ArticleEntity: Codable, Equatable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}
