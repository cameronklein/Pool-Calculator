//
//  ContainerViewController.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 12/18/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
  
  @IBOutlet weak var bottomBar: UIView!
  @IBOutlet weak var buttonOne: UIView!
  @IBOutlet weak var buttonTwo: UIView!
  @IBOutlet weak var buttonThree: UIView!
  @IBOutlet weak var buttonFour: UIView!
  @IBOutlet weak var headerLabel: UILabel!
  
  @IBOutlet weak var buttonTwoConstraint: NSLayoutConstraint!
  @IBOutlet weak var buttonOneConstraint: NSLayoutConstraint!
  @IBOutlet weak var buttonThreeConstraint: NSLayoutConstraint!
  @IBOutlet weak var buttonFourConstraint: NSLayoutConstraint!
  var currentViewController : UIViewController!
  var newReadingVC : NewReadingViewController!
  var historyVC : HistoryViewController!
  var calculatorVC : CalculatorViewController!
  var settingsVC : SettingsViewController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewControllers()
    setupButtons()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if NSUserDefaults.standardUserDefaults().boolForKey(kUserSettingsCalculatorMode){
      switchToCalculatorOnlyMode(true, animated: false)
      switchViewControllerTo(calculatorVC, animated: false)
    } else {
      switchViewControllerTo(newReadingVC, animated: false)
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  func setupViewControllers(){
    let vcFrame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height /*- bottomBar.frame.height*/)
    
    newReadingVC = NewReadingViewController(nibName: "NewReadingViewController", bundle: NSBundle.mainBundle())
    newReadingVC.view.frame = vcFrame
    historyVC = HistoryViewController(nibName: "HistoryViewController", bundle: NSBundle.mainBundle())
    historyVC.view.frame = vcFrame
    calculatorVC = CalculatorViewController(nibName: "CalculatorViewController", bundle: NSBundle.mainBundle())
    calculatorVC.view.frame = vcFrame
    settingsVC = SettingsViewController(nibName: "SettingsViewController", bundle: NSBundle.mainBundle())
    settingsVC.view.frame = vcFrame
  }
  
  func setupButtons() {
    let buttons = [buttonOne, buttonTwo, buttonThree, buttonFour]
    for button in buttons {
      button.layer.cornerRadius = button.frame.height/2
      button.layer.shadowColor = UIColor.blackColor().CGColor
      button.layer.shadowOffset = CGSize(width: 0, height: 3)
      button.layer.shadowOpacity = 0.5
      button.layer.shadowRadius = 3
      let tapper = UITapGestureRecognizer()
      tapper.addTarget(self, action: "didTapButton:")
      button.addGestureRecognizer(tapper)
    }
  }

  func didTapButton(sender: UITapGestureRecognizer) {
    switch sender.view!{
    case buttonOne:
      switchViewControllerTo(newReadingVC, animated: true)
    case buttonTwo:
      switchViewControllerTo(historyVC, animated: true)
    case buttonThree:
      switchViewControllerTo(calculatorVC, animated: true)
    case buttonFour:
      switchViewControllerTo(settingsVC, animated: true)
    default:
    println("This should not happen.")
    }
  }
  
  func switchViewControllerTo(destination: UIViewController, animated: Bool) {
    if currentViewController != destination {
      let previousViewController = currentViewController
      self.addChildViewController(destination)
      destination.view.alpha = 0
      self.view.insertSubview(destination.view, belowSubview: bottomBar)
      UIView.animateWithDuration(animated ? 0.1 : 0.0,
        animations: { () -> Void in
        destination.view.alpha = 1
        }) { (success) -> Void in
          if previousViewController != nil {
            previousViewController.view.removeFromSuperview()
            previousViewController.removeFromParentViewController()
          }
      }
    }
    self.currentViewController = destination
  }
  
  func switchToCalculatorOnlyMode(wantsCalcMode: Bool, animated: Bool){
    if wantsCalcMode {
      UIView.animateWithDuration(animated ? 0.5 : 0.0,
        delay: 0.0,
        usingSpringWithDamping: 0.7,
        initialSpringVelocity: 0.4,
        options: nil,
        animations: { () -> Void in
          self.buttonTwo.transform = CGAffineTransformMakeTranslation(-200, 0)
          self.buttonThree.transform = CGAffineTransformMakeTranslation(200, 0)
      }, completion: nil)
      UIView.animateWithDuration(animated ? 0.5 : 0.0,
        delay: animated ? 0.2 : 0.0,
        usingSpringWithDamping: 0.7,
        initialSpringVelocity: 0.4,
        options: nil,
        animations: { () -> Void in
          self.buttonOne.transform = CGAffineTransformMakeTranslation(-100, 0)
          self.buttonFour.transform = CGAffineTransformMakeTranslation(100, 0)
      }, completion: nil)
      UIView.animateWithDuration(animated ? 0.7 : 0.0,
        delay: animated ? 0.4 : 0.0,
        usingSpringWithDamping: 0.7,
        initialSpringVelocity: 0.4,
        options: nil,
        animations: { () -> Void in
          self.bottomBar.transform = CGAffineTransformMakeTranslation(0, self.bottomBar.frame.height)
      },completion: nil)
      

  
    } else {
      UIView.animateWithDuration(animated ? 0.5 : 0.0,
        delay: 0.0,
        usingSpringWithDamping: 0.7,
        initialSpringVelocity: 0.4,
        options: nil,
        animations: { () -> Void in
          self.bottomBar.transform = CGAffineTransformIdentity
          
      }, completion: nil)
      UIView.animateWithDuration(animated ? 0.5 : 0.0,
            delay: animated ? 0.2 : 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.4,
            options: nil,
            animations: { () -> Void in
              self.buttonOne.transform = CGAffineTransformIdentity
              self.buttonFour.transform = CGAffineTransformIdentity
        }, completion: nil)
      
      UIView.animateWithDuration(animated ? 0.7 : 0.0,
        delay: animated ? 0.4 : 0.0,
        usingSpringWithDamping: 0.7,
        initialSpringVelocity: 0.4,
        options: nil,
        animations: { () -> Void in
          self.buttonTwo.transform = CGAffineTransformIdentity
          self.buttonThree.transform = CGAffineTransformIdentity
      }, completion: nil)
    }
    
    
  }
  
  @IBAction func didPressSubmit(sender: AnyObject) {
    newReadingVC.addReading()
  }
  
  func changeHeaderLabelTo(text: String) {
    UIView.transitionWithView(headerLabel,
      duration: 0.5,
      options: .TransitionFlipFromBottom,
      animations: { () -> Void in
      self.headerLabel.text = text
    }) { (success) -> Void in
      return ()
    }
    
  }
  
}

