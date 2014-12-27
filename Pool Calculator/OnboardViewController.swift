//
//  OnboardViewController.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 12/24/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit

enum unit : Int {
  case Gallons, Liters
}

class OnboardViewController: UIViewController {
  
  @IBOutlet weak var paragraph1: UILabel!
  @IBOutlet weak var paragraph2: UILabel!
  @IBOutlet weak var paragraph3: UILabel!
  @IBOutlet weak var paragraph4: UILabel!
  @IBOutlet weak var paragraph5: UILabel!
  @IBOutlet weak var paragraph6: UILabel!
  @IBOutlet weak var volumeWrapper: UIView!
  @IBOutlet weak var volumeLabel: UILabel!
  @IBOutlet weak var gallonsLabel: UILabel!
  @IBOutlet weak var litersLabel: UILabel!
  
  var animationDuration = 1.0
  var animationDelay = 1.5
  var startingValue : Double!
  var currentValue : Double = 90000
  var newValue : Double!
  var notYetSwiped = true
  var currentUnits: unit = .Gallons

  override func viewDidLoad() {
    super.viewDidLoad()

    let panner = UIPanGestureRecognizer()
    panner.addTarget(self, action: "didPanNumber:")
    volumeWrapper.addGestureRecognizer(panner)
    
    let gallonTapper = UITapGestureRecognizer()
    gallonTapper.addTarget(self, action: "didTapGallons:")
    gallonsLabel.addGestureRecognizer(gallonTapper)
    
    let literTapper = UITapGestureRecognizer()
    literTapper.addTarget(self, action: "didTapLiters:")
    litersLabel.addGestureRecognizer(literTapper)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    paragraph1.alpha = 0
    paragraph2.alpha = 0
    paragraph4.alpha = 0
    paragraph5.alpha = 0
    paragraph6.alpha = 0
    volumeWrapper.alpha = 0

  }
  
  override func viewDidAppear(animated: Bool) {
    
    super.viewDidAppear(animated)
    
    revealTopLabels()
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }
    
  func didPanNumber(sender: UIPanGestureRecognizer) {
    
    if let view = sender.view? {
      
      switch sender.state{
        
      case .Began:
        
        startingValue = currentValue
        
      case .Changed:
        
        let translation = sender.translationInView(view)
        let ratio = translation.x / view.frame.width
        let delta = 200000
        let addition = Double(ratio) * Double(delta)
        newValue = startingValue + addition
        
        newValue = newValue - newValue % 1000
        
        if newValue < 0 {
          newValue = 0
        } else if newValue > 300000 {
          newValue = 300000
        }
        
        currentValue = newValue
        
        updateVolumeDisplay()
        
        if notYetSwiped {
          notYetSwiped = false
          revealBottomLabels()
        }
        
      case .Ended:
        NSUserDefaults.standardUserDefaults().setDouble(currentValue, forKey: kUserSettingsPoolVolumeInGallons)
        NSUserDefaults.standardUserDefaults().synchronize()

      default:
        return ()
      }
    }
  }
  
  func updateVolumeDisplay() {
    
    if currentUnits == .Liters {
      
      volumeLabel.text = NSNumberFormatter.localizedStringFromNumber(currentValue*4, numberStyle: NSNumberFormatterStyle.DecimalStyle)
      
    } else {
      
      volumeLabel.text = NSNumberFormatter.localizedStringFromNumber(currentValue, numberStyle: NSNumberFormatterStyle.DecimalStyle)
    }

  }
  
  func didTapGallons(sender: UITapGestureRecognizer){
    if currentUnits == .Liters {
      currentUnits = .Gallons
      switchLabelAlphas(selected:gallonsLabel, unselected: litersLabel)
      updateVolumeDisplay()
    }
    
  }
  
  func didTapLiters(sender: UITapGestureRecognizer){
    if currentUnits == .Gallons {
      currentUnits = .Liters
      switchLabelAlphas(selected:litersLabel, unselected: gallonsLabel)
      updateVolumeDisplay()
    }
    
  }
  
  func switchLabelAlphas(#selected: UILabel, unselected: UILabel) {
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      selected.alpha = 1
      unselected.alpha = 0.25
    })
  }
  
  func revealTopLabels() {
    
    UIView.animateWithDuration(animationDuration,
      delay: animationDelay * 0,
      options: UIViewAnimationOptions.CurveEaseInOut,
      animations: { () -> Void in
        self.paragraph1.alpha = 1
      }) { (success) -> Void in
        return ()
    }
    UIView.animateWithDuration(animationDuration,
      delay: animationDelay * 1,
      options: UIViewAnimationOptions.CurveEaseInOut,
      animations: { () -> Void in
        self.paragraph2.alpha = 1
      }) { (success) -> Void in
        return ()
    }
    UIView.animateWithDuration(animationDuration,
      delay: animationDelay * 2,
      options: UIViewAnimationOptions.CurveEaseInOut,
      animations: { () -> Void in
        self.paragraph4.alpha = 1
      }) { (success) -> Void in
        return ()
    }
    UIView.animateWithDuration(animationDuration,
      delay: animationDelay * 2,
      options: UIViewAnimationOptions.CurveEaseInOut,
      animations: { () -> Void in
        self.volumeWrapper.alpha = 1
      }) { (success) -> Void in
        return ()
    }
    
  }
  
  func revealBottomLabels() {
    
    UIView.animateWithDuration(animationDuration,
      delay: 1.0,
      options: UIViewAnimationOptions.CurveEaseInOut,
      animations: { () -> Void in
        self.paragraph5.alpha = 1
      }) { (success) -> Void in
        return ()
    }
    UIView.animateWithDuration(animationDuration,
      delay: 1.0 + animationDelay,
      options: UIViewAnimationOptions.CurveEaseInOut,
      animations: { () -> Void in
        self.paragraph6.alpha = 1
      }) { (success) -> Void in
        return ()
    }
  }
  
}
