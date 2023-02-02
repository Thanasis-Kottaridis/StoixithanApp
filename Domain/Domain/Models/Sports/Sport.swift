//
//  Sport.swift
//  Domain
//
//  Created by thanos kottaridis on 3/2/23.
//

import Foundation

public struct Sport: Codable {
   public var id: String?
   public var description: String?
   public var events: [Event]?
    
    public init(
        id: String? = nil,
        description: String? = nil,
        events: [Event]? = nil
    ) {
        self.id = id
        self.description = description
        self.events = events
    }
}
