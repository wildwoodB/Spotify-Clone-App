//
//  NewReleasesResponse.swift
//  SpotifyAppProject
//
//  Created by Nikita Borisov on 30.03.2023.
//

import Foundation

struct NewReleasesResponse: Codable {
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable {
    let items: [Album]
}






