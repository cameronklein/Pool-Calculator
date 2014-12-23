//
//  DisplayOptionsViewController.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 12/23/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit

class DisplayOptionsViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var settings : Array<(String,Array<String>)>!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    var group1 = ("Available Readings", ["Free Chlorine", "Combined Chlorine", "Total Chlorine", "pH", "Total Alkalinity", "Calcium Hardness", "Cynuric Acid"])
    var group2 = ("Readings Displayed in Portrait Mode", ["Free Chlorine", "Combined Chlorine", "Total Chlorine", "pH", "Total Alkalinity", "Calcium Hardness", "Cynuric Acid"])
    settings = [group1, group2]
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CELL")
    
    self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 80.0))
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
    let title = settings[indexPath.section].1[indexPath.row]
    cell.textLabel?.text = title
    cell.textLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 18.0)
    cell.textLabel?.textColor = UIColor.whiteColor()
    cell.backgroundColor = UIColor.clearColor()
    cell.selectionStyle = .None
    
    let chemSwitch = UISwitch()
    chemSwitch.addTarget(self, action: "didFlipSwitch:", forControlEvents: .ValueChanged)
    cell.accessoryView = chemSwitch
    chemSwitch.on = NSUserDefaults.standardUserDefaults().boolForKey(title)
    
    return cell
  }
  
  func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    if let header = view as? UITableViewHeaderFooterView {
      header.textLabel.textColor = UIColor.whiteColor()
    }
  }
  
  @IBAction func didFlipSwitch(sender: UISwitch) {
    if let cell = sender.superview as? UITableViewCell {
      if let label = cell.textLabel {
        if let chemicalName = label.text {
          NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: chemicalName)
          NSUserDefaults.standardUserDefaults().synchronize()
        }
      }
    }
  }
  
}
