//
//  CatDetailViewModel.swift
//  Cat
//
//  Created by Deekshith Bellare on 05/08/20.
//  Copyright © 2020 Deekshith Bellare. All rights reserved.
//

import Foundation

class CatDetailViewModel {
    var cat:Cat?
    
    var catURL:URL? {
        guard let cat = self.cat,
            let url = URL(string: cat.url) else {
                return nil
        }
        return url
    }
}
