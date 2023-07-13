//
//  NewsfeedInteractor.swift
//  VkNewsFeed
//
//  Created by Дмитрий Рыбаков on 10.07.2023.
//  Copyright (c) 2023 . All rights reserved.
//

import UIKit

protocol NewsfeedBusinessLogic {
    func makeRequest(request: Newsfeed.Model.Request.RequestType)
}

class NewsfeedInteractor: NewsfeedBusinessLogic {
    
    var presenter: NewsfeedPresentationLogic?
    var service: NewsfeedService?
    
    func makeRequest(request: Newsfeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsfeedService()
        }
        switch request {
        case .getNewsfeed:
            service?.getFeed { [weak self] (revealedPostIds, feedResponse) in
                self?.presenter?.presentData(response: .presentNewsfeed(feed: feedResponse, revealedPostIds: revealedPostIds))
            }
        case .revealPostId(postId: let postId):
            service?.revealedPostIds(forPostId: postId) { [weak self] (revealedPostIds, feedResponse) in
                self?.presenter?.presentData(response: .presentNewsfeed(feed: feedResponse, revealedPostIds: revealedPostIds))
            }
        case .getUser:
            service?.getUser { [weak self] (user) in
                self?.presenter?.presentData(response: .presentUserInfo(user: user))
            }
        case .getNextBatch:
            self.presenter?.presentData(response: .presentFooterLoader)
            service?.getNextBatch { [weak self] (revealedPostIds, feedResponse) in
                self?.presenter?.presentData(response: .presentNewsfeed(feed: feedResponse, revealedPostIds: revealedPostIds))
            }
        }
    }
}
