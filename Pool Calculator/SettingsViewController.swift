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
  
  var unitsSwitcher: UISegmentedControl!
  var settings : Array<(String,Array<String>)>!
  var navigationStack : [UIViewController]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    var group1 = ["Pool", "Chemicals", "Desired Values"]
    var group2 = ["Display Options", "Calculator Only Mode", "Units"]
    var group3 = ["Terms of Use", "This"]
    settings = [("Facility Info",group1),("Display",group2),("About",group3)]
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CELL")
    navigationStack = [self]
    calculatorModeSwitch.on = NSUserDefaults.standardUserDefaults().boolForKey(kUserSettingsCalculatorMode)
    setupUnitsSwitcher()
    
    self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 80.0))
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    addTopBarShadow()
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func setupUnitsSwitcher() {
    unitsSwitcher = UISegmentedControl()
    unitsSwitcher.insertSegmentWithTitle("US", atIndex: 0, animated: false)
    unitsSwitcher.insertSegmentWithTitle("Metric", atIndex: 1, animated: false)
    unitsSwitcher.tintColor = UIColor.whiteColor()
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
      calculatorModeSwitch.onTintColor = UIColor(red: 0/256, green: 150/256, blue: 136/256, alpha: 1)
      calculatorModeSwitch.tintColor = topBar.backgroundColor
      
    case NSIndexPath(forRow: 2, inSection: 1):
      
      cell.addSubview(getUnitsSwitcherForCell(cell))
      
    default:
      cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    }

    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    var destination : UIViewController
    switch indexPath {
    case NSIndexPath(forRow: 0, inSection: 0):
      destination = PoolSetupViewController(nibName: "PoolSetupViewController", bundle: NSBundle.mainBundle())
    case NSIndexPath(forRow: 1, inSection: 0):
      destination = ChemicalsUsedViewController(nibName: "ChemicalsUsedViewController", bundle: NSBundle.mainBundle())
      changeHeaderLabelTo("Chemicals in Use")
    case NSIndexPath(forRow: 2, inSection: 0):
      destination = DesiredValuesViewController(nibName: "DesiredValuesViewController", bundle: NSBundle.mainBundle())
      changeHeaderLabelTo("Target Values")
    case NSIndexPath(forRow: 0, inSection: 1):
      destination = DisplayOptionsViewController(nibName: "DisplayOptionsViewController", bundle: NSBundle.mainBundle())
      changeHeaderLabelTo("Display Options")
    default:
      return ()
    }
    
    self.addChildViewController(destination)
    destination.view.frame = CGRect(x: self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
    self.view.insertSubview(destination.view, belowSubview: topBar)
    UIView.animateWithDuration(0.4,
      delay: 0.0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 0.5,
      options: UIViewAnimationOptions.AllowUserInteraction,
      animations: { () -> Void in
        destination.view.frame.origin = CGPoint(x: 0, y: 0)
        self.backButton.alpha = 1
      }) { (success) -> Void in
        return ()
    }
    navigationStack.append(destination)
  }
  
  func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    if let header = view as? UITableViewHeaderFooterView {
      header.textLabel.textColor = UIColor.whiteColor()
    }
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
          parent.switchViewControllerTo(parent.calculatorVC, animated: true)
        }
      } else{
        navigationStack.removeLast()
        changeHeaderLabelTo("Settings")
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
      parent.switchToCalculatorOnlyMode(sender.on, animated: true)
    }
    makeBackButtonVisable(sender.on)
  }
  
  func changeHeaderLabelTo(newString: String) {
    UIView.transitionWithView(headeLabel, duration: 0.4, options: UIViewAnimationOptions.TransitionFlipFromTop, animations: { () -> Void in
      self.headeLabel.text = newString
    }) { (success) -> Void in
      return ()
    }
  }
  
  func makeBackButtonVisable(visable: Bool) {
    UIView.animateWithDuration(0.8,
      delay: 0.0,
      options: UIViewAnimationOptions.AllowUserInteraction,
      animations: { () -> Void in
        if visable {
          self.backButton.alpha = 1
        } else {
          self.backButton.alpha = 0
        }
      }) { (success) -> Void in
        return ()
    }
  }
  
  func getUnitsSwitcherForCell(cell: UITableViewCell) -> UIView {
    
    let unitsView = UIView(frame: CGRect(x: cell.bounds.width/1.5, y: 0, width: cell.bounds.width/1.5, height: cell.bounds.height))
    let usLabel = UILabel()
    let metricLabel = UILabel()
    usLabel.text = "US"
    metricLabel.text = "Metric"
    usLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 16.0)
    metricLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 16.0)
    metricLabel.alpha = 0.4
    usLabel.textColor = UIColor.whiteColor()
    metricLabel.textColor = UIColor.whiteColor()
    unitsView.addSubview(usLabel)
    unitsView.addSubview(metricLabel)
    usLabel.frame = CGRect(x: 0, y: 0, width: usLabel.intrinsicContentSize().width + 32, height: unitsView.bounds.height)
    metricLabel.frame = CGRect(x: usLabel.frame.maxX, y: 0, width: unitsView.bounds.width / 2, height: unitsView.bounds.height)
    
    return unitsView
  }
  
}
