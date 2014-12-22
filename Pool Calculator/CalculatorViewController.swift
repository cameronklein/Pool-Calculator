//
//  CalculatorViewController.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 12/21/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

  @IBOutlet weak var topBar: UIView!
  @IBOutlet weak var desiredView: UIView!
  @IBOutlet weak var currentView: UIView!
  @IBOutlet weak var resultLabel: UILabel!
  var type : ReadingType = ReadingType.getType(.FreeChlorine)
  var currentValue: Double = 2.5
  var desiredValue : Double = 2.5
  var oldValue: Double!
  var newValue: Double!
  var calculator = ChemicalCalculator(gallons: 10000)
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  override func viewWillAppear(animated: Bool) {
    topBar.layer.shadowColor = UIColor.blackColor().CGColor
    topBar.layer.shadowOffset = CGSize(width: 0, height: 3)
    topBar.layer.shadowOpacity = 0.5
    topBar.layer.shadowRadius = 3
    
    for view in [currentView, desiredView] {
      let panner = UIPanGestureRecognizer()
      panner.addTarget(self, action: "didPanNumber:")
      view.addGestureRecognizer(panner)
    }
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }
  
  func didPanNumber(sender: UIPanGestureRecognizer) {
    if let view = sender.view? {
      if let numberLabel = view.subviews.first as? UILabel {

        switch sender.state {
        case .Began:
          if sender.view == currentView {
            oldValue = currentValue
          } else {
            oldValue = desiredValue
          }
          
        case .Changed:
          
          let translation = sender.translationInView(view)
          let ratio = translation.x / view.frame.width
          let delta = type.maxValue - type.minValue
          newValue = oldValue + Double(ratio) * Double(delta)
          
          if type.maxValue == 500 {
            newValue = newValue - newValue % 10
          }
          newValue = newValue - newValue % 0.1
          
          if newValue < type.minValue {
            newValue = type.minValue
          } else if Double(newValue) > type.maxValue {
            newValue = type.maxValue + 0.0001
          }
          
          if sender.view == currentView {
            currentValue = newValue
          } else {
            desiredValue = newValue
          }
          numberLabel.text = String(format: type.stringFormat, Double(newValue))
          resultLabel.text = calculateResult()
        default:
          return ()
        }
      }

    }
  }
  
  func calculateResult() -> String? {
    switch type.name {
      
    case "Free Chlorine":
      println("Switch called")
      return calculator.changeChlorineBy(desiredValue - currentValue)
    default:
      println("Switch called")
      return "Oops"
    }

  }
  

}
