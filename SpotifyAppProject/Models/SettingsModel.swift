//
//  SettingsModel.swift
//  SpotifyAppProject
//
//  Created by Nikita Borisov on 27.03.2023.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    
    let title: String
    let handler: () -> Void
}
