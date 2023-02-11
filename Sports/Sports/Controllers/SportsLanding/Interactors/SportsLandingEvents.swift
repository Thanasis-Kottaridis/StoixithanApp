//
//  SportsLandingEvents.swift
//  Sports
//
//  Created thanos kottaridis on 4/2/23.
//  Copyright © 2023 . All rights reserved.
//
//

import Foundation
import Domain

enum SportsLandingEvents {
    // Set enum cases here
    case fetchData
    case refreshData
    case collapseSport(sport: Sport, isExpand: Bool)
    case selectFavoriteEvent(eventId: String, isFavorite: Bool)
    case goToEventDetails(eventId: String)
}
