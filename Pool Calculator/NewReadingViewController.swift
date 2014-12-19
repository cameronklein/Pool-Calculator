//
//  NewReadingViewController.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 12/18/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit

class NewReadingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
  
  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.registerNib(UINib(nibName: "ReadingCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CELL");
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }
  
  //MARK: - <UITableViewDataSource>
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 6
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("CELL") as ReadingCell
    
    cell.readingType = ReadingType.getType(Chemical(rawValue: indexPath.row)!)
    cell.title.text = cell.readingType?.name
    cell.readingValue.text = cell.readingType?.startingValue.description
    
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    let panner = UIPanGestureRecognizer()
    panner.addTarget(self, action: "didPanCell:")
    panner.delegate = self
    cell.addGestureRecognizer(panner)
    
    return cell
  }
  
  // MARK: - Gesture Recognizer Methods
  
  func didPanCell(sender: UIPanGestureRecognizer) {
    if sender.state == .Changed {
      if let cell = sender.view as? ReadingCell {
        let type = cell.readingType!
        let oldValue = (cell.readingValue.text! as NSString).floatValue
        let translation = sender.translationInView(cell)
        let ratio = translation.x / cell.frame.width
        let delta = type.maxValue - type.minValue
        let change = Double(ratio) * Double(type.maxValue) * delta / type.maxValue
        
        var newValue = Double(oldValue) + change
        
        var isTooHigh = false
        
        if newValue < type.minValue{
          newValue = type.minValue
        } else if Double(newValue) > type.maxValue {
          newValue = type.maxValue + 0.0001
          isTooHigh = true
        }
        
        cell.readingValue.text = String(format: "%.1f", Double(newValue))
        if isTooHigh {
          cell.readingValue.text! = cell.readingValue.text! + "+"
        }
        sender.setTranslation(CGPoint(x: 0,y: 0), inView: cell)
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
  
  

}
