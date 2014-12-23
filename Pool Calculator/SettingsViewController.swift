//
//  SettingsViewController.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 12/22/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit


  let kUserSettingsCalculatorMode = "Calculator Mode"


class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var topBar: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var headeLabel: UILabel!
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var calculatorModeSwitch: UISwitch!
  
  var settings : Array<(String,Array<String>)>!
  var navigationStack : [UIViewController]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    var group1 = ["Pool", "Chemicals", "Desired Values"]
    var group2 = ["Display Options", "Calculator Only Mode"]
    var group3 = ["Terms of Use", "This"]
    settings = [("Pool Info",group1),("Display",group2),("About",group3)]
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CELL")
    navigationStack = [self]

    calculatorModeSwitch.on = NSUserDefaults.standardUserDefaults().boolForKey(kUserSettingsCalculatorMode)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    addTopBarShadow()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return settings[section].1.count
  }

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return settings.count
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return settings[section].0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath: indexPath) as UITableViewCell
    cell.textLabel?.text = settings[indexPath.section].1[indexPath.row]
    cell.textLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 18.0)
    cell.textLabel?.textColor = UIColor.whiteColor()
    cell.backgroundColor = UIColor.clearColor()
    cell.selectionStyle = .None
    
    switch indexPath {
    case NSIndexPath(forRow: 1, inSection: 1):
      cell.accessoryView = calculatorModeSwitch
    default:
      cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    }

    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let calculatorVC = CalculatorViewController(nibName: "CalculatorViewController", bundle: NSBundle.mainBundle())
    self.addChildViewController(calculatorVC)
    calculatorVC.view.frame = CGRect(x: self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
    self.view.insertSubview(calculatorVC.view, belowSubview: topBar)
    UIView.animateWithDuration(0.4,
      delay: 0.0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 0.4,
      options: UIViewAnimationOptions.AllowUserInteraction,
      animations: { () -> Void in
        calculatorVC.view.frame.origin = CGPoint(x: 0, y: 0)
        self.backButton.alpha = 1
    }) { (success) -> Void in
      return ()
    }

    navigationStack.append(calculatorVC)
  }
  
  func addTopBarShadow() {
    topBar.layer.shadowColor = UIColor.blackColor().CGColor
    topBar.layer.shadowOffset = CGSize(width: 0, height: 3)
    topBar.layer.shadowOpacity = 0.5
    topBar.layer.shadowRadius = 3
  }

  @IBAction func didPressBackButton(sender: AnyObject) {
    let calculatorModeOn = NSUserDefaults.standardUserDefaults().boolForKey(kUserSettingsCalculatorMode)
    if let topVC = navigationStack.last {
      if topVC == self{
        if let parent = self.parentViewController as? ContainerViewController {
          parent.switchViewControllerTo(parent.calculatorVC)
        }
      } else{
        navigationStack.removeLast()
        UIView.animateWithDuration(0.4,
          delay: 0.0,
          usingSpringWithDamping: 0.7,
          initialSpringVelocity: 0.4,
          options: UIViewAnimationOptions.AllowUserInteraction,
          animations: { () -> Void in
            topVC.view.frame.origin = CGPoint(x: self.view.bounds.width, y: 0)
            if self.navigationStack.last == self && !calculatorModeOn{
              self.backButton.alpha = 0
            }
          }) { (success) -> Void in
            return ()
        }
      }
    }
  }
  
  @IBAction func didSwitchCalcModeSwitch(sender: UISwitch) {
    NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: kUserSettingsCalculatorMode)
    NSUserDefaults.standardUserDefaults().synchronize()
    if let parent = self.parentViewController as? ContainerViewController {
      parent.switchToCalculatorOnlyMode(sender.on)
    }
    UIView.animateWithDuration(0.8,
      delay: 0.0,
      options: UIViewAnimationOptions.AllowUserInteraction,
      animations: { () -> Void in
        if sender.on {
          self.backButton.alpha = 1
        } else {
          self.backButton.alpha = 0
        }
      }) { (success) -> Void in
        return ()
    }

  }
  
}
