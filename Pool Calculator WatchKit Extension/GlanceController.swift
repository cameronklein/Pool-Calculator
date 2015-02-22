//
//  GlanceController.swift
//  Pool Calculator WatchKit Extension
//
//  Created by Cameron Klein on 1/10/15.
//  Copyright (c) 2015 Cameron Klein. All rights reserved.
//

import WatchKit
import Foundation
import CoreData
import ReadingSyncKit

class GlanceController: WKInterfaceController {
  
  @IBOutlet weak var time: WKInterfaceLabel!
  @IBOutlet weak var firstReading: WKInterfaceLabel!
  @IBOutlet weak var secondReading: WKInterfaceLabel!
  
  var dataAccess = DataAccess.singleton
  var context : NSManagedObjectContext!
  var timeFormatter = NSDateFormatter()
  var dateFormatter = NSDateFormatter()
  

  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    
    timeFormatter.dateStyle = NSDateFormatterStyle.NoStyle
    timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    
    dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
    dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
    
    if let reading = getLastReading() {
      
      time.setText(getRelativeDayWithReading(reading) + timeFormatter.stringFromDate(reading.timestamp))
      
      if let number = reading.freeChlorine? {
        firstReading.setText(String(format: "%.1f", number.doubleValue))
      } else {
        firstReading.setText("--")
      }
      if let number = reading.pH? {
        secondReading.setText(String(format: "%.1f", number.doubleValue))
      } else {
        secondReading.setText("--")
      }
    }
  }

  override func willActivate() {
      super.willActivate()
  }

  override func didDeactivate() {
      super.didDeactivate()
  }
  
  func getLastReading() -> Reading? {
    
    context = dataAccess.managedObjectContext
    
    var fetchRequest = NSFetchRequest(entityName: "Reading")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
    fetchRequest.fetchBatchSize = 1
    
    var error : NSError?
    let result = context!.executeFetchRequest(fetchRequest, error: &error)
    
    if result?.count > 0 {
      if let reading = result?.first as? Reading {
        return reading
      }
    }
    return nil
  }
  
  func getOrdinalDay() -> NSNumber {
    
    var date = NSDate()
    let calendar = NSCalendar.currentCalendar()
    let offset = NSTimeZone.systemTimeZone().secondsFromGMTForDate(date)
    let dateForDay = date.dateByAddingTimeInterval(Double(offset))
    return calendar.ordinalityOfUnit(NSCalendarUnit.CalendarUnitDay, inUnit: NSCalendarUnit.CalendarUnitEra, forDate: dateForDay)
    
  }
  
  func getRelativeDayWithReading(reading: Reading) -> NSString {
    
    let todayOrdinal = getOrdinalDay()
    let readingOrdinal = reading.day
    let relativeOrdinal = todayOrdinal.integerValue - readingOrdinal.integerValue
    
    switch relativeOrdinal {
    case 0:
      return "Today @ "
    case -1:
      return "Yesterday @ "
    default:
      return dateFormatter.stringFromDate(reading.timestamp)
    }
    
  }

}
