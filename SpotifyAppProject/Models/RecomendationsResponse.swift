//
//  RecomendationsResponse.swift
//  SpotifyAppProject
//
//  Created by Nikita Borisov on 01.04.2023.
//

import Foundation

struct RecomendationsResponse: Codable {
    let tracks: [AudioTrack]
}
