//
//  JSONParameterEncoder.swift
//  Cat
//
//  Created by Deekshith Bellare on 04/08/20.
//  Copyright © 2020 Deekshith Bellare. All rights reserved.
//

import Foundation

public struct JSONParameterEncoder: ParameterEncoder {
    public func encode(urlRequest: URLRequest, with parameters: Parameters) throws -> URLRequest? {
        var updatedRequest = urlRequest
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            updatedRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                updatedRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                return updatedRequest
            }
        } catch {
            throw NetworkError.encodingFailed
        }
        return nil
    }
}
