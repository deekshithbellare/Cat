//
//  CatsViewModel.swift
//  Cat
//
//  Created by Deekshith Bellare on 04/08/20.
//  Copyright © 2020 Deekshith Bellare. All rights reserved.
//

import Foundation



class CatsViewModel {
    var cats: [Cat]?
    let router = Router<CatAPI>()
    var favoriteCats:Set<String> = Set<String>()
    init() {
        favoriteCats = FavouriteWorker.favoriteCatIds()
    }
    
    func isFavorited(_ cat:Cat) -> Bool {
        return favoriteCats.contains(cat.id)
    }
    
    func favourite(_ cat:Cat,isFavourited:Bool) {
        if isFavourited {
            favoriteCats.insert(cat.id)
        } else {
            favoriteCats.remove(cat.id)
        }
        FavouriteWorker.favourite(cat, isFavourited: isFavourited)
    }
    
    func cat(at indexPath:IndexPath) -> Cat? {
        guard let cats = self.cats, !cats.isEmpty else {
            return nil
        }
        guard  indexPath.row < cats.count else {
            return nil
        }
        return cats[indexPath.row]
    }
    
    func fetchRandomCats(completion: @escaping (_ error: String?) -> Void) {
        DispatchQueue.global().async {
            self.router.request(.randomCats) { [weak self] data, error in
                guard let self = self else { return }
                
                if let data = data {
                    let decoder = JSONDecoder()
                    guard let cats = try? decoder.decode([Cat].self, from: data) else {
                        return
                    }
                    self.cats = cats
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else if let error = error {
                    print(error)
                    DispatchQueue.main.async {
                        completion(error)
                    }
                }
            }
        }
    }
}
