//
//  Sports.swift
//  Data
//
//  Created by thanos kottaridis on 3/2/23.
//

import Foundation
import RealmSwift
import Domain

class SportEntity: Object, Codable {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var sportDescription: String = ""
    @Persisted var events: List<EventEntity>
}
