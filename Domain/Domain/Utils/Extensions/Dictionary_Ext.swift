//
//  Dictionary_Ext.swift
//  Domain
//
//  Created by thanos kottaridis on 5/2/23.
//

import Foundation

extension Dictionary {
  public func contains(key: Key) -> Bool {
    self.index(forKey: key) != nil
  }
}
