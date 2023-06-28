//
//  AuthResponse.swift
//  SpotifyAppProject
//
//  Created by Nikita Borisov on 23.03.2023.
//

import Foundation

struct AuthResponse: Codable {
    
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    //let scope: String
    let token_type: String
    
    
}


//"access_token" = "BQDq3XTHZkDaS6pXUx6hzucTY8KyEfuTbxHhs4gTkN0sE-pTpe57T_s3MDWN9GYu-xeiSUgDR13X8-vPShPZqQ1tOpEvCQSxdW4PnY_ICGppoMo9Jlsad4ZHmEhvjC7-ZHEBKLMujJVOOvgpu9c6uXMQRbbCUfpDXee2vVi2-HeU0n4";
//"expires_in" = 3600;
//"refresh_token" = AQA66wxj8l2atsM8Itqy3FwYRgReB3kJAO2tUw1nz5LzqFUyMc57rdW55pbempqY0bLRsTNM7THq1uMeHhzX7fKUm6oUl658Kak2LVu8CmSx7Kqq1QQV5I3rCYNVKHY31Ks;
//"token_type" = Bearer;
