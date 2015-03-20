//
//  Pool.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 12/23/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import Foundation
import CoreData

enum PoolType : Int {
  case Pool, HotTub
}

class Pool: NSManagedObject {

  @NSManaged var owner: NSString?
  @NSManaged var name : NSString?
  @NSManaged var gallons: NSNumber
  @NSManaged var type: NSNumber
  @NSManaged var latitude: NSNumber?
  @NSManaged var longitude: NSNumber?

}
