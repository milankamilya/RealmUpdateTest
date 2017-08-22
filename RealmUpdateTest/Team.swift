//
//  Team.swift
//  RealmUpdateTest
//
//  Created by Menlo on 22/08/17.
//  Copyright © 2017 zooft. All rights reserved.
//

import RealmSwift

class Team: Object {
  dynamic var channelId: String? = nil
  dynamic var title: String? = nil
  dynamic var descriptions: String? = nil
  dynamic var createdAt: String? = nil
  dynamic var logo: String? = nil
  
  let members = List<Member>()
  
  override class func primaryKey() -> String? {
    return "channelId"
  }
}
