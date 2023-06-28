//
//  UserProfile.swift
//  SpotifyAppProject
//
//  Created by Nikita Borisov on 20.03.2023.
//

import Foundation

struct UserProfile: Codable{
    
    let display_name: String
    let external_urls: [String:String]
    //let followers: [UserFollowers]
    let id: String
    let images: [APIImage]
    
    
}

struct UserFollowers: Codable {
    let total: String
}


