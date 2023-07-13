//
//  UserResponse.swift
//  VkNewsFeed
//
//  Created by Дмитрий Рыбаков on 13.07.2023.
//

import Foundation

struct UserResponseWrapped: Decodable {
    let response: [UserResponse]
}

struct UserResponse: Decodable {
    let photo100: String?
}
