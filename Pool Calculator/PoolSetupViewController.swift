//
//  PoolSetupViewController.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 12/23/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit

class PoolSetupViewController: UIViewController {

  @IBOutlet weak var gallonsLabel: UILabel!
  @IBOutlet weak var litersLabel: UILabel!
  @IBOutlet weak var volumeWrapper: UIView!
  @IBOutlet weak var volumeLabel: UILabel!
  
  var oldValue : Double!
  var currentValue : Double!
  var newValue : Double!
  var currentUnits : VolumeUnit!
  
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
    self.currentValue = NSUserDefaults.standardUserDefaults().doubleForKey(kUserSettingsPoolVolumeInGallons)
    volumeLabel.text = NSNumberFormatter.localizedStringFromNumber(currentValue, numberStyle: NSNumberFormatterStyle.DecimalStyle)
    currentUnits = VolumeUnit(rawValue: NSUserDefaults.standardUserDefaults().integerForKey(kUserSettingsVolumeUnits))
    updateVolumeDisplay()
    if currentUnits == VolumeUnit.Gallons {
      switchLabelAlphas(selected: gallonsLabel, unselected: litersLabel, animated: false)
    } else {
      switchLabelAlphas(selected: litersLabel, unselected: gallonsLabel, animated: false)
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func didPanNumber(sender: UIPanGestureRecognizer) {
    if let view = sender.view? {
      switch sender.state{
        
        case .Began:
        oldValue = currentValue
          
        case .Changed:
          
          let translation = sender.translationInView(view)
          let ratio = translation.x / view.frame.width
          let delta = 200000
          let addition = Double(ratio) * Double(delta)
          newValue = oldValue + addition
          if currentUnits == .Gallons {
            newValue = newValue - newValue % 1000
          } else {
            newValue = newValue - newValue % 250
          }
          
          if newValue < 0 {
            newValue = 0
          } else if newValue > 300000 {
            newValue = 300000
          }
          
          currentValue = newValue

          updateVolumeDisplay()

      case .Ended:
        NSUserDefaults.standardUserDefaults().setDouble(currentValue, forKey: kUserSettingsPoolVolumeInGallons)
        NSUserDefaults.standardUserDefaults().synchronize()
        default:
          return ()
      }
    }
  }
  
  func didTapGallons(sender: UITapGestureRecognizer){
    
    if currentUnits == VolumeUnit.Liters {
      currentUnits = .Gallons
      switchLabelAlphas(selected:gallonsLabel, unselected: litersLabel, animated: true)
      updateVolumeDisplay()
    }
    
  }
  
  func didTapLiters(sender: UITapGestureRecognizer){
    
    if currentUnits == .Gallons {
      currentUnits = .Liters
      switchLabelAlphas(selected:litersLabel, unselected: gallonsLabel, animated: true)
      updateVolumeDisplay()
    }
    
  }
  
  func switchLabelAlphas(#selected: UILabel, unselected: UILabel, animated: Bool) {
    
    UIView.animateWithDuration(animated ? 0.3 : 0.0,
      animations: { () -> Void in
      selected.alpha = 1
      unselected.alpha = 0.25
    })
    
  }
  
  func updateVolumeDisplay() {
    
    if currentUnits == .Liters {
      
      volumeLabel.text = NSNumberFormatter.localizedStringFromNumber(currentValue * 3.78541, numberStyle: NSNumberFormatterStyle.DecimalStyle)
      
    } else {
      
      volumeLabel.text = NSNumberFormatter.localizedStringFromNumber(currentValue, numberStyle: NSNumberFormatterStyle.DecimalStyle)
    }
    
  }

}



