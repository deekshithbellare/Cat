//
//  HTTPTask.swift
//  Cat
//
//  Created by Deekshith Bellare on 04/08/20.
//  Copyright © 2020 Deekshith Bellare. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public enum HTTPTask {
    case request

    case requestParameters(bodyParameters: Parameters?,
                           bodyEncoding: ParameterEncoding,
                           urlParameters: Parameters?)

    case requestParametersAndHeaders(bodyParameters: Parameters?,
                                     bodyEncoding: ParameterEncoding,
                                     urlParameters: Parameters?,
                                     additionHeaders: HTTPHeaders?)

    // case download, upload...etc
}
