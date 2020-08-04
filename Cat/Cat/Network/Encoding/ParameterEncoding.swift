//
//  ParameterEncoding.swift
//  PersonTracker
//
//  Created by Deekshith Bellare on 02/10/18.
//  Copyright © 2018 Deekshith Bellare. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol ParameterEncoder {
    func encode(urlRequest: URLRequest, with parameters: Parameters) throws -> URLRequest?
}

public enum ParameterEncoding {
    case urlEncoding
    case jsonEncoding
    case urlAndJsonEncoding

    public func encode(urlRequest: URLRequest,
                       bodyParameters: Parameters?,
                       urlParameters: Parameters?) throws -> URLRequest? {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParameters else { return nil }
                return try URLParameterEncoder().encode(urlRequest: urlRequest, with: urlParameters)

            case .jsonEncoding:
                guard let bodyParameters = bodyParameters else { return nil }
                return try JSONParameterEncoder().encode(urlRequest: urlRequest, with: bodyParameters)

            case .urlAndJsonEncoding:
                guard let bodyParameters = bodyParameters,
                    let urlParameters = urlParameters else { return nil }
                guard let updatedRequest = try URLParameterEncoder().encode(urlRequest: urlRequest, with: urlParameters) else {
                    return nil
                }
                return try JSONParameterEncoder().encode(urlRequest: updatedRequest, with: bodyParameters)
            }
        } catch {
            throw error
        }
    }
}

public enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}
