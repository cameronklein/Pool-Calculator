//
//  PoolSetupViewController.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 12/23/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit

let kUserSettingsPoolVolumeInGallons = "Pool Volume"

class PoolSetupViewController: UIViewController {

  @IBOutlet weak var volumeWrapper: UIView!
  @IBOutlet weak var volumeLabel: UILabel!
  var oldValue : Double!
  var currentValue : Double!
  var newValue : Double!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let panner = UIPanGestureRecognizer()
    panner.addTarget(self, action: "didPanNumber:")
    volumeWrapper.addGestureRecognizer(panner)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.currentValue = NSUserDefaults.standardUserDefaults().doubleForKey(kUserSettingsPoolVolumeInGallons)
    volumeLabel.text = NSNumberFormatter.localizedStringFromNumber(currentValue, numberStyle: NSNumberFormatterStyle.DecimalStyle)
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
          
          newValue = newValue - newValue % 1000
          
          if newValue < 0 {
            newValue = 0
          } else if newValue > 300000 {
            newValue = 300000
          }
          
          currentValue = newValue

          volumeLabel.text = NSNumberFormatter.localizedStringFromNumber(currentValue, numberStyle: NSNumberFormatterStyle.DecimalStyle)

      case .Ended:
        NSUserDefaults.standardUserDefaults().setDouble(currentValue, forKey: kUserSettingsPoolVolumeInGallons)
        default:
          return ()
      }
    }
  }

}



