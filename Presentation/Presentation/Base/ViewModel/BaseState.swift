//
//  BaseState.swift
//  Presentation
//
//  Created by thanos kottaridis on 1/2/23.
//

import Foundation

public protocol BaseState {
    var isLoading: Bool { get }
    var isOnline: Bool { get }
    
    func baseCopy(
        isLoading: Bool?,
        isOnline: Bool?
    ) -> Self
}

public struct VoidBaseState: BaseState {
    public let isLoading: Bool
    public let isOnline: Bool

    init(
        isLoading: Bool = false,
        isOnline: Bool = false
    ) {
        self.isLoading = isLoading
        self.isOnline = isOnline
    }
    
    public func copy(
        isLoading: Bool? = nil,
        isOnline: Bool? = nil
    ) -> Self {
        return VoidBaseState(
            isLoading: isLoading ?? self.isLoading,
            isOnline: isOnline ?? self.isOnline
        )
    }
    
    public func baseCopy(
        isLoading: Bool? = nil,
        isOnline: Bool? = nil
    ) -> Self {
        return self.copy(isLoading: isLoading, isOnline: isOnline)
    }
}
