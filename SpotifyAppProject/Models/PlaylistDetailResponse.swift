//
//  PlaylistDetailResponse.swift
//  SpotifyAppProject
//
//  Created by Nikita Borisov on 10.04.2023.
//

import Foundation

struct PlaylistDetailResponse: Codable {
    let description: String
    let external_urls: [String:String]
    let id: String
    let images: [APIImage]
    let primary_color: String
    let tracks: PlaylistTrackResponse
    
}

struct PlaylistTrackResponse: Codable {
    let items: [PlaylistItem]
    
}

struct PlaylistItem: Codable {
    let track: AudioTrack
    
}

