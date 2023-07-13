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
    
    private var revealedPostIds = [Int]()
    private var feedResponse: FeedResponse?
    
    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
    
    func makeRequest(request: Newsfeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsfeedService()
        }
        
        switch request {
            
        case .getNewsfeed:
            fetcher.getFeed { [weak self] (feedResponse) in
                guard let feedResponse = feedResponse else { return }
                self?.feedResponse = feedResponse
                self?.presentFeed()
            }
        case .revealPostId(let postId):
            revealedPostIds.append(postId)
            presentFeed()
            
        case .getUser:
            fetcher.getUser { (userResponse) in
                self.presenter?.presentData(response: .presentUserInfo(user: userResponse))
            }
        }
        
    
    }
    
    private func presentFeed() {
        guard let feedResponse = feedResponse else { return }
        presenter?.presentData(response: .presentNewsfeed(feed: feedResponse, revealedPostIds: revealedPostIds))
    }
    
}
