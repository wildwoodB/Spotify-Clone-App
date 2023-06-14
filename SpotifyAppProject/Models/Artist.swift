//
//  Artist.swift
//  SpotifyAppProject
//
//  Created by Админ on 20.03.2023.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let images: [APIImage]?
    let external_urls: [String:String]
}
