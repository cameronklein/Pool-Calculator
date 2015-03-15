//
//  ChemicalsUsedViewController
//  Pool Calculator
//
//  Created by Cameron Klein on 12/23/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit

struct ChemicalGroup {
  var title : String
  var chemicals : [String]!
  
  init(title: String) {
    self.title = title
  }
}

class ChemicalsUsedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
  
  var settings : [ChemicalGroup]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSettings()
    
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CELL")

    self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 80.0))
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func setupSettings() {
    
    var group1 = ChemicalGroup(title: "Raise Chlorine")
    group1.chemicals = ["Sodium Hypochlorite 13%", "Calcium Hypochlorite 67%", "Dichlor 56%", "Dichlor 62%", "Trichlor"]
    
    var group2 = ChemicalGroup(title: "Lower Chlorine")
    group2.chemicals = ["Sodium Thiosulfate", "Sodium Sulfite"]
    
    var group3 = ChemicalGroup(title: "Raise pH")
    group3.chemicals = [ "Soda Ash"]
    
    var group4 = ChemicalGroup(title: "Lower pH")
    group4.chemicals = ["Muriatic Acic", "Dry Acid"]
    
    var group5 = ChemicalGroup(title: "Raise Alkalinity")
    group5.chemicals = ["Sodium Bicarbonate", "Sodium Bisulfate"]
    
    var group6 = ChemicalGroup(title: "Raise Calcium Hardness")
    group6.chemicals = ["Calcium Chloride 100%", "Calcium Chloride 77%"]
    
    var group7 = ChemicalGroup(title: "Other")
    group7.chemicals = ["Cynuric Acid","Sodium Thiosulfate"]
    
    settings = [group1, group2, group3, group4, group5, group6, group7]
    
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return settings[section].chemicals.count
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return settings.count
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return settings[section].title
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath: indexPath) as UITableViewCell
    let title = settings[indexPath.section].chemicals[indexPath.row]
    cell.textLabel?.text = title
    cell.textLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 16.0)
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
