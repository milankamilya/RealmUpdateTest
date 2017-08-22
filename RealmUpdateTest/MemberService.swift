//
//  MemberService.swift
//  RealmUpdateTest
//
//  Created by Menlo on 22/08/17.
//  Copyright © 2017 zooft. All rights reserved.
//

import RealmSwift

class MemberService: AnyObject {
  func createAndUpdate(member: [String:Any]?) {
    
    guard let member = member else {
      return
    }
    
    do{
      let realm = try Realm()
      
      try realm.write {
        realm.create(Member.self, value: member, update: true)
      }
      
    } catch {}
  }
}
