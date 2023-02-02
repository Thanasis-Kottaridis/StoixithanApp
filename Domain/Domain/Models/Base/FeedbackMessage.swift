//
//  FeedbackMessage.swift
//  Domain
//
//  Created by thanos kottaridis on 29/1/23.
//

import Foundation

public enum FeedbackMessageType {
    case success
    case error
    case info
    case network(isError: Bool)
}

public struct FeedbackMessage {
    public let message: String
    public let type: FeedbackMessageType
    
    public init(message: String, type: FeedbackMessageType) {
        self.message = message
        self.type = type
    }
    
    public static func getNetworkFeedbackMessage(isOnline: Bool) -> Self {
        return FeedbackMessage(
            message: isOnline ? "Strings.gov_wallet__network_restored" : "Strings.gov_wallet__network_error",
            type: .network(isError: !isOnline)
        )
    }
}
