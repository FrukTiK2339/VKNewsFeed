//
//  GalleryCollectionViewCell.swift
//  VkNewsFeed
//
//  Created by Дмитрий Рыбаков on 12.07.2023.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "GalleryCollectionViewCell"
    
    let myImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(named: "emptyImageColor")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        myImageView.image = nil
    }
    
    func set(imageURL: String?) {
        myImageView.set(imageURL: imageURL)
    }
    
    private func commonInit() {
        addSubview(myImageView)
        myImageView.fillSuperview()
    }
    
    override func layoutSubviews() {
        myImageView.layer.masksToBounds = true
        myImageView.layer.cornerRadius = 10
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 2.5, height: 4)
    }
}
