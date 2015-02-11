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
  
  @IBOutlet weak var buttonOne: TabBarButton!
  @IBOutlet weak var buttonTwo: TabBarButton!
  @IBOutlet weak var buttonThree: TabBarButton!
  @IBOutlet weak var buttonFour: TabBarButton!
  
  @IBOutlet var selectorOne: SelectorView!
  @IBOutlet var selectorTwo: SelectorView!
  @IBOutlet var selectorThree: SelectorView!
  @IBOutlet var selectorFour: SelectorView!
  
  @IBOutlet weak var buttonLabelOne: UILabel!
  @IBOutlet weak var buttonLabelTwo: UILabel!
  @IBOutlet weak var buttonLabelThree: UILabel!
  @IBOutlet weak var buttonLabelFour: UILabel!
  
  var currentViewController : UIViewController!
  var newReadingVC : NewReadingViewController!
  var historyVC : HistoryViewController!
  var calculatorVC : CalculatorViewController!
  var settingsVC : SettingsViewController!
  
  let colorOne = UIColor(red: 0, green: 121/256, blue: 107/256, alpha: 1)
  let colorTwo = UIColor(red: 0, green: 151/256, blue: 167/256, alpha: 1)
  let colorThree = UIColor(red: 123/256, green: 31/256, blue: 162/256, alpha: 1)
  let colorFour = UIColor(red: 56/256, green: 142/256, blue: 60/256, alpha: 1)
  
  var animationDuration = 0.3
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewControllers()
    setupButtons()
    bottomBar.clipsToBounds = true
    setButtonToActive(selectorOne, animated: false)
    
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
    selectorOne.color = newReadingVC.topBar.backgroundColor
    historyVC = HistoryViewController(nibName: "HistoryViewController", bundle: NSBundle.mainBundle())
    historyVC.view.frame = vcFrame
    selectorTwo.color = historyVC.topBar.backgroundColor
    calculatorVC = CalculatorViewController(nibName: "CalculatorViewController", bundle: NSBundle.mainBundle())
    calculatorVC.view.frame = vcFrame
    selectorThree.color = calculatorVC.topBar.backgroundColor
    settingsVC = SettingsViewController(nibName: "SettingsViewController", bundle: NSBundle.mainBundle())
    settingsVC.view.frame = vcFrame
    selectorFour.color = settingsVC.topBar.backgroundColor
  }
  
  func setupButtons() {
    let buttons : [TabBarButton] = [buttonOne, buttonTwo, buttonThree, buttonFour]
    for button in buttons {
      button.color = button.backgroundColor!
      button.backgroundColor = UIColor.clearColor()
      button.clipsToBounds = false
      button.layer.masksToBounds = false
      button.layer.cornerRadius = button.frame.height/2
      button.layer.shadowColor = UIColor.blackColor().CGColor
      button.layer.shadowOffset = CGSize(width: 0, height: 3)
      button.layer.shadowOpacity = 0.5
      button.layer.shadowRadius = 3
      
      let tapper = UITapGestureRecognizer()
      tapper.addTarget(self, action: "didTapButton:")
      button.addGestureRecognizer(tapper)
      
      //button.setNeedsDisplay()
    }
  }

  func didTapButton(sender: UITapGestureRecognizer) {
    switch sender.view!{
    case buttonOne:
      switchViewControllerTo(newReadingVC, animated: true)
      setButtonToActive(selectorOne, animated: true)
      setButtonToInactive(selectorTwo)
      setButtonToInactive(selectorThree)
      setButtonToInactive(selectorFour)
    case buttonTwo:
      switchViewControllerTo(historyVC, animated: true)
      setButtonToInactive(selectorOne)
      setButtonToActive(selectorTwo, animated: true)
      setButtonToInactive(selectorThree)
      setButtonToInactive(selectorFour)
    case buttonThree:
      switchViewControllerTo(calculatorVC, animated: true)
      setButtonToInactive(selectorOne)
      setButtonToInactive(selectorTwo)
      setButtonToActive(selectorThree, animated: true)
      setButtonToInactive(selectorFour)
    case buttonFour:
      switchViewControllerTo(settingsVC, animated: true)
      setButtonToInactive(selectorOne)
      setButtonToInactive(selectorTwo)
      setButtonToInactive(selectorThree)
      setButtonToActive(selectorFour, animated: true)
    default:
    println("This should not happen.")
    }
  }
  
  func setButtonToActive(selector: SelectorView, animated: Bool) {
    var label : UILabel!
    if selector == selectorOne {
      label = buttonLabelOne
    }
    if selector == selectorTwo {
      label = buttonLabelTwo
    }
    if selector == selectorThree {
      label = buttonLabelThree
    }
    if selector == selectorFour {
      label = buttonLabelFour
    }
    
    label.layer.shadowOpacity = 0.5
    let animation = CABasicAnimation(keyPath: "shadowOpacity")
    animation.fromValue = 0.0
    animation.toValue = 0.7
    animation.duration = animationDuration
    label.layer.addAnimation(animation, forKey: "shadowOpacity")
    
    label.layer.shadowOffset = CGSize(width: 0, height: 3)
    let animation2 = CABasicAnimation(keyPath: "shadowOffset.height")
    animation2.fromValue = 0.0
    animation2.toValue = 3.0
    animation2.duration = animationDuration
    label.layer.addAnimation(animation2, forKey: "shadowOffset.height")
    
    let colorView = UIView()
    colorView.backgroundColor = selector.color
    
    bottomBar.addSubview(colorView)
    bottomBar.sendSubviewToBack(colorView)
    colorView.frame = CGRect(origin: bottomBar.convertPoint(selector.center, fromView: self.view), size: CGSize(width: 1, height: 1))
    
    UIView.animateWithDuration(animationDuration, animations: { () -> Void in
      selector.transform = CGAffineTransformMakeTranslation(0, -20)
      let labelTransform = CGAffineTransformMakeTranslation(0, -5)
      label.transform = CGAffineTransformScale(labelTransform, 1.3, 1.3)
      }, completion: { (success) -> Void in
        return ()
    })
    
    UIView.animateWithDuration(animationDuration * 2, animations: { () -> Void in
      colorView.transform = CGAffineTransformMakeScale(1000, 1000)
      }, completion: { (success) -> Void in
        self.bottomBar.backgroundColor = selector.color
        colorView.removeFromSuperview()
        return ()
    })
  }
  
  func setButtonToInactive(selector: SelectorView) {
    var label : UILabel!
    
    if selector == selectorOne {
      label = buttonLabelOne
    }
    if selector == selectorTwo {
      label = buttonLabelTwo
    }
    if selector == selectorThree {
      label = buttonLabelThree
    }
    if selector == selectorFour {
      label = buttonLabelFour
    }
    
    label.layer.shadowOpacity = 0
    let animation = CABasicAnimation(keyPath: "shadowOpacity")
    animation.fromValue = 0.7
    animation.toValue = 0.0
    animation.duration = animationDuration
    label.layer.addAnimation(animation, forKey: "shadowOpacity")
    
    label.layer.shadowOffset = CGSizeZero
    let animation2 = CABasicAnimation(keyPath: "shadowOffset.height")
    animation2.fromValue = 3.0
    animation2.toValue = 0.0
    animation2.duration = animationDuration
    label.layer.addAnimation(animation2, forKey: "shadowOffset.height")

    
    UIView.animateWithDuration(animationDuration, animations: { () -> Void in
      selector.transform = CGAffineTransformIdentity
      label.transform = CGAffineTransformIdentity
      }, completion: { (success) -> Void in
        return ()
    })
    
  }
  
  func switchViewControllerTo(destination: UIViewController, animated: Bool) {
    if currentViewController != destination {
      let previousViewController = currentViewController
      self.addChildViewController(destination)
      destination.view.alpha = 0
      destination.view.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
      self.view.insertSubview(destination.view, belowSubview: selectorOne)
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
          self.selectorTwo.transform = CGAffineTransformMakeTranslation(-200, 0)
          self.buttonLabelTwo.transform = CGAffineTransformMakeTranslation(-200, 0)
          self.selectorThree.transform = CGAffineTransformMakeTranslation(200, 0)
          self.buttonLabelThree.transform = CGAffineTransformMakeTranslation(200, 0)
      }, completion: nil)
      UIView.animateWithDuration(animated ? 0.5 : 0.0,
        delay: animated ? 0.2 : 0.0,
        usingSpringWithDamping: 0.7,
        initialSpringVelocity: 0.4,
        options: nil,
        animations: { () -> Void in
          self.selectorOne.transform = CGAffineTransformMakeTranslation(-100, 0)
          self.buttonLabelOne.transform = CGAffineTransformMakeTranslation(-100, 0)
          self.selectorFour.transform = CGAffineTransformMakeTranslation(100, 0)
          self.buttonLabelFour.transform = CGAffineTransformMakeTranslation(100, 0)
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
              self.selectorOne.transform = CGAffineTransformIdentity
              self.buttonLabelOne.transform = CGAffineTransformIdentity
              self.selectorFour.transform = CGAffineTransformIdentity
              self.buttonLabelFour.transform = CGAffineTransformIdentity
        }, completion: nil)
      
      UIView.animateWithDuration(animated ? 0.7 : 0.0,
        delay: animated ? 0.4 : 0.0,
        usingSpringWithDamping: 0.7,
        initialSpringVelocity: 0.4,
        options: nil,
        animations: { () -> Void in
          self.selectorTwo.transform = CGAffineTransformIdentity
          self.buttonLabelTwo.transform = CGAffineTransformIdentity
          self.selectorThree.transform = CGAffineTransformIdentity
          self.buttonLabelThree.transform = CGAffineTransformIdentity
        }) { (success) -> Void in
          self.setButtonToActive(self.selectorFour, animated: true)
      }

    }
    
  }
  
}

