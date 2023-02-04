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
