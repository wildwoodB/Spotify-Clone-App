//
//  SearchResults.swift
//  SpotifyAppProject
//
//  Created by Nikita Borisov on 02.05.2023.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
