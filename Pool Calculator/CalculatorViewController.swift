//
//  CalculatorViewController.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 12/21/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit
import CoreData

class CalculatorViewController: UIViewController {

  @IBOutlet weak var settingsButton: UILabel!
  @IBOutlet weak var topBar: UIView!
  @IBOutlet weak var desiredView: UIView!
  @IBOutlet weak var desiredLabel: UILabel!
  @IBOutlet weak var currentLabel: UILabel!
  @IBOutlet weak var currentView: UIView!
  @IBOutlet weak var resultLabel: UILabel!
  @IBOutlet weak var chlorineButton: UIButton!
  @IBOutlet weak var pHButton: UIButton!
  @IBOutlet weak var totalAlkalinityButton: UIButton!
  @IBOutlet weak var calciumHardnessButton: UIButton!
  @IBOutlet weak var cynuricAcidButton: UIButton!
  @IBOutlet weak var otherButton: UIButton!
  @IBOutlet weak var topScrollView: UIScrollView!
  
  var calculator = ChemicalCalculator()
  var type : ReadingType = ReadingType.getType(.FreeChlorine)
  var lastReading: Reading?
  
  var currentValue: Double = 2.5
  var desiredValue : Double = 2.5
  var oldValue: Double!
  var newValue: Double!
  var selectionBar : UIView?
  var lastButton : UIButton!
  var currentButton : UIButton!
  
  var context : NSManagedObjectContext!
  
  // MARK: - UIViewController Lifecycle Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let appDel = UIApplication.sharedApplication().delegate as AppDelegate
    context = appDel.managedObjectContext
    addSelectionBarTo(chlorineButton, animated: false)
    
    let tapper = UITapGestureRecognizer()
    tapper.addTarget(self, action: "didTapSettings:")
    self.settingsButton.addGestureRecognizer(tapper)
    
  }
  
  override func viewWillAppear(animated: Bool) {
    addTopBarShadow()
    if getLastReading() {
      updateCurrentReading()
      resultLabel.text = calculateResult()
    }
    for view in [currentView, desiredView] {
      let panner = UIPanGestureRecognizer()
      panner.addTarget(self, action: "didPanNumber:")
      view.addGestureRecognizer(panner)
    }
    
    if NSUserDefaults.standardUserDefaults().boolForKey(kUserSettingsCalculatorMode){
      settingsButton.alpha = 1
    } else {
      settingsButton.alpha = 0
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  // MARK: - Helper Methods
  
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
  
  func updateCurrentReading() {
    var value : Double
    switch type.name {
    case "Free Chlorine":
      if let myValue = lastReading?.freeChlorine?.doubleValue {
        value = myValue
      } else {
        value = NSUserDefaults.standardUserDefaults().doubleForKey(kFreeChlorineDesiredValue)
      }
    case "pH":
      if let myValue = lastReading?.pH?.doubleValue {
        value = myValue
      } else {
        value = NSUserDefaults.standardUserDefaults().doubleForKey(kPHDesiredValue)
      }
    case "Total Alkalinity":
      if let myValue = lastReading?.totalAlkalinity?.doubleValue {
        value = myValue
      } else {
        value = NSUserDefaults.standardUserDefaults().doubleForKey(kTotalAlkalinityDesiredValue)
      }
    case "Calcium Hardness":
      if let myValue = lastReading?.calciumHardness?.doubleValue {
        value = myValue
      } else {
        value = NSUserDefaults.standardUserDefaults().doubleForKey(kCalciumHardnessDesiredValue)
      }
    default:
      return ()
    }
    currentValue = value
    currentLabel.text = String(format: type.stringFormat, value)
  }
  
  func updateDesiredReading() {
    var value : Double!
    switch type.name {
    case "Free Chlorine":
      value = NSUserDefaults.standardUserDefaults().doubleForKey(kFreeChlorineDesiredValue)
    case "pH":
      value = NSUserDefaults.standardUserDefaults().doubleForKey(kPHDesiredValue)
    case "Total Alkalinity":
      value = NSUserDefaults.standardUserDefaults().doubleForKey(kTotalAlkalinityDesiredValue)
    case "Calcium Hardness":
      value = NSUserDefaults.standardUserDefaults().doubleForKey(kCalciumHardnessDesiredValue)
    default:
      return ()
    }
    if value == nil {
      value = 0.0
    }
    desiredValue = value
    desiredLabel.text = String(format: type.stringFormat, value)
  }
  
  func getLastReading() -> Bool{
    var fetchRequest = NSFetchRequest(entityName: "Reading")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
    fetchRequest.fetchBatchSize = 1
    
    var error : NSError?
    let result = context!.executeFetchRequest(fetchRequest, error: &error)
    
    if result?.count > 0 {
      if let reading = result?.first as? Reading {
        lastReading = reading
      }
    }
    return lastReading != nil
  }
  
  func calculateResult() -> String? {
    switch type.name {
    case "Free Chlorine":
      return calculator.changeChlorineBy(desiredValue - currentValue)
    case "pH":
      return calculator.changePHBy(desiredValue - currentValue, startingPH: currentValue)
    case "Total Alkalinity":
      return calculator.changeAlkalinityBy(desiredValue - currentValue)
    case "Calcium Hardness":
      return calculator.changeHardnessBy(desiredValue - currentValue)
    case "Cynuric Acid":
      return calculator.changeCynuricAcidBy(desiredValue - currentValue)
    default:
      return "Oops"
    }
  }
  
  @IBAction func didPressChemicalButton(sender: UIButton) {
    addSelectionBarTo(sender, animated: true)
    switch sender {
    case chlorineButton:
      type = ReadingType.getType(Chemical.FreeChlorine)
    case pHButton:
      type = ReadingType.getType(Chemical.pH)
    case totalAlkalinityButton:
      type = ReadingType.getType(Chemical.TotalAlk)
    case calciumHardnessButton:
      type = ReadingType.getType(Chemical.Hardness)
    case cynuricAcidButton:
      type = ReadingType.getType(Chemical.Stablizer)
    default:
      return ()
    }
    updateCurrentReading()
    updateDesiredReading()
    
    UIView.transitionWithView(resultLabel,
      duration: 0.3,
      options: UIViewAnimationOptions.TransitionFlipFromBottom,
      animations: { () -> Void in
        self.resultLabel.text = self.calculateResult()
      }) { (success) -> Void in
        return ()
    }
    
  }
  
  func addSelectionBarTo(button: UIButton, animated: Bool) {
    if selectionBar == nil {
      selectionBar = UIView()
      selectionBar!.backgroundColor = UIColor.whiteColor()
      topScrollView.addSubview(selectionBar!)
      selectionBar!.layer.cornerRadius = 2
    }
    
    let barX = button.frame.origin.x
    let barY = button.frame.origin.y + button.frame.height - 6
    let barWidth = button.frame.width
    let barHeight : CGFloat = 2
    
    UIView.animateWithDuration(animated ? 0.3 : 0.0,
      delay: 0.0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 0.4,
      options: .AllowUserInteraction,
      animations: { () -> Void in
        self.selectionBar!.frame = CGRect(x: barX, y: barY, width: barWidth, height: barHeight)
        if self.currentButton != nil {
          self.currentButton.setTitleColor(UIColor.lightTextColor(), forState: UIControlState.Normal)
        }
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }) { (success) -> Void in
      self.currentButton = button
      return ()
    }
  }
  
  func addTopBarShadow() {
    topBar.layer.shadowColor = UIColor.blackColor().CGColor
    topBar.layer.shadowOffset = CGSize(width: 0, height: 3)
    topBar.layer.shadowOpacity = 0.5
    topBar.layer.shadowRadius = 3
  }
  
  func didTapSettings(sender: UITapGestureRecognizer) {
    if sender.state == .Ended {
      if let parent = self.parentViewController as? ContainerViewController {
        parent.switchViewControllerTo(parent.settingsVC, animated: true)
      }
    }
  }

}
