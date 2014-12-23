//
//  ChemicalsUsedViewController
//  Pool Calculator
//
//  Created by Cameron Klein on 12/23/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit

class ChemicalsUsedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  
  var settings : Array<(String,Array<String>)>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    var group1 = ("Chlorine Products", ["Chlorine Gas", "Sodium Hypochlorite", "Desired Values"])
    var group2 = ("pH / Total Alkalinity", ["Sodium Bicarbonate (Baking Soda)", "Soda Ash", "Muriatic Acid", "Sodium Bisulfate"])
    var group3 = ("Calcium Hardness", ["Calcium Chloride 100%", "Calcium Chloride 77%"])
    var group4 = ("Other",["Cynuric Acid","Sodium Thiosulfate"])
    settings = [group1, group2, group3, group4]
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CELL")
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
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
    
    let chemSwitch = UISwitch()
    chemSwitch.addTarget(self, action: "didFlipSwitch", forControlEvents: .ValueChanged)
    cell.accessoryView = chemSwitch

    return cell
  }
  
  @IBAction func didFlipSwitch(sender: UISwitch) {
    NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: kUserSettingsCalculatorMode)
    NSUserDefaults.standardUserDefaults().synchronize()
    if let parent = self.parentViewController as? ContainerViewController {
      parent.switchToCalculatorOnlyMode(sender.on, animated: true)
    }

    
  }
  
}
