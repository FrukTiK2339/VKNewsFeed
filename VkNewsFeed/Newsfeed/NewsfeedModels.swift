//
//  NewsfeedModels.swift
//  VkNewsFeed
//
//  Created by Дмитрий Рыбаков on 10.07.2023.
//  Copyright (c) 2023 . All rights reserved.
//

import UIKit

enum Newsfeed {
    
    enum Model {
        struct Request {
            enum RequestType {
                case getNewsfeed
            }
        }
        struct Response {
            enum ResponseType {
                case presentNewsfeed(feed: FeedResponse)
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayNewsfeed(feedViewModel: FeedViewModel)
            }
        }
    }
    
}

struct FeedViewModel {
    struct Cell: FeedCellViewModel {
        var iconURLString: String
        var name: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var shares: String?
        var views: String?
        var photoAttachment: FeedCellPhotoAttachmentViewModel?
        var sizes: FeedCellSizes
    }
    
    struct FeedCellPhotoAttachment: FeedCellPhotoAttachmentViewModel {
        var photoURLString: String?
        var width: Int
        var height: Int
    }
    
    let cells: [Cell]
}
