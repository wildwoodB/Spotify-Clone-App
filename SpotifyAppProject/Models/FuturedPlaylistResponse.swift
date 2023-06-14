//
//  Playlist.swift
//  SpotifyAppProject
//
//  Created by Админ on 20.03.2023.
//

import Foundation


struct FuturedPlaylistResponse: Codable {
    let playlists : PlaylistResponse
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}

struct User: Codable {
    let display_name: String
    let external_urls: [String:String]
    let id: String
    
}




