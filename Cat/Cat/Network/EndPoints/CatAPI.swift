//
//  CatAPI.swift
//  Cat
//
//  Created by Deekshith Bellare on 04/08/20.
//  Copyright © 2020 Deekshith Bellare. All rights reserved.
//

import Foundation

public enum CatAPI {
    //for the exercise we are using first 100 cats from page zero of https://api.thecatapi.com/v1/images/search
    case randomCats
    case allCats(itemsPerPage:Int,pageNo:Int)
}

extension CatAPI: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.thecatapi.com/v1/") else { fatalError("baseURL could not be configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .randomCats:
            return "images/search"
        case .allCats:
            return "images/search"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .randomCats:
            let params:[String:Any] = ["limit":100,"page":0,"order":"Desc"]
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters:params)
        case .allCats(let itemsPerPage, let pageNo):
            let params:[String:Any] = ["limit":itemsPerPage,"page":pageNo,"order":"Desc"]
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters:params)
        }
    }
    var headers: HTTPHeaders? {
        return ["x-api-key":CatAPIConfig.key]
    }
}

