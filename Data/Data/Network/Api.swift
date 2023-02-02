//
//  Api.swift
//  Data
//
//  Created by thanos kottaridis on 2/2/23.
//

import Foundation
import Domain
import Alamofire

enum Api: URLRequestConvertible {
   
    private var appConfig: DataAppConfig {
        @Injected(\.dataAppConfig)
        var appConfig: DataAppConfig
        return appConfig
    }
    
    case mockApi
    
    var path: String {
        switch self {
        case .mockApi:
            return "api/sports"
        }
        
    }
    
    var method: HTTPMethod {
        switch self {
        case .mockApi:
            return .get
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .mockApi:
            return URLEncoding.default
        }
    }
    
    // TODO: - Add implementation for headers here. Returns empty headers for now
    var headers: [String: String] {
        return [:]
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = try appConfig.appApiBaseUrl.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        // TODO: - Add implementation for params here. Returns empty headers for now
        var parameters: Parameters?
        
        // Log request
        print(request)
        return try encoding.encode(request, with: parameters)
    }
}

