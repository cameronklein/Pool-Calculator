//
//  SettingsViewController.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 12/22/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var topBar: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var headerLabel: UILabel!
  @IBOutlet weak var backButton: UIButton!
  @IBOutlet weak var calculatorModeSwitch: UISwitch!
  
  var settings : Array<(String,Array<String>)>!
  var navigationStack : [UIViewController]!
  var volumeUnits : VolumeUnit = .Gallons
  var weightUnits : WeightUnit = .Pounds
  var litersLabel = UILabel()
  var gallonsLabel = UILabel()
  var poundsLabel = UILabel()
  var kilogramsLabel = UILabel()
  var separatorOne = UILabel()
  var separatorTwo = UILabel()
  
  //MARK: - Lifecycle Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    volumeUnits = VolumeUnit(rawValue: NSUserDefaults.standardUserDefaults().integerForKey(kUserSettingsVolumeUnits))!
    calculatorModeSwitch.on = NSUserDefaults.standardUserDefaults().boolForKey(kUserSettingsCalculatorMode)
    setupTableViewLabels()
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CELL")
    navigationStack = [self]
   
    self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 80.0))
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    addTopBarShadow()
    
  }
  
  //MARK: - <UITableViewDataSource>
  
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
    cell.textLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16.0)
    cell.textLabel?.textColor = UIColor.whiteColor()
    cell.backgroundColor = UIColor.clearColor()
    cell.selectionStyle = .None
    
    switch indexPath {
    case NSIndexPath(forRow: 1, inSection: 1):
      
      cell.accessoryView = calculatorModeSwitch
      calculatorModeSwitch.onTintColor = UIColor(red: 0/256, green: 150/256, blue: 136/256, alpha: 1)
      calculatorModeSwitch.tintColor = topBar.backgroundColor
      
    case NSIndexPath(forRow: 2, inSection: 1):
      let switcher = getVolumeUnitsSwitcherForCell(cell)
      switcher.frame.origin.x -= 100
      cell.addSubview(getVolumeUnitsSwitcherForCell(cell))
      
    case NSIndexPath(forRow: 3, inSection: 1):
      
      cell.addSubview(getWeightUnitsSwitcherForCell(cell))
      
    default:
      cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    }

    return cell
  }
  
  //MARK: - <UITableViewDelegate>
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    switch indexPath {
    case NSIndexPath(forRow: 0, inSection: 0):
      pushViewController(PoolSetupViewController(nibName: "PoolSetupViewController", bundle: NSBundle.mainBundle()))
      changeHeaderLabelTo("Pool Setup")
    case NSIndexPath(forRow: 1, inSection: 0):
      pushViewController(ChemicalsUsedViewController(nibName: "ChemicalsUsedViewController", bundle: NSBundle.mainBundle()))
      changeHeaderLabelTo("Chemicals in Use")
    case NSIndexPath(forRow: 2, inSection: 0):
      pushViewController(DesiredValuesViewController(nibName: "DesiredValuesViewController", bundle: NSBundle.mainBundle()))
      changeHeaderLabelTo("Target Values")
    case NSIndexPath(forRow: 0, inSection: 1):
      pushViewController(DisplayOptionsViewController(nibName: "DisplayOptionsViewController", bundle: NSBundle.mainBundle()))
      changeHeaderLabelTo("Display Options")
    case NSIndexPath(forRow: 0, inSection: 2):
      pushViewController(TermsOfUseViewController(nibName: "TermsOfUseViewController", bundle: NSBundle.mainBundle()))
      changeHeaderLabelTo("Terms of Use")
    default:
      return ()
    }
    
  }
  
  func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    if let header = view as? UITableViewHeaderFooterView {
      header.textLabel.textColor = UIColor.whiteColor()
    }
  }
  
  //MARK: - Helper Methods
  
  func setupTableViewLabels() {
    
    var group1 = ["Pool", "Chemicals", "Desired Values"]
    var group2 = ["Display Options", "Calculator Only Mode", "Volume Units", "Weight Units"]
    var group3 = ["Terms of Use", "This"]
    settings = [("Facility Info",group1),("Display",group2),("About",group3)]
    
  }
  
  func addTopBarShadow() {
    topBar.layer.shadowColor = UIColor.blackColor().CGColor
    topBar.layer.shadowOffset = CGSize(width: 0, height: 3)
    topBar.layer.shadowOpacity = 0.5
    topBar.layer.shadowRadius = 3
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
  
  func getVolumeUnitsSwitcherForCell(cell: UITableViewCell) -> UIView {
    
    let unitsView = UIView(frame: CGRect(x: cell.bounds.width / 2, y: 0, width: cell.bounds.width / 2, height: cell.bounds.height))
    gallonsLabel.text = "Gallons"
    litersLabel.text = "Liters"
    separatorOne.text = "|"
    
    for label in [gallonsLabel, litersLabel, separatorOne] {
      label.userInteractionEnabled = true
      label.font = UIFont(name: "AvenirNext-DemiBold", size: 16.0)
      label.textColor = UIColor.whiteColor()
      unitsView.addSubview(label)
    }
    
    separatorOne.userInteractionEnabled = false
    separatorOne.font = UIFont(name: "AvenirNext-DemiBold", size: 20.0)
    
    litersLabel.frame = CGRect(
      x: unitsView.bounds.width - litersLabel.intrinsicContentSize().width - 16,
      y: 2,
      width: litersLabel.intrinsicContentSize().width,
      height: unitsView.bounds.height
    )
    
    separatorOne.frame = CGRect(
      x: litersLabel.frame.origin.x - 16 - separatorOne.intrinsicContentSize().width,
      y: 0,
      width: separatorOne.intrinsicContentSize().width,
      height: unitsView.bounds.height
    )
    
    gallonsLabel.frame = CGRect(
      x: separatorOne.frame.origin.x - 16 - gallonsLabel.intrinsicContentSize().width,
      y: 2,
      width: gallonsLabel.intrinsicContentSize().width,
      height: unitsView.bounds.height
    )

    separatorOne.alpha = 0.7

    if volumeUnits == .Gallons {
      litersLabel.alpha = 0.3
    } else {
      gallonsLabel.alpha = 0.3
    }
    
    let litersTapper = UITapGestureRecognizer()
    litersTapper.addTarget(self, action: "didPressLiters:")
    litersLabel.addGestureRecognizer(litersTapper)
    
    let gallonsTapper = UITapGestureRecognizer()
    gallonsTapper.addTarget(self, action: "didPressGallons:")
    gallonsLabel.addGestureRecognizer(gallonsTapper)
    
    return unitsView
  }
  
  func getWeightUnitsSwitcherForCell(cell: UITableViewCell) -> UIView {
    
    let unitsView = UIView(frame: CGRect(x: cell.bounds.width / 2, y: 0, width: cell.bounds.width / 2, height: cell.bounds.height))
    poundsLabel.text = "Ounces"
    kilogramsLabel.text = "Grams"
    separatorTwo.text = "|"
    
    for label in [poundsLabel, kilogramsLabel, separatorTwo] {
      label.userInteractionEnabled = true
      label.font = UIFont(name: "AvenirNext-DemiBold", size: 16.0)
      label.textColor = UIColor.whiteColor()
      unitsView.addSubview(label)
    }
    
    separatorTwo.userInteractionEnabled = false
    separatorTwo.font = UIFont(name: "AvenirNext-DemiBold", size: 20.0)
    
    kilogramsLabel.frame = CGRect(
      x: litersLabel.center.x - kilogramsLabel.intrinsicContentSize().width / 2,
      y: 2,
      width: kilogramsLabel.intrinsicContentSize().width,
      height: unitsView.bounds.height
    )
    
    separatorTwo.frame = CGRect(
      x: litersLabel.frame.origin.x - 16 - separatorTwo.intrinsicContentSize().width,
      y: 0,
      width: separatorOne.intrinsicContentSize().width,
      height: unitsView.bounds.height
    )
    
    poundsLabel.frame = CGRect(
      x: gallonsLabel.center.x - poundsLabel.intrinsicContentSize().width / 2,
      y: 2,
      width: poundsLabel.intrinsicContentSize().width,
      height: unitsView.bounds.height
    )
    
    separatorTwo.alpha = 0.7
    
    if weightUnits == .Pounds {
      kilogramsLabel.alpha = 0.3
    } else {
      poundsLabel.alpha = 0.3
    }
    
    let poundsTapper = UITapGestureRecognizer()
    poundsTapper.addTarget(self, action: "didPressPounds:")
    poundsLabel.addGestureRecognizer(poundsTapper)
    
    let kilogramsTapper = UITapGestureRecognizer()
    kilogramsTapper.addTarget(self, action: "didPressKilograms:")
    kilogramsLabel.addGestureRecognizer(kilogramsTapper)
    
    return unitsView
  }
  
  func didPressLiters(sender: UITapGestureRecognizer) {
    if volumeUnits == .Gallons {
      volumeUnits = .Liters
      NSUserDefaults.standardUserDefaults().setInteger(1, forKey: kUserSettingsVolumeUnits)
      UIView.animateWithDuration(0.3, animations: { () -> Void in
        self.litersLabel.alpha = 1
        self.gallonsLabel.alpha = 0.3
      })
    }
  }
  
  func didPressGallons(sender: UITapGestureRecognizer) {
    if volumeUnits == .Liters {
      volumeUnits = .Gallons
      NSUserDefaults.standardUserDefaults().setInteger(0, forKey: kUserSettingsVolumeUnits)
      UIView.animateWithDuration(0.3, animations: { () -> Void in
        self.gallonsLabel.alpha = 1
        self.litersLabel.alpha = 0.3
      })
    }
  }
  
  func didPressKilograms(sender: UITapGestureRecognizer) {
    if weightUnits == .Pounds {
      weightUnits = .Kilograms
      NSUserDefaults.standardUserDefaults().setInteger(1, forKey: kUserSettingsWeightUnits)
      UIView.animateWithDuration(0.3, animations: { () -> Void in
        self.kilogramsLabel.alpha = 1
        self.poundsLabel.alpha = 0.3
      })
    }
  }
  
  func didPressPounds(sender: UITapGestureRecognizer) {
    if weightUnits == .Kilograms {
      weightUnits = .Pounds
      NSUserDefaults.standardUserDefaults().setInteger(0, forKey: kUserSettingsWeightUnits)
      UIView.animateWithDuration(0.3, animations: { () -> Void in
        self.poundsLabel.alpha = 1
        self.kilogramsLabel.alpha = 0.3
      })
    }
  }
  
  func pushViewController(viewController: UIViewController) {
    
    self.addChildViewController(viewController)
    viewController.view.frame = CGRect(x: self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
    self.view.insertSubview(viewController.view, belowSubview: topBar)
    
    UIView.animateWithDuration(0.4,
      delay: 0.0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 0.5,
      options: UIViewAnimationOptions.AllowUserInteraction,
      animations: { () -> Void in
        viewController.view.frame.origin = CGPoint(x: 0, y: 0)
        self.backButton.alpha = 1
      }) { (success) -> Void in
        return ()
    }
    navigationStack.append(viewController)
    
  }
  
  //MARK: - IBActions
  
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
    UIView.transitionWithView(headerLabel, duration: 0.4, options: UIViewAnimationOptions.TransitionFlipFromTop, animations: { () -> Void in
      self.headerLabel.text = newString
      }) { (success) -> Void in
        return ()
    }
  }
  
}
