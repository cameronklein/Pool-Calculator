//
//  DesiredValuesViewController.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 12/23/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit

class DesiredValuesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var readings = [Double]()
  var oldValue : Double!
  var newValue : Double!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.registerNib(UINib(nibName: "ReadingCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CELL");
    let userDefaults = NSUserDefaults.standardUserDefaults()
    readings.append(userDefaults.doubleForKey(kFreeChlorineDesiredValue))
    readings.append(userDefaults.doubleForKey(kPHDesiredValue))
    readings.append(userDefaults.doubleForKey(kTotalAlkalinityDesiredValue))
    readings.append(userDefaults.doubleForKey(kCalciumHardnessDesiredValue))
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 60.0
    self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 80.0))
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("CELL") as ReadingCell
    var rawValue = 0
    switch indexPath.row{
    case 0:
      rawValue = 0
    case 1:
      rawValue = 3
    case 2:
      rawValue = 4
    case 3:
      rawValue = 5
    default:
      rawValue = 0
    }
    cell.readingType = ReadingType.getType(Chemical(rawValue: rawValue)!)
    cell.title.text = cell.readingType?.name
    cell.readingValue.text = String(format: cell.readingType!.stringFormat, readings[indexPath.row] )
    cell.backgroundColor = UIColor.clearColor()
    cell.contentView.backgroundColor = UIColor.clearColor()
    cell.cancelLabel.alpha = 0
    cell.selectionStyle = .None
    
    let panner = UIPanGestureRecognizer()
    panner.addTarget(self, action: "didPanCell:")
    panner.delegate = self
    cell.addGestureRecognizer(panner)
    
    return cell
    
  }
  
  func didPanCell(sender: UIPanGestureRecognizer) {
    
    if let cell = sender.view as? ReadingCell {
      let row : Int = tableView.indexPathForCell(cell)!.row
      switch sender.state {
        
      case .Began:
        oldValue = readings[row]
        
      case .Changed:
        let type = cell.readingType!
        let translation = sender.translationInView(cell)
        let ratio = translation.x / cell.frame.width
        let delta = type.maxValue - type.minValue
        newValue = oldValue + type.minValue + Double(ratio) * Double(delta)
        
        if type.maxValue == 500 {
          newValue = newValue - newValue % 10
        }
        
        var isTooHigh = false
        
        if newValue < type.minValue {
          newValue = type.minValue
        } else if Double(newValue) > type.maxValue {
          newValue = type.maxValue + 0.0001
          isTooHigh = true
        }
        
        cell.readingValue.text = String(format: type.stringFormat, Double(newValue))

      case .Ended:
        var key : String
        switch row {
        case 0:
          key = kFreeChlorineDesiredValue
        case 1:
          key = kPHDesiredValue
        case 2:
          key = kTotalAlkalinityDesiredValue
        case 3:
          key = kCalciumHardnessDesiredValue
        default:
          return ()
        }
        readings[tableView.indexPathForCell(cell)!.row] = newValue
        NSUserDefaults.standardUserDefaults().setDouble(newValue, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
        
      default:
        return ()
      }
    }
  }
  
  func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
    if let panner = gestureRecognizer as? UIPanGestureRecognizer {
      let velocity = panner.velocityInView(panner.view!)
      return abs(velocity.y) < abs(velocity.x)
    }
    return true
  }
  
}
