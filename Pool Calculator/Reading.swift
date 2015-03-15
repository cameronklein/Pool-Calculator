//
//  Reading.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 12/19/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import Foundation
import CoreData

@objc(Reading)
class Reading: NSManagedObject {

  @NSManaged var freeChlorine: NSNumber?
  @NSManaged var combinedChlorine: NSNumber?
  @NSManaged var totalChlorine: NSNumber?
  @NSManaged var pH: NSNumber?
  @NSManaged var totalAlkalinity: NSNumber?
  @NSManaged var calciumHardness: NSNumber?
  
  @NSManaged var timestamp: NSDate
  @NSManaged var day : NSNumber
  
}
