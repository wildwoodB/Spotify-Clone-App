//
//  CategoriesResponse.swift
//  SpotifyAppProject
//
//  Created by Админ on 24.04.2023.
//

import Foundation

struct AllCategoriesResponse: Codable {
    let categories: Categories
}

struct Categories: Codable {
    let items: [Category]
}

struct Category: Codable {
    let icons: [APIImage]
    let id: String
    let name: String
}
