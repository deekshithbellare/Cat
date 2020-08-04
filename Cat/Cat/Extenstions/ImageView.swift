//
//  ImageView.swift
//  Cat
//
//  Created by Deekshith Bellare on 05/08/20.
//  Copyright © 2020 Deekshith Bellare. All rights reserved.
//

import Foundation

import Kingfisher
import UIKit

//An wrapper over image loading library so that we can easily replace the library when needed
extension UIImageView {
    func setImage(with url: URL) {
        kf.setImage(with: url)
    }
}
