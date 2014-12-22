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
  @IBOutlet weak var chlorineButton: UIButton!
  @IBOutlet weak var pHButton: UIButton!
  @IBOutlet weak var totalAlkalinityButton: UIButton!
  @IBOutlet weak var calciumHardnessButton: UIButton!
  @IBOutlet weak var cynuricAcidButton: UIButton!
  @IBOutlet weak var otherButton: UIButton!
  @IBOutlet weak var topScrollView: UIScrollView!
  
  var type : ReadingType = ReadingType.getType(.FreeChlorine)
  var currentValue: Double = 2.5
  var desiredValue : Double = 2.5
  var oldValue: Double!
  var newValue: Double!
  var calculator = ChemicalCalculator(gallons: 10000)
  var currentSelectionBar : UIView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addSelectionBarTo(chlorineButton)
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
      return calculator.changeChlorineBy(desiredValue - currentValue)
    default:
      return "Oops"
    }

  }
  
  
  @IBAction func didPressChemicalButton(sender: UIButton) {
    addSelectionBarTo(sender)
    
  }
  
  func addSelectionBarTo(button: UIButton) {
    currentSelectionBar?.removeFromSuperview()
    
    let barX = button.frame.origin.x
    let barY = button.frame.origin.y + button.frame.height - 6
    let barWidth = button.frame.width
    let barHeight : CGFloat = 2
    let selectionBar = UIView()
    selectionBar.frame = CGRect(x: barX, y: barY, width: barWidth, height: barHeight)
    selectionBar.backgroundColor = UIColor.whiteColor()
    topScrollView.addSubview(selectionBar)
    currentSelectionBar = selectionBar
  }

}
