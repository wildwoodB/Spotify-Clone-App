//
//  Playlist.swift
//  SpotifyAppProject
//
//  Created by Nikita Borisov on 31.03.2023.
//

import Foundation

struct Playlist: Codable {
    let description: String
    let external_urls: [String:String]
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
    //let primary_color: String
}
