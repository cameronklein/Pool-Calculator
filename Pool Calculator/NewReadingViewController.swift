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
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var topBar: UIView!
  var readings = [Double?]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.registerNib(UINib(nibName: "ReadingCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CELL");
    readings = [nil, nil, nil, nil, nil, nil]
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
    return 6
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("CELL") as ReadingCell
    
    cell.readingType = ReadingType.getType(Chemical(rawValue: indexPath.row)!)
    cell.title.text = cell.readingType?.name
    if let readingValue = readings[indexPath.row] {
      switch indexPath.row{
      case 0...3:
        cell.readingValue.text = String(format: "%.1f", readingValue)
      default:
        cell.readingValue.text = String(format: "%.0f", readingValue)
      }
    } else {
      cell.readingValue.text = "--"
    }
  
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    let panner = UIPanGestureRecognizer()
    panner.addTarget(self, action: "didPanCell:")
    panner.delegate = self
    cell.addGestureRecognizer(panner)
    return cell

  }
  
  // MARK: - Gesture Recognizer Methods
  
  func didPanCell(sender: UIPanGestureRecognizer) {
    if let cell = sender.view as? ReadingCell {
      let type = cell.readingType!
      let translation = sender.locationInView(cell)
      let ratio = (translation.x / (cell.frame.width - 100)) - (50 / cell.frame.width)
      let delta = type.maxValue - type.minValue
      var newValue = type.minValue + Double(ratio) * Double(delta)
      
      var isTooHigh = false
      
      if newValue < type.minValue{
        newValue = type.minValue
      } else if Double(newValue) > type.maxValue {
        newValue = type.maxValue + 0.0001
        isTooHigh = true
      }
      readings[tableView.indexPathForCell(cell)!.row] = newValue
      if type.maxValue == 500 {
        cell.readingValue.text = String(format: "%.0f", Double(newValue))
      } else {
        cell.readingValue.text = String(format: "%.1f", Double(newValue))
      }

      if isTooHigh {
        cell.readingValue.text! = cell.readingValue.text! + "+"
      }
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
  
  func addReading(){
    let appDel = UIApplication.sharedApplication().delegate as AppDelegate
    let context = appDel.managedObjectContext
    let reading = NSEntityDescription.insertNewObjectForEntityForName("Reading", inManagedObjectContext: context!) as Reading
    if readings[0] != nil {
      reading.freeChlorine = NSNumber(double: readings[0]!)
    } else {
      reading.freeChlorine = -1
    }
    if readings[1] != nil {
      reading.combinedChlorine = NSNumber(double: readings[1]!)
    }
    else {
      reading.combinedChlorine = -1
    }
    if readings[2] != nil {
      reading.totalChlorine = NSNumber(double: readings[2]!)
    }
    else {
      reading.totalChlorine = -1
    }
    if readings[3] != nil {
      reading.pH = NSNumber(double: readings[4]!)
    }
    else {
      reading.pH = -1
    }
    if readings[4] != nil {
      reading.totalAlkalinity = NSNumber(double: readings[4]!)
    }
    else {
      reading.totalAlkalinity = -1
    }
    if readings[5] != nil {
      reading.calciumHardness = NSNumber(double: readings[5]!)
    }
    else {
      reading.calciumHardness = -1
    }

    reading.timestamp = NSDate()
    var error : NSError?
    context?.save(&error)
    if error != nil {
      println(error?.localizedDescription)
    }

  }
  
}
