//
//  BaseException.swift
//  Domain
//
//  Created by thanos kottaridis on 1/2/23.
//

import Foundation

public struct BaseException {
    public let errorCode: Int
    public let throwable: Error?
    public let errorBody: AnyObject? // HERE GOSE BACK END EXCEPTION

    public init(
        errorCode: Int = -1,
        errorBody: AnyObject? = nil,
        throwable: Error? = nil
    ) {
        self.errorCode = errorCode
        self.errorBody = errorBody
        self.throwable = throwable
    }
}
