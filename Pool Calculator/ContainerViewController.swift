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
  
  var currentViewController : UIViewController!
  var newReadingVC : NewReadingViewController!
  var historyVC : HistoryViewController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewControllers()
    switchToNewReadingView()

  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    setupButtons()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  func setupViewControllers(){
    newReadingVC = NewReadingViewController(nibName: "NewReadingViewController", bundle: NSBundle.mainBundle())
    newReadingVC.view.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height - bottomBar.frame.height)
    historyVC = HistoryViewController(nibName: "HistoryViewController", bundle: NSBundle.mainBundle())
    newReadingVC.view.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height - bottomBar.frame.height)
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
      switchToNewReadingView()
    case buttonTwo:
      switchToHistoryView()
    case buttonThree:
      switchToCalculatorView()
    case buttonFour:
      switchToSettingsView()
    default:
    println("This should not happen.")
    }
  }

  func switchToNewReadingView() {
    if currentViewController != nil {
      currentViewController.removeFromParentViewController()
    }
    self.addChildViewController(newReadingVC)
    self.view.insertSubview(newReadingVC.view, belowSubview: bottomBar)
    currentViewController = newReadingVC
  }
  
  func switchToHistoryView() {
    currentViewController.removeFromParentViewController()
    self.addChildViewController(historyVC)
    self.view.insertSubview(historyVC.view, belowSubview: bottomBar)
    currentViewController = historyVC
  }
  
  func switchToCalculatorView() {
    
  }
  
  func switchToSettingsView() {
    
  }
  @IBAction func didPressSubmit(sender: AnyObject) {

  
}

