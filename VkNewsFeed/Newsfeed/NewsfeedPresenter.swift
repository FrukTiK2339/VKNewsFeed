//
//  NewsfeedPresenter.swift
//  VkNewsFeed
//
//  Created by Дмитрий Рыбаков on 10.07.2023.
//  Copyright (c) 2023 . All rights reserved.
//

import UIKit

protocol NewsfeedPresentationLogic {
    func presentData(response: Newsfeed.Model.Response.ResponseType)
}

class NewsfeedPresenter: NewsfeedPresentationLogic {
    
    weak var viewController: NewsfeedDisplayLogic?
    var cellLayoutCalculator: FeedCellLayoutCalculatorProtocol = NewsfeedCellLayoutCalculator()
    
    let dateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d MMM 'в' HH:mm"
        return dt
    }()
    
    func presentData(response: Newsfeed.Model.Response.ResponseType) {
        
        switch response {
        case .presentNewsfeed(let feed, let revealedPostIds):
            let cells = feed.items.map({ cellViewModel(from: $0, profiles: feed.profiles, groups: feed.groups, revealedPostIds: revealedPostIds) })
            let feedViewModel = FeedViewModel(cells: cells)
            viewController?.displayData(viewModel: .displayNewsfeed(feedViewModel: feedViewModel))
        case .presentUserInfo(let userInfo):
            let userViewModel = UserViewModel(photoURLString: userInfo?.photo100)
            viewController?.displayData(viewModel: .displayUser(userViewModel: userViewModel))
        }
        
    }
    
    private func cellViewModel(from feedItem: FeedItem, profiles: [Profile], groups: [Group], revealedPostIds: [Int]) -> FeedViewModel.Cell {
        
        let profile = self.profile(for: feedItem.sourceId, profiles: profiles, groups: groups)
        let photoAttachments = self.photoAttachments(feedItem: feedItem)
        
        let isFullSized = revealedPostIds.contains(feedItem.postId)
        
        let sizes = self.cellLayoutCalculator.sizes(postText: feedItem.text, photoAttachments: photoAttachments, isFullSizedPost: isFullSized)
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormatter.string(from: date)
        
        return FeedViewModel.Cell(
            postId: feedItem.postId,
            iconURLString: profile.photo,
            name: profile.name,
            date: dateTitle,
            text: feedItem.text,
            likes: formattedCounter(feedItem.likes?.count),
            comments: formattedCounter(feedItem.comments?.count),
            shares: formattedCounter(feedItem.reposts?.count),
            views: formattedCounter(feedItem.views?.count),
            photoAttachments: photoAttachments,
            sizes: sizes
        )
    }
    
    private func formattedCounter(_ counter: Int?) -> String? {
        guard let counter = counter, counter > 0 else { return nil }
        var counterString = String(counter)
        if 4...6 ~= counterString.count {
            counterString = String(counterString.dropLast(3)) + "K"
        } else if counterString.count > 6 {
            counterString = String(counterString.dropLast(6)) + "M"
        }
        return counterString
    }
    
    private func profile(for sourceId: Int, profiles: [Profile], groups: [Group]) -> ProfileRepresentable {
        
        let profilesOrGroups: [ProfileRepresentable] = sourceId >= 0 ? profiles : groups
        let normalSourceId = sourceId >= 0 ? sourceId : -sourceId
        let profileRepresentable = profilesOrGroups.first(where: { $0.id == normalSourceId })
        return profileRepresentable!
    }
    
    private func photoAttachment(feedItem: FeedItem) -> FeedViewModel.FeedCellPhotoAttachment? {
        guard let photos = feedItem.attachments?.compactMap({ $0.photo }), let firstPhoto = photos.first else { return nil }
        return FeedViewModel.FeedCellPhotoAttachment(photoURLString: firstPhoto.scrBIG,
                                                     width: firstPhoto.width,
                                                     height: firstPhoto.height
        )
    }
    
    private func photoAttachments(feedItem: FeedItem) -> [FeedViewModel.FeedCellPhotoAttachment] {
        guard let attachments = feedItem.attachments else { return [] }
        return attachments.compactMap { attachment in
            guard let photo = attachment.photo else { return nil }
            return FeedViewModel.FeedCellPhotoAttachment(photoURLString: photo.scrBIG, width: photo.width, height: photo.height)
        }
    }
}
