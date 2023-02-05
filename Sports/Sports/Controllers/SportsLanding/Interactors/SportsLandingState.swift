//
//  SportsLandingState.swift
//  Sports
//
//  Created thanos kottaridis on 4/2/23.
//  Copyright © 2023 . All rights reserved.
//
//

import Foundation
import Domain
import Presentation
import RxDataSources

class SportsLandingState: BaseState {
    
    // Set variables here
    let isLoading: Bool
    let isOnline: Bool
    let spotrsList: [Sport]
    // We use dict here in order to make quick
    // serches on cllapsed sport heders by sport ID
    let collapsedSports: [String : Sport]
    
    // Computed property that returs displayable list with sports in sections
    // each section has only one sport.
    var sportsListDisplayable: [SectionModel<String,Sport>] {
        return spotrsList.map { SectionModel(
            model: $0.id ?? "",
            items: collapsedSports.contains(key: $0.id ?? "") ? [] :[$0]
        ) }
    }
    
    init(
         isLoading: Bool = false,
         isOnline: Bool = true,
         spotrsList: [Sport] = [],
         collapsedSports: [String : Sport] = [:]
     ) {
         self.isLoading = isLoading
         self.isOnline = isOnline
         self.spotrsList = spotrsList
         self.collapsedSports = collapsedSports
     }
    
    func copy(
        isLoading: Bool? = nil,
        isOnline: Bool? = nil,
        spotrsList: [Sport]? = nil,
        collapsedSports: [String : Sport]? = nil
    ) -> SportsLandingState {
        return SportsLandingState(
            isLoading: isLoading ?? self.isLoading,
            isOnline: isOnline ?? self.isOnline,
            spotrsList: spotrsList ?? self.spotrsList,
            collapsedSports: collapsedSports ?? self.collapsedSports
        )
    }
    
    func baseCopy(
        isLoading: Bool?,
        isOnline: Bool?
    ) -> Self {
        return self.copy(isLoading: isLoading, isOnline: isOnline) as! Self
    }
}
