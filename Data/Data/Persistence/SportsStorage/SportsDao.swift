//
//  SportsDao.swift
//  Data
//
//  Created by thanos kottaridis on 3/2/23.
//

import Foundation
import RealmSwift

protocol SportDao {
    
    func storeSport(sport: SportEntity)
    
    func storeSports(sports: [SportEntity])
    
    func getSport(byId: String) -> SportEntity?
    
    func getAllSports() -> [SportEntity]
    
    func deleteSports(byId: String)
    
    func deleteAllDocuments()
}

protocol EventDao {
    func storeEvent(event: EventEntity)
    
    func storeEvents(events: [EventEntity])
        
    func getEvent(byId: String) -> EventEntity?
    
    func getAllEvents() -> [EventEntity]
    
    func updateFavoriteEvent(byId: String, isFavorite: Bool)
            
    func deleteEvents(byId: String)

    func deleteAllEvents()
}

class SportDaoImpl: SportDao {
    
    private var realm : Realm {
       return RealmManager.shared.provideRealm()
    }
    
    func storeSport(sport: SportEntity) {
        try! realm.write{
            realm.add(sport, update: .modified)
        }
    }
    
    func storeSports(sports: [SportEntity]) {
        try! realm.write{
            realm.add(sports, update: .modified)
        }
    }
    
    func getSport(byId id: String) -> SportEntity? {
        return realm.object(ofType: SportEntity.self, forPrimaryKey: id)
    }
    
    func getAllSports() -> [SportEntity] {
        return Array(realm.objects(SportEntity.self))

    }
    
    func deleteSports(byId id: String) {
        try! realm.write {
            guard let doc = getSport(byId: id) else {
                return
            }
            
            // Delete the instance from the realm.
            realm.delete(doc)
        }
    }
    
    func deleteAllDocuments() {
        try! realm.write {
            // Delete all instances of sports from the realm.
            let allDocs = Array(realm.objects(SportEntity.self))
            realm.delete(allDocs)
        }
    }
}

class EventDaoImpl: EventDao {
    
    private var realm : Realm {
       return RealmManager.shared.provideRealm()
    }
    
    func storeEvent(event: EventEntity) {
        try! realm.write{
            realm.add(event, update: .modified)
        }
    }
    
    func storeEvents(events: [EventEntity]) {
        try! realm.write{
            realm.add(events, update: .modified)
        }
    }
    
    func getEvent(byId id: String) -> EventEntity? {
        return realm.object(ofType: EventEntity.self, forPrimaryKey: id)
    }
    
    func getAllEvents() -> [EventEntity] {
        return Array(realm.objects(EventEntity.self))
    }
    
    func updateFavoriteEvent(byId id: String, isFavorite: Bool) {
        try! realm.write {
            guard let event = getEvent(byId: id) else {
                return
            }
            
            // update isFavorite property
            // These changes automaticaly saved to Realm
            event.isFavorite = isFavorite
        }
    }
    
    func deleteEvents(byId id: String) {
        try! realm.write {
            guard let doc = getEvent(byId: id) else {
                return
            }
            
            // Delete the instance from the realm.
            realm.delete(doc)
        }
    }
    
    func deleteAllEvents() {
        try! realm.write {
            // Delete all instances of sports from the realm.
            let allDocs = Array(realm.objects(EventEntity.self))
            realm.delete(allDocs)
        }
    }
}
