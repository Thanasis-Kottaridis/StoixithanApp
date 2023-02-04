//
//  RealmManager.swift
//  Data
//
//  Created by thanos kottaridis on 3/2/23.
//

import Foundation
import RealmSwift

class RealmManager: NSObject {
    
    // MARK: - Make it singleton
    /**
        Make init file private in order to create a singleton
        RealmManager object in Data Module.
        #SOS
        Realm should be visible / imported only within Data Module.
     */
    fileprivate override init(){}
    static let shared = RealmManager()
    
    func provideRealm() -> Realm {
        let realm = try! Realm()
        return realm
    }
}

extension RealmCollection {
  func toArray<T>() ->[T] {
    return self.compactMap{
        $0 as? T
    }
  }
}
