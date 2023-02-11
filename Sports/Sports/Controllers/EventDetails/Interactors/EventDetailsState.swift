//
//  EventDetailsState.swift
//  Sports
//
//  Created thanos kottaridis on 12/2/23.
//  Copyright © 2023 . All rights reserved.
//
//

import Foundation
import Domain
import Presentation

class EventDetailsState: BaseState {
    
    // Set variables here
    let isLoading: Bool
    let isOnline: Bool
    let eventId: String
    
    init(
         isLoading: Bool = false,
         isOnline: Bool = true,
         eventId: String // mendatory field.
     ) {
         self.isLoading = isLoading
         self.isOnline = isOnline
         self.eventId = eventId
     }
    
    func copy(
        isLoading: Bool? = nil,
        isOnline: Bool? = nil,
        eventId: String? = nil
    ) -> EventDetailsState {
        return EventDetailsState(
            isLoading: isLoading ?? self.isLoading,
            isOnline: isOnline ?? self.isOnline,
            eventId: eventId ?? self.eventId
        )
    }
    
    func baseCopy(
        isLoading: Bool?,
        isOnline: Bool?
    ) -> Self {
        return self.copy(isLoading: isLoading, isOnline: isOnline ) as! Self
    }
}
