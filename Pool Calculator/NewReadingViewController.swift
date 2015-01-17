//
//  NewReadingViewController.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 12/18/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit
import CoreData

class NewReadingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
  
  var headerText = "New Reading"
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var topBar: UIView!
  var readings = [Double?]()
  var oldValue : Double!
  var newValue : Double!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.registerNib(UINib(nibName: "ReadingCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CELL");
    tableView.registerNib(UINib(nibName: "SubmitCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "SUBMIT");
    readings = [nil, nil, nil, nil, nil, nil]
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 60.0
    self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 80.0))
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillAppear(animated: Bool) {
    topBar.layer.shadowColor = UIColor.blackColor().CGColor
    topBar.layer.shadowOffset = CGSize(width: 0, height: 3)
    topBar.layer.shadowOpacity = 0.5
    topBar.layer.shadowRadius = 3
  }
  
  //MARK: - <UITableViewDataSource>
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 7
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    if indexPath.row < 6 {
      let cell = tableView.dequeueReusableCellWithIdentifier("CELL") as ReadingCell
      cell.readingType = ReadingType.getType(Chemical(rawValue: indexPath.row)!)
      cell.title.text = cell.readingType?.name
      if let readingValue = readings[indexPath.row] {
        cell.readingValue.text = String(format: cell.readingType!.stringFormat, readingValue)
        cell.cancelLabel.alpha = 1
        cell.cancelLabel.transform = CGAffineTransformMakeScale(1.4, 1)
      } else {
        cell.readingValue.text = "--"
        cell.cancelLabel.alpha = 0
        cell.cancelLabel.transform = CGAffineTransformMakeScale(0.01, 1)
      }
    
      cell.selectionStyle = .None
      
      let panner = UIPanGestureRecognizer()
      panner.addTarget(self, action: "didPanCell:")
      panner.delegate = self
      cell.addGestureRecognizer(panner)
      
      let tapper = UITapGestureRecognizer()
      tapper.addTarget(self, action: "didTapCancel:")
      tapper.delegate = self
      cell.cancelLabel.addGestureRecognizer(tapper)
      return cell
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier("SUBMIT") as SubmitCell
      cell.selectionStyle = .None
      return cell
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.row == 6 {
      addReading()
    }
  }
  
  // MARK: - Gesture Recognizer Methods
  
  func didPanCell(sender: UIPanGestureRecognizer) {
    
    if let cell = sender.view as? ReadingCell {
      let type = cell.readingType!
      
      switch sender.state {
        
      case .Began:
        if let value = readings[tableView.indexPathForCell(cell)!.row] {
          oldValue = value
        } else {
          oldValue = type.minValue
        }
        
      case .Changed:
        
        let translation = sender.translationInView(cell)
        let ratio = translation.x / cell.frame.width
        let delta = type.maxValue - type.minValue
        newValue = oldValue /*+ type.minValue*/ + Double(ratio) * Double(delta)
        
        if type.maxValue == 500 {
          newValue = newValue - newValue % 10
        }
        
        var isTooHigh = false
        
        newValue = max(newValue!, type.minValue)
        
        if Double(newValue) > type.maxValue {
          newValue = type.maxValue
          isTooHigh = true
        }
        
        cell.readingValue.text = String(format: type.stringFormat, Double(newValue))

        if isTooHigh {
          cell.readingValue.text! = cell.readingValue.text! + "+"
        }
        
        UIView.animateWithDuration(0.4,
          delay: 0.0,
          options: UIViewAnimationOptions.AllowUserInteraction,
          animations: { () -> Void in
            cell.cancelLabel.alpha = 1
            cell.cancelLabel.transform = CGAffineTransformMakeScale(1.4, 1)
            if cell.readingType!.name != "pH" {
              cell.unitsLabel.alpha = 1
              
            }
            
        }, completion: { (success) -> Void in
          return ()
        })
        
      case .Ended:
        readings[tableView.indexPathForCell(cell)!.row] = newValue
        
      default:
        return ()
      }
    }
  }
  
  func didTapCancel(sender: UITapGestureRecognizer) {
    if let cell = sender.view?.superview?.superview as? ReadingCell {
      readings[tableView.indexPathForCell(cell)!.row] = nil
      cell.unitsLabel.alpha = 0
      cell.readingValue.text = "--"
      UIView.animateWithDuration(0.4, delay: 0.0, options: .AllowUserInteraction, animations: { () -> Void in
        sender.view?.alpha = 0
        sender.view?.transform = CGAffineTransformMakeScale(0.01, 1)
        
      }, completion: { (success) -> Void in
        return ()
      })
    }
    
  }
  
  // MARK: - <UIGestureRecognizerDelegate>
  
  func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
      if let panner = gestureRecognizer as? UIPanGestureRecognizer {
        let velocity = panner.velocityInView(panner.view!)
        return abs(velocity.y) < abs(velocity.x)
      }
    return true
  }

  // MARK: - Helper Methods
  
  func addReading(){
    let appDel = UIApplication.sharedApplication().delegate as AppDelegate
    let context = appDel.managedObjectContext
    let reading = NSEntityDescription.insertNewObjectForEntityForName("Reading", inManagedObjectContext: context!) as Reading

    reading.freeChlorine = readings[0]
    reading.combinedChlorine = readings[1]
    reading.totalChlorine = readings[2]
    reading.pH = readings[3]
    reading.totalAlkalinity = readings[4]
    reading.calciumHardness = readings[5]

    var date = NSDate()
    //date = date.dateByAddingTimeInterval(60*60*24)
    reading.timestamp = date
    let calendar = NSCalendar.currentCalendar()
    let offset = NSTimeZone.systemTimeZone().secondsFromGMTForDate(date)
    let dateForDay = date.dateByAddingTimeInterval(Double(offset))
    reading.day = calendar.ordinalityOfUnit(NSCalendarUnit.CalendarUnitDay, inUnit: NSCalendarUnit.CalendarUnitEra, forDate: dateForDay)
    var error : NSError?
    context?.save(&error)
    if error != nil {
      println(error?.localizedDescription)
    } else {
      if let parent = self.parentViewController as? ContainerViewController {
        parent.switchViewControllerTo(parent.historyVC, animated: true)
        parent.setButtonToInactive(parent.selectorOne)
        parent.setButtonToActive(parent.selectorTwo, animated: true)
      }
    }

  }
  
}
