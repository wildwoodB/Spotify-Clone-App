//
//  NewReleasesResponse.swift
//  SpotifyAppProject
//
//  Created by Админ on 30.03.2023.
//

import Foundation

struct NewReleasesResponse: Codable {
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable {
    let items: [Album]
}






