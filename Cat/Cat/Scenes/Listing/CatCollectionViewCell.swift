//
//  CatCollectionViewCell.swift
//  Cat
//
//  Created by Deekshith Bellare on 05/08/20.
//  Copyright © 2020 Deekshith Bellare. All rights reserved.
//

import UIKit
protocol CatCollectionViewCellDelegate:AnyObject {
    func favoriteTap(at cell:CatCollectionViewCell,isFavorited:Bool)
}

class CatCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifer = "CatCollectionViewCell"
    weak var delegate:CatCollectionViewCellDelegate?
    let contentContainer = UIView()
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.backgroundColor = UIColor.gray
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var favoriteButon: UIButton = {
        let favoriteButton = UIButton(type: .custom)
        let origImage = UIImage(named: "favourite")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        favoriteButton.setImage(tintedImage, for: .normal)
        favoriteButton.tintColor = UIColor.lightGray
        favoriteButton.clipsToBounds = true
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        return favoriteButton
    }()
    
    var photoURL: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(isFavorited:false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        contentContainer.removeFromSuperview()
        favoriteButon.isSelected = false
        favoriteButon.tintColor = UIColor.lightGray
    }
    
    @objc func favorite(sender : UIButton) {
        sender.isSelected.toggle()
        updateFavoriteButton(isFavorited: sender.isSelected)
        delegate?.favoriteTap(at: self,isFavorited:sender.isSelected)
    }
    
    func updateFavoriteButton(isFavorited:Bool) {
        favoriteButon.isSelected = isFavorited
        if isFavorited {
            favoriteButon.tintColor = UIColor.red
        } else {
            favoriteButon.tintColor = UIColor.lightGray
        }
    }
}

extension CatCollectionViewCell {
    func configure(isFavorited:Bool) {
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentContainer)
        
        guard let urlString = self.photoURL,
            let photoURL = URL(string:urlString)
            else { return }
        
        imageView.setImage(with: photoURL)
        contentContainer.addSubview(imageView)
        contentContainer.addSubview(favoriteButon)
        contentContainer.bindToSuperviewBounds()
        imageView.bindToSuperviewBounds()
        configureFavoriteButon()
        updateFavoriteButton(isFavorited: isFavorited)
    }
    
    func configureFavoriteButon() {
        favoriteButon.addTarget(self, action: #selector(favorite), for: .touchUpInside)
        favoriteButon.bottomAnchor.constraint(equalTo: contentContainer.safeAreaLayoutGuide.bottomAnchor).isActive = true
        favoriteButon.trailingAnchor.constraint(equalTo: contentContainer.safeAreaLayoutGuide.trailingAnchor).isActive = true
        favoriteButon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        favoriteButon.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
