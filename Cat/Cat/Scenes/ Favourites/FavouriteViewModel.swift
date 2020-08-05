//
//  FavouriteViewModel.swift
//  Cat
//
//  Created by Deekshith Bellare on 05/08/20.
//  Copyright © 2020 Deekshith Bellare. All rights reserved.
//

import Foundation

class FavouriteViewModel {
    var favouriteCats = [Cat]()
    init() {
        favouriteCats = FavouriteWorker.favoriteCats()
    }
    
}
