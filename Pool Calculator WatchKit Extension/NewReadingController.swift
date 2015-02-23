//
//  NewReadingController.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 2/21/15.
//  Copyright (c) 2015 Cameron Klein. All rights reserved.
//

import WatchKit
import Foundation
import CoreData


class NewReadingController: WKInterfaceController {
  
  @IBOutlet weak var freeChlorineValue: WKInterfaceLabel!
  @IBOutlet weak var combinedChlorineValue: WKInterfaceLabel!
  @IBOutlet weak var totalChlorineLabel: WKInterfaceLabel!
  @IBOutlet weak var phLabel: WKInterfaceLabel!
  @IBOutlet weak var totalAlkalinityLabel: WKInterfaceLabel!
  @IBOutlet weak var calciumHardnessValue: WKInterfaceLabel!
  
  var freeChlorine : Double?
  var combinedChlorine: Double?
  var totalChlorine: Double?
  var pH : Double?
  var totalAlkalinity: Double?
  var calciumHardness: Double?
  
  var dataAccess = DataAccess.singleton
  var context : NSManagedObjectContext!

  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    
  }

  override func willActivate() {

    super.willActivate()
  }

  override func didDeactivate() {

    super.didDeactivate()
  }
  
  @IBAction func didPressFreeChlorineUp() {
    if freeChlorine != nil {
      freeChlorine! += 0.1
    } else {
      freeChlorine = 2.0
    }
    freeChlorineValue.setText("\(freeChlorine!)")
    
  }
  
  @IBAction func didPressFreeChlorineDown() {
    if freeChlorine != nil {
      freeChlorine! -= 0.1
    } else {
      freeChlorine = 2.0
    }
    freeChlorineValue.setText("\(freeChlorine!)")
  }
  
  @IBAction func didPressCombinedUp() {
    if combinedChlorine != nil {
      combinedChlorine! += 0.1
    } else {
      combinedChlorine = 2.0
    }
    combinedChlorineValue.setText("\(combinedChlorine!)")
  }
  
  @IBAction func didPressCombinedDown() {
    if combinedChlorine != nil {
      combinedChlorine! -= 0.1
    } else {
      combinedChlorine = 2.0
    }
    combinedChlorineValue.setText("\(combinedChlorine!)")
  }
  
  @IBAction func didPressTotalUp() {
    if totalChlorine != nil {
      totalChlorine! += 0.1
    } else {
      totalChlorine = 2.0
    }
    totalChlorineLabel.setText("\(totalChlorine!)")
  }
  
  @IBAction func didPressTotalDown() {
    if totalChlorine != nil {
      totalChlorine! -= 0.1
    } else {
      totalChlorine = 2.0
    }
    totalChlorineLabel.setText("\(totalChlorine!)")  }
  
  @IBAction func didPressphUp() {
    if pH != nil {
      pH! += 0.1
    } else {
      pH = 7.4
    }
    phLabel.setText("\(pH!)")
  }
  
  @IBAction func didPressphDown() {
    if pH != nil {
      pH! -= 0.1
    } else {
      pH = 7.4
    }
    phLabel.setText("\(pH!)")
  }
  
  @IBAction func didPressAlkalinityUp() {
    if totalAlkalinity != nil {
      totalAlkalinity! += 10
    } else {
      totalAlkalinity = 100
    }
    totalAlkalinityLabel.setText("\(totalAlkalinity!)")
  }
  @IBAction func didPressAlkalinityDown() {
    if totalAlkalinity != nil {
      totalAlkalinity! -= 10
    } else {
      totalAlkalinity = 100
    }
    totalAlkalinityLabel.setText("\(totalAlkalinity!)")
  }
  
  @IBAction func didPressCalciumUp() {
    if calciumHardness != nil {
      calciumHardness! += 10
    } else {
      calciumHardness = 200
    }
    calciumHardnessValue.setText("\(calciumHardness!)")
  }
  
  @IBAction func didPressCalciumDown() {
    if calciumHardness != nil {
      calciumHardness! -= 10
    } else {
      calciumHardness = 200
    }
    calciumHardnessValue.setText("\(calciumHardness!)")
  }
  
  @IBAction func didPressSubmit() {
    
    context = dataAccess.managedObjectContext
    
    let reading = NSEntityDescription.insertNewObjectForEntityForName("Reading", inManagedObjectContext: context!) as Reading
    
    reading.freeChlorine = freeChlorine
    reading.combinedChlorine = combinedChlorine
    reading.totalChlorine = totalChlorine
    reading.pH = pH
    reading.totalAlkalinity = totalAlkalinity
    reading.calciumHardness = calciumHardness
    reading.timestamp = NSDate()
    reading.day = getOrdinalDay()
    
    var error : NSError?
    context?.save(&error)
    
    if error != nil {
      println(error?.localizedDescription)
    } else {
      popToRootController()
    }
    //clearReadings()

  }
  
  func getOrdinalDay() -> NSNumber {
    
    var date = NSDate()
    let calendar = NSCalendar.currentCalendar()
    let offset = NSTimeZone.systemTimeZone().secondsFromGMTForDate(date)
    let dateForDay = date.dateByAddingTimeInterval(Double(offset))
    return calendar.ordinalityOfUnit(NSCalendarUnit.CalendarUnitDay, inUnit: NSCalendarUnit.CalendarUnitEra, forDate: dateForDay)
    
  }
  
  
  

}
