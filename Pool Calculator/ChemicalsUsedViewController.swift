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
    
    var group2 = ChemicalGroup(title: "Lower pH")
    group2.chemicals = ["Muriatic Acic", "Dry Acid"]
    
    var group3 = ChemicalGroup(title: "Raise Alkalinity")
    group3.chemicals = ["Sodium Bicarbonate", "Sodium Bisulfate"]
    
    var group4 = ChemicalGroup(title: "Raise Calcium Hardness")
    group4.chemicals = ["Calcium Chloride 100%", "Calcium Chloride 77%"]
    
    settings = [group1, group2, group3, group4]
    
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
    chemSwitch.addTarget(self, action: "didFlipSwitch:", forControlEvents: UIControlEvents.ValueChanged)
    cell.accessoryView = chemSwitch
    chemSwitch.on = NSUserDefaults.standardUserDefaults().boolForKey(title)
    
    return cell
  }
  
  func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    if let header = view as? UITableViewHeaderFooterView {
      header.textLabel.textColor = UIColor.whiteColor()
    }
  }
  
  func didFlipSwitch(sender: UISwitch) {
    if let cell = sender.superview as? UITableViewCell {
      if sender.on {
        if let indexPath = tableView.indexPathForCell(cell) {
          let rows = tableView.numberOfRowsInSection(indexPath.section)
          for var i = 0; i < rows; i++ {
            if i != indexPath.row {
              let newIndexPath = NSIndexPath(forRow: i, inSection: indexPath.section)
              let newCell = tableView.cellForRowAtIndexPath(newIndexPath)
              if let mySwitch = newCell!.accessoryView as? UISwitch {
                println("Setting \(newIndexPath) to false")
                mySwitch.setOn(false, animated: true)
                if let label = newCell!.textLabel {
                  if let chemicalName = label.text {
                    NSUserDefaults.standardUserDefaults().setBool(false, forKey: chemicalName)
                    NSUserDefaults.standardUserDefaults().synchronize()
                  }
                }
              }
            }
          }
        }
      }
      if let label = cell.textLabel {
        if let chemicalName = label.text {
          NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: chemicalName)
          NSUserDefaults.standardUserDefaults().synchronize()
        }
      }
    }
  }
  
}
