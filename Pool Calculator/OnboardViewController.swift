//
//  OnboardViewController.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 12/24/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit

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
  
  @IBOutlet weak var helpButton: UIButton!
  @IBOutlet weak var confirmButton: UIButton!
  @IBOutlet weak var doneButton: UIButton!
  
  @IBOutlet weak var swipeViewConstrainst: NSLayoutConstraint!
  
  var animationDuration = 0.8
  var animationDelay = 1.5
  var startingValue : Double!
  var currentValue : Double = 90000
  var newValue : Double!
  var notYetSwiped = true
  var currentUnits: VolumeUnit = .Gallons

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
    
    let viewsToSetup = [
      paragraph1,
      paragraph2,
      paragraph4,
      paragraph5,
      paragraph6,
      volumeWrapper,
      helpButton,
      confirmButton,
      doneButton
    ]
    
    for view in viewsToSetup {
      view.alpha = 0
    }

  }
  
  override func viewDidAppear(animated: Bool) {
    
    super.viewDidAppear(animated)
    
    revealTopLabels()
    
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
        newValue = max(newValue!, 0.0)
        newValue = min(newValue!, 300000)
        
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
    
    UIView.animateWithDuration(animationDuration,
      delay: 1.0 + animationDelay * 1.5,
      options: UIViewAnimationOptions.CurveEaseInOut,
      animations: { () -> Void in
        self.helpButton.alpha = 1
        self.confirmButton.alpha = 1
      }) { (success) -> Void in
        return ()
    }
    
    UIView.animateWithDuration(self.animationDuration,
      delay: 0.0,
      options: UIViewAnimationOptions.Autoreverse | UIViewAnimationOptions.Repeat | UIViewAnimationOptions.AllowUserInteraction,
      animations: { () -> Void in
        self.helpButton.transform = CGAffineTransformMakeScale(1.1, 1.1)
        self.confirmButton.transform = CGAffineTransformMakeScale(1.1, 1.1)
      }) { (success) -> Void in
        return ()
    }
  }
  
  @IBAction func didPressConfirm(sender: AnyObject) {
    println("Did press confirm!")
    
    swipeViewConstrainst.priority = 500
    
    UIView.animateWithDuration(0.5,
      delay: 0.0,
      options: UIViewAnimationOptions.AllowUserInteraction,
      animations: { () -> Void in
        self.paragraph1.alpha = 0
        self.paragraph2.alpha = 0
        self.paragraph4.alpha = 0
        self.paragraph5.alpha = 0
        self.paragraph6.alpha = 0
        self.helpButton.alpha = 0
        self.confirmButton.alpha = 0
      }) { (success) -> Void in
        self.paragraph5.text = "One more step."
        self.paragraph6.text = "What chemicals do you use?"
    }
    
    UIView.animateWithDuration(1.0,
      delay: 0.0,
      options: UIViewAnimationOptions.AllowUserInteraction,
      animations: { () -> Void in
      self.view .layoutSubviews()
    }) { (success) -> Void in
      
      UIView.animateWithDuration(self.animationDuration,
        delay: 1.0,
        options: UIViewAnimationOptions.CurveEaseInOut,
        animations: { () -> Void in
          self.paragraph5.alpha = 1
        }) { (success) -> Void in
          return ()
      }
      
      UIView.animateWithDuration(self.animationDuration,
        delay: 1.0 + self.animationDelay,
        options: UIViewAnimationOptions.CurveEaseInOut,
        animations: { () -> Void in
          self.paragraph6.alpha = 1
        }) { (success) -> Void in
          self.addChemicalsUsedViewController()
      }
    }
  }
  
  @IBAction func didPressHelp(sender: AnyObject) {
    println("Did press help!")
  }
  
  func addChemicalsUsedViewController() {
    let chemVC = ChemicalsUsedViewController(nibName: "ChemicalsUsedViewController", bundle: NSBundle.mainBundle())
    self.addChildViewController(chemVC)
    let origin = CGPoint(x: 0, y: self.helpButton.frame.origin.y)
    chemVC.view.frame = CGRect(origin: origin, size: CGSize(width: self.view.frame.width, height: self.view.frame.height - origin.y - 60))
    chemVC.view.alpha = 0
    chemVC.tableViewTopConstraint.constant = 0
    chemVC.view.backgroundColor = UIColor.clearColor()
    self.view.addSubview(chemVC.view)
    
    UIView.animateWithDuration(self.animationDuration,
      delay: animationDelay,
      options: UIViewAnimationOptions.CurveEaseInOut,
      animations: { () -> Void in
        chemVC.view.alpha = 1
        self.doneButton.alpha = 1
      }) { (success) -> Void in
        return ()
    }
    
    
  }
  
  @IBAction func didPressDone(sender: AnyObject) {
    let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    let containerVC = storyboard.instantiateInitialViewController() as ContainerViewController
    self.presentViewController(containerVC, animated: true) { () -> Void in
      let appDel = UIApplication.sharedApplication().delegate as AppDelegate
      appDel.window?.rootViewController = containerVC
    }

  }
  
}
