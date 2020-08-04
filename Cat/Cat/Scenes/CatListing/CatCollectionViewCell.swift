//
//  CatCollectionViewCell.swift
//  Cat
//
//  Created by Deekshith Bellare on 05/08/20.
//  Copyright © 2020 Deekshith Bellare. All rights reserved.
//

import UIKit

class CatCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifer = "CatCollectionViewCell"
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.backgroundColor = UIColor.gray
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let contentContainer = UIView()
    
    var photoURL: String? {
        didSet {
            configure()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        contentContainer.removeFromSuperview()
    }
}

extension CatCollectionViewCell {
    func configure() {
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentContainer)
        
        guard let urlString = self.photoURL,
            let photoURL = URL(string:urlString)
            else { return }
        
        imageView.setImage(with: photoURL)
        contentContainer.addSubview(imageView)
        contentContainer.bindFrameToSuperviewBounds()
        imageView.bindFrameToSuperviewBounds()
    }
}
