//
//  Router.swift
//  Cat
//
//  Created by Deekshith Bellare on 04/08/20.
//  Copyright © 2020 Deekshith Bellare. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
    case qa
    case production
    case staging
}

enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String> {
    case success
    case failure(String)
}

public typealias NetworkRouterCompletion = (_ data: Data?, _ error: String?) -> Void

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

class Router<EndPoint: EndPointType>: NetworkRouter {
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            let request = try buildRequest(from: route)
            NetworkLogger.log(request: request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                
                if error != nil {
                    completion(nil, error?.localizedDescription)
                }
                
                if let response = response as? HTTPURLResponse {
                    let result = self.handleNetworkResponse(response)
                    switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(nil, NetworkResponse.noData.rawValue)
                            return
                        }
                        completion(responseData, nil)
                        
                    case let .failure(networkFailureError):
                        completion(nil, networkFailureError)
                    }
                }
            })
        } catch {
            completion(nil, "Error, Please check again")
        }
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                return request
            case let .requestParameters(bodyParameters,
                                        bodyEncoding,
                                        urlParameters):
                
                return try configureParameters(bodyParameters: bodyParameters,
                                               bodyEncoding: bodyEncoding,
                                               urlParameters: urlParameters,
                                               request: request)
                
            case let .requestParametersAndHeaders(bodyParameters,
                                                  bodyEncoding,
                                                  urlParameters,
                                                  additionalHeaders):
                
                addAdditionalHeaders(additionalHeaders, request: &request)
                return try configureParameters(bodyParameters: bodyParameters,
                                               bodyEncoding: bodyEncoding,
                                               urlParameters: urlParameters,
                                               request: request)
            }
            
        } catch {
            throw error
        }
    }
    
    private func configureParameters(bodyParameters: Parameters?,
                                     bodyEncoding: ParameterEncoding,
                                     urlParameters: Parameters?,
                                     request: URLRequest) throws -> URLRequest {
        do {
            return try bodyEncoding.encode(urlRequest: request,
                                           bodyParameters: bodyParameters, urlParameters: urlParameters) ?? request
        } catch {
            throw error
        }
    }
    
    private func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200 ... 299: return .success
        case 401 ... 500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501 ... 599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
