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
  
  var readings = [Double?]()
  var oldValue : Double!
  var newValue : Double!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.registerNib(UINib(nibName: "ReadingCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CELL");
    readings = [nil, nil, nil, nil, nil, nil]
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 60.0
    self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 80.0))
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 6
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
    
    return cell
    
  }
  
  func didPanCell(sender: UIPanGestureRecognizer) {
    
    if let cell = sender.view as? ReadingCell {
      
      switch sender.state {
        
      case .Began:
        if let value = readings[tableView.indexPathForCell(cell)!.row] {
          oldValue = value
        } else {
          oldValue = 0.0
        }
        
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
        
        if isTooHigh {
          cell.readingValue.text! = cell.readingValue.text! + "+"
        }
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
          cell.cancelLabel.alpha = 1
          cell.cancelLabel.transform = CGAffineTransformMakeScale(1.4, 1)
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
  
  func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
    if let panner = gestureRecognizer as? UIPanGestureRecognizer {
      let velocity = panner.velocityInView(panner.view!)
      return abs(velocity.y) < abs(velocity.x)
    }
    return true
  }
  
}
