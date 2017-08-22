//
//  TeamService.swift
//  RealmUpdateTest
//
//  Created by Menlo on 22/08/17.
//  Copyright © 2017 zooft. All rights reserved.
//

import RealmSwift

class TeamService: NSObject {
  func createAndUpdate(teams: [[String:Any]]?) {
    
    guard let teams = teams else {
      return
    }
    
    do{
      let realm = try Realm()
      
      try realm.write {
        for team in teams {
          realm.create(Team.self, value: team, update: true)
        }
      }
      
    } catch {}
  }
}
