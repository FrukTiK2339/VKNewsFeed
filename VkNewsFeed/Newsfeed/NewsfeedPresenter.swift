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
        case .presentNewsfeed(let feed):
            let cells = feed.items.map({ cellViewModel(from: $0, profiles: feed.profiles, groups: feed.groups) })
            let feedViewModel = FeedViewModel(cells: cells)
            viewController?.displayData(viewModel: .displayNewsfeed(feedViewModel: feedViewModel))
        }
        
    }
    
    private func cellViewModel(from feedItem: FeedItem, profiles: [Profile], groups: [Group]) -> FeedViewModel.Cell {
        
        let profile = self.profile(for: feedItem.sourceId, profiles: profiles, groups: groups)
        let photoAttachment = self.photoAttachment(feedItem: feedItem)
        let sizes = self.cellLayoutCalculator.sizes(postText: feedItem.text, photoAttachment: photoAttachment)
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormatter.string(from: date)
        
        return FeedViewModel.Cell(
            iconURLString: profile.photo,
            name: profile.name,
            date: dateTitle,
            text: feedItem.text,
            likes: String(feedItem.likes?.count ?? 0),
            comments: String(feedItem.comments?.count ?? 0),
            shares: String(feedItem.reposts?.count ?? 0),
            views: String(feedItem.views?.count ?? 0),
            photoAttachment: photoAttachment,
            sizes: sizes
        )
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
    
}
