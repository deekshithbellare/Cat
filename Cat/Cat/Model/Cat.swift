//
//  Cat.swift
//  Cat
//
//  Created by Deekshith Bellare on 04/08/20.
//  Copyright © 2020 Deekshith Bellare. All rights reserved.
//

import Foundation
// Cat Model
struct Cat:Codable {
    //Unique identfier for the cat
    var id:String
    //Url for the image of cat
    var url:String
}

// To use it with diffable datasources, Cat should be hashable and Equtable
extension Cat:Hashable {
    static func == (lhs: Cat, rhs: Cat) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
