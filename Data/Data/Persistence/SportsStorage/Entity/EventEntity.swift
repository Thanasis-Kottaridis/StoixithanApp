//
//  EventEntity.swift
//  Data
//
//  Created by thanos kottaridis on 4/2/23.
//

import Foundation
import RealmSwift
import Domain

class EventEntity: Object, Codable {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var sportId: String = ""
    @Persisted var eventDescription: String = ""
    @Persisted var timestamp: Int = 1
    @Persisted var isFavorite: Bool = false
}
