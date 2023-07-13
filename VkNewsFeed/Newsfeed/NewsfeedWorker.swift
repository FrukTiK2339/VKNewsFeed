//
//  NewsfeedWorker.swift
//  VkNewsFeed
//
//  Created by Дмитрий Рыбаков on 10.07.2023.
//  Copyright (c) 2023 . All rights reserved.
//

import UIKit

class NewsfeedService {

    var authService: AuthService
    var networking: Networking
    var fetcher: DataFetcher
    
    init() {
        self.authService = SceneDelegate.shared().authService
        self.networking = NetworkService(authService: authService)
        self.fetcher = NetworkDataFetcher(networking: networking)
    }
    
    private var revealedPostIds = [Int]()
    private var feedResponse: FeedResponse?
    private var newFromInProccess: String?
    
    func getUser(completion: @escaping (UserResponse?) -> Void) {
        fetcher.getUser { (userResponse) in
            completion(userResponse)
        }
    }
    
    func getFeed(completion: @escaping ([Int], FeedResponse) -> Void) {
        fetcher.getFeed(nextBatchFrom: nil) { [weak self] (feedResponse) in
            self?.feedResponse = feedResponse
            guard let feedResponse = self?.feedResponse, let revealedPostIds = self?.revealedPostIds else { return }
            completion(revealedPostIds, feedResponse)
        }
    }
    
    func revealedPostIds(forPostId postId: Int, completion: @escaping ([Int], FeedResponse) -> Void) {
        revealedPostIds.append(postId)
        guard let feedResponse = self.feedResponse else { return }
        completion(revealedPostIds, feedResponse)
        
    }
    
    func getNextBatch(completion: @escaping ([Int], FeedResponse) -> Void) {
        newFromInProccess = feedResponse?.nextFrom
        fetcher.getFeed(nextBatchFrom: newFromInProccess) { [weak self] (feed) in
            guard let feed = feed, let revealedPostIds = self?.revealedPostIds, self?.feedResponse?.nextFrom != feed.nextFrom
            else { return }
            
            if self?.feedResponse == nil {
                self?.feedResponse = feed
            } else {
                self?.feedResponse?.items.append(contentsOf: feed.items)
                
                var profiles = feed.profiles
                if let oldProfiles = self?.feedResponse?.profiles {
                    let oldProfilesFiltered = oldProfiles.filter({ (oldProfile) -> Bool in
                        !feed.profiles.contains(where: { $0.id == oldProfile.id })
                    })
                    profiles.append(contentsOf: oldProfilesFiltered)
                }
                self?.feedResponse?.profiles = profiles
                
                var groups = feed.groups
                if let oldGroups = self?.feedResponse?.groups {
                    let oldGroupsFiltered = oldGroups.filter({ (oldGroup) -> Bool in
                        !feed.groups.contains(where: { $0.id == oldGroup.id })
                    })
                    groups.append(contentsOf: oldGroupsFiltered)
                }
                self?.feedResponse?.groups = groups
                
                self?.feedResponse?.nextFrom = feed.nextFrom
            }
            guard let feedResponse = self?.feedResponse else { return }
            completion(revealedPostIds, feedResponse)
        }
    }
}
