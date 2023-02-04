//
//  DataRequest_Ext.swift
//  Data
//
//  Created by thanos kottaridis on 3/2/23.
//

import Foundation
import Domain
import Alamofire

extension DataRequest {
    
    @discardableResult
    func prettyPrintedJsonResponse() -> Self {
        return responseJSON { (response) in
            switch response.result {
            case .success(let result):
                if let data = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted),
                   let text = String(data: data, encoding: .utf8) {
                    print("📗 prettyPrinted JSON response: \n \(text)")
                }
            case .failure: break
            }
        }
    }
    
    @discardableResult
    public func validateResponseWrapper<T>(
        fromType: T.Type,
        completion: @escaping (Domain.Result<T?, BaseException>) -> Void
    ) -> Self where T: (Codable) {
        
        return validateResponseWrapper(
            fromType: T.self,
            mapperType: T.self,
            mapper: { response in
                return response
            },
            completion: completion
        )
    }
    
    @discardableResult
    public func validateResponseWrapper<T, M>(
        fromType: T.Type,
        mapperType: M.Type,
        mapper: @escaping (T) -> M?,
        cacheLocaly: ((M?) -> Void)? = nil,
        completion: @escaping (Domain.Result<M?, BaseException>) -> Void
    ) -> Self where T: (Codable) {
        
        return validate()
            .prettyPrintedJsonResponse()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let data):
                    let mappedData = mapper(data)
                    cacheLocaly?(mappedData)
                    completion(Result.Success(mappedData))
                case .failure(let error):
                    completion(Result.Failure(
                        BaseException(
                            errorCode: error.responseCode ?? -1,
                            throwable: error
                        )
                    ))
                }
            }
    }
}
