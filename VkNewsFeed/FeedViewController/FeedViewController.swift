//
//  FeedViewController.swift
//  VkNewsFeed
//
//  Created by Дмитрий Рыбаков on 07.07.2023.
//

import UIKit

class FeedViewController: UIViewController {
    
    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBlue
        fetcher.getFeed { (feedResponse) in
            guard let feedResponse = feedResponse else { return }
            
            feedResponse.items.map( { print($0.text) })
        }
    }
    
}
