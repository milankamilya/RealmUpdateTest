//
//  Member.swift
//  RealmUpdateTest
//
//  Created by Menlo on 22/08/17.
//  Copyright © 2017 zooft. All rights reserved.
//

import RealmSwift

class Member: Object {
  dynamic var _id: String?
  dynamic var role: String?
  dynamic var lastSeenAt: String?
  
  override class func primaryKey() -> String? {
    return "_id"
  }
}
