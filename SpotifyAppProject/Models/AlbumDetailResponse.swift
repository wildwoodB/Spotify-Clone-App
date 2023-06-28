//
//  AlbumDetailResponse.swift
//  SpotifyAppProject
//
//  Created by Nikita Borisov on 10.04.2023.
//

import Foundation

struct AlbumDetailResponse: Codable {
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let external_urls: [String:String]
    let id: String
    let images: [APIImage]
    let label: String
    let name: String
    let release_date: String
    let tracks: TrackResponse
     
}

