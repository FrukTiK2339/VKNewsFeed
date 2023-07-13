//
//  AppConsts.swift
//  VkNewsFeed
//
//  Created by Дмитрий Рыбаков on 11.07.2023.
//

import UIKit

struct Constants {
    static let cardInsets = UIEdgeInsets(top: 0, left: 8, bottom: 12, right: 8)
    static let topViewHeight: CGFloat = 36
    static let postLabelFont = UIFont.systemFont(ofSize: 15)
    static let postLabelInsets = UIEdgeInsets(top: 8 + Constants.topViewHeight + 8, left: 8, bottom: 8, right: 8)
    static let bottomViewHeight: CGFloat = 44
    
    static let minifiedPostLimitLines: CGFloat = 7
    static let minifiedPostLines: CGFloat = 5
    static let moreTextButtonSize = CGSize(width: 170, height: 30)
    static let moreTextButtonInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
}
