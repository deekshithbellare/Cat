//
//  FavouriteWorker.swift
//  Cat
//
//  Created by Deekshith Bellare on 05/08/20.
//  Copyright © 2020 Deekshith Bellare. All rights reserved.
//

import Foundation

struct FavouriteWorker {
    
    static let favoritesKey = "Favorites"
    static func favourite(_ cat:Cat,isFavourited:Bool) {
        var favouriteDict:[String:Cat] = [String:Cat]()
        if let favouriteCats = fetchFavorites() {
            favouriteDict = favouriteCats
        }
        
        if isFavourited {
            favouriteDict[cat.id] = cat
        } else {
            favouriteDict.removeValue(forKey: cat.id)
        }
        saveFavorites(cats: favouriteDict)
    }
    
    static func fetchFavorites() -> [String:Cat]? {
        let userDefaults = UserDefaults.standard
        if let favorites = userDefaults.object(forKey: FavouriteWorker.favoritesKey) as? Data {
            let decoder = JSONDecoder()
            if let favoriteCats = try? decoder.decode([String:Cat].self, from: favorites) {
                return favoriteCats
            }
        }
        return nil
    }
    
    static func favoriteCatIds() -> Set<String> {
        guard let keys = self.fetchFavorites()?.keys else {
            return Set<String>()
        }
        return Set(keys)
    }
    
    static func saveFavorites( cats:[String:Cat]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(cats) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: FavouriteWorker.favoritesKey)
        }
    }
}
