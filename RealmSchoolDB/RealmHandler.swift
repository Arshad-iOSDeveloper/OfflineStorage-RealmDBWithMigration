//
//  RealmHandler.swift
//  RealmSchoolDB
//
//  Created by Arshad Shaik on 07/12/23.
//

import Foundation
import RealmSwift

class RealmHandler {
  static let shared = RealmHandler()
  
  func getDatabasePath() -> URL? {
    return Realm.Configuration.defaultConfiguration.fileURL
  }
  
  func saveToRealm<T: Object>(data: T) {
    let realm = try! Realm()
    try! realm.write({
      realm.add(data)
      realm.refresh()
    })
  }
  
}
