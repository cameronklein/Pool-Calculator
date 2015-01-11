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
  @IBOutlet weak var thirdReading: WKInterfaceLabel!
  
  var dataAccess = DataAccess.singleton
  var context : NSManagedObjectContext!
  var timeFormatter = NSDateFormatter()
  

  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    
    timeFormatter.dateStyle = NSDateFormatterStyle.NoStyle
    timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    
    if let reading = getLastReading() {
      
      time.setText(timeFormatter.stringFromDate(reading.timestamp))
      if let number = reading.freeChlorine? {
        firstReading.setText("Free Chlorine: " + String(format: "%.1f", number.doubleValue))
      } else {
        firstReading.setText("--")
      }
      if let number = reading.combinedChlorine? {
        secondReading.setText("Combined Chlorine: " + String(format: "%.1f", number.doubleValue))
      } else {
        secondReading.setText("--")
      }
      if let number = reading.pH? {
        thirdReading.setText("pH: " + String(format: "%.1f", number.doubleValue))
      } else {
        thirdReading.setText("--")
      }
    }
  }

  override func willActivate() {
      // This method is called when watch view controller is about to be visible to user
      super.willActivate()
  }

  override func didDeactivate() {
      // This method is called when watch view controller is no longer visible
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

}
