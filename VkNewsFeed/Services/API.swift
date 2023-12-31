//
//  API.swift
//  VkNewsFeed
//
//  Created by Дмитрий Рыбаков on 07.07.2023.
//

import Foundation

struct API {
    static let scheme = "https"
    static let host = "api.vk.com"
    static let version = "5.131"
    
    static let newsFeed = "/method/newsfeed.get"
    static let user = "/method/users.get"
}
