//
//  String+Extensions.swift
//  VkNewsFeed
//
//  Created by Дмитрий Рыбаков on 11.07.2023.
//

import Foundation
import UIKit

extension String {
    
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        let textSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let size = self.boundingRect(with: textSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil)
        return ceil(size.height)
    }
}
