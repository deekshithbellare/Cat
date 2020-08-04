//
//  URLParameterEncoding.swift
//  Cat
//
//  Created by Deekshith Bellare on 04/08/20.
//  Copyright © 2020 Deekshith Bellare. All rights reserved.
//

import Foundation

public struct URLParameterEncoder: ParameterEncoder {
    public func encode(urlRequest: URLRequest, with parameters: Parameters) throws -> URLRequest? {
        var updatedRequest = urlRequest
        guard let url = urlRequest.url else { throw NetworkError.missingURL }

        if var urlComponents = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()

            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key,
                                             value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            updatedRequest.url = urlComponents.url
        }

        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            updatedRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        return updatedRequest
    }
}
