//
//  Event.swift
//  Domain
//
//  Created by thanos kottaridis on 3/2/23.
//

import Foundation

public struct Event: Codable, Equatable {
    public var id: String?
    public var sportId: String?
    public var description: String?
    public var timestamp: Int?
    public var isFavorite: Bool = false
    
    public init(
        id: String? = nil,
        sportId: String? = nil,
        description: String? = nil,
        timestamp: Int? = nil,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.sportId = sportId
        self.description = description
        self.timestamp = timestamp
        self.isFavorite = isFavorite
    }
}
