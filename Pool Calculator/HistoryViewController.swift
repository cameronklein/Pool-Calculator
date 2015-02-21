//
//  HistoryViewController.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 12/18/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

  var headerText = "History"
  
  @IBOutlet weak var topBar: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var graphHeight: NSLayoutConstraint!
  @IBOutlet weak var tableHeaderHeight: NSLayoutConstraint!
  @IBOutlet weak var emptyCaseView: UIView!
  
  var context : NSManagedObjectContext!
  var fetchController : NSFetchedResultsController!
  var dateFormatter = NSDateFormatter()
  var timeFormatter = NSDateFormatter()
  
  // MARK: - UIViewController Lifecycle Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupFetchController()
    tableView.registerNib(UINib(nibName: "HistoryCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CELL")
    tableView.registerNib(UINib(nibName: "HistoryCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TOPCELL")
    dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
    dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
    timeFormatter.dateStyle = NSDateFormatterStyle.NoStyle
    timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    tableView.rowHeight = 30.0
    topBar.addShadowWithOpacity(0.5, radius: 3, xOffset: 0, yOffset: 3)

    self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 80.0))
    
  }
  
  override func viewWillAppear(animated: Bool) {
    checkEmptyCase()
    graphHeight.constant = 0
    tableHeaderHeight.constant = 0
    var dummyView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40.0))
    self.tableView.tableHeaderView = dummyView;
    self.tableView.contentInset = UIEdgeInsetsMake(-40.0, 0, 0, 0);
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }
  
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    for object in tableView.visibleCells() {
      if let cell = object as? HistoryCell {
        cell.setHorizontalConstraintsForScreenWidth(size.width)
      }
    }
  
  }
  
  // MARK: - TableViewDataSource
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if let sections = self.fetchController.sections {
      return sections.count
    }
    return 0
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let sections = self.fetchController.sections {
      if let sectionInfo = sections[section] as? NSFetchedResultsSectionInfo {
        return sectionInfo.numberOfObjects + 1
      }
    }
    return 0
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
    if let sections = self.fetchController.sections {
      if let sectionInfo = sections[section] as? NSFetchedResultsSectionInfo {
        if let reading = sectionInfo.objects.first as? Reading {
          return dateFormatter.stringFromDate(reading.timestamp)
        }
      }
    }
    
    return nil
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
    let label = UILabel(frame: CGRect(x: 8, y: 0, width: tableView.frame.width, height: 24))
    headerView.addSubview(label)
    
    if let sections = self.fetchController.sections {
      if let sectionInfo = sections[section] as? NSFetchedResultsSectionInfo {
        if let reading = sectionInfo.objects.first as? Reading {
          label.text = dateFormatter.stringFromDate(reading.timestamp)
        }
      }
    }
    
    headerView.backgroundColor = UIColor.clearColor()
    label.textColor = UIColor.whiteColor()
    label.font = UIFont(name: "AvenirNext-DemiBold", size: 16.0)
    
    return headerView
  }
  
  func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      let cell = tableView.dequeueReusableCellWithIdentifier("TOPCELL", forIndexPath: indexPath) as HistoryCell
      configureUnitsLabelCell(cell)
      return cell
    default:
      let cell = tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath: indexPath) as HistoryCell
      configureNormalCell(cell, forObjectAtIndexPath: indexPath)
      return cell
    }
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.row {
    case 0:
      return 50
    default:
     return 30
    }
  }
  
  // MARK: - NSFetchResultsControllerDelegate
  
  func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
    switch type {
    case .Delete:
      tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
    case .Insert:
      if let thisPath = indexPath {
        tableView.insertRowsAtIndexPaths([thisPath], withRowAnimation: .Automatic)
      } else if let thisOtherPath = newIndexPath {
        if let oldReading = fetchController.objectAtIndexPath(thisOtherPath) as? Reading {
          if let newReading = anObject as? Reading {
            if newReading.timestamp != oldReading.timestamp {
              tableView.insertRowsAtIndexPaths([thisOtherPath], withRowAnimation: .Automatic)
            } else {
              tableView.reloadData()
            }
          }
        }
      }
    default:
      return ()
    }
  }
  
  func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
    switch type {
    case .Delete:
      tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
    case .Insert:
      tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
    default:
      break
    }
    
  }

  // MARK: - Helper Methods
  
  func configureUnitsLabelCell(cell: HistoryCell) {
    for label in cell.contentView.subviews {
      if let myLabel = label as? UILabel {
        myLabel.font = UIFont(name: "AvenirNext-Regular", size: 12.0)
      }
    }
    cell.leftCircleView.isHeader = true
    cell.timeLabel.text = ""
    cell.freeChlorineLabel.text = "Free\nChlorine"
    cell.combinedChlorineLabel.text = "Combined\nChlorine"
    cell.totalChlorineLabel.text = "Total\nChlorine"
    cell.pHLabel.text = "pH"
    cell.totalAlkalinityLabel.text = "Total\nAlkalinity"
    cell.calciumHardnessLabel.text = "Calcium\nHardness"
    cell.selectionStyle = .None
    cell.setHorizontalConstraintsForScreenWidth(UIScreen.mainScreen().bounds.width)
    
  }
  
  func configureNormalCell(cell: HistoryCell, forObjectAtIndexPath indexPath: NSIndexPath) {
    let newIndexPath = NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)
    let reading = self.fetchController.objectAtIndexPath(newIndexPath) as Reading
    
    if let number = reading.freeChlorine? {
      cell.freeChlorineLabel.text = String(format: "%.1f", number.doubleValue)
    } else {
      cell.freeChlorineLabel.text = "--"
    }
    if let number = reading.combinedChlorine? {
      cell.combinedChlorineLabel.text = String(format: "%.1f", number.doubleValue)
    } else {
      cell.combinedChlorineLabel.text = "--"
    }
    if let number = reading.totalChlorine? {
      cell.totalChlorineLabel.text = String(format: "%.1f", number.doubleValue)
    } else {
      cell.totalChlorineLabel.text = "--"
    }
    if let number = reading.pH? {
      cell.pHLabel.text = String(format: "%.1f", number.doubleValue)
    } else {
      cell.pHLabel.text = "--"
    }
    if let number = reading.totalAlkalinity? {
      cell.totalAlkalinityLabel.text = String(number.integerValue)
    } else {
      cell.totalAlkalinityLabel.text = "--"
    }
    if let number = reading.calciumHardness? {
      cell.calciumHardnessLabel.text = String(number.integerValue)
    } else {
      cell.calciumHardnessLabel.text = "--"
    }
    
    cell.timeLabel.text = timeFormatter.stringFromDate(reading.timestamp)
    cell.selectionStyle = .None
    cell.setHorizontalConstraintsForScreenWidth(UIScreen.mainScreen().bounds.width)
    
    if indexPath.row == 1 {
      cell.leftCircleView.isTop = true
    } else if let sections = self.fetchController.sections {
      if let sectionInfo = sections[indexPath.section] as? NSFetchedResultsSectionInfo {
        if indexPath.row == sectionInfo.numberOfObjects {
          cell.leftCircleView.isBottom = true
        }
      }
    }
  }
  
  func setupFetchController() {
    
    let appDel = UIApplication.sharedApplication().delegate as AppDelegate
    context = appDel.managedObjectContext
    
    var fetchRequest = NSFetchRequest(entityName: "Reading")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "day", ascending: false), NSSortDescriptor(key: "timestamp", ascending: true)]
    self.fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "day", cacheName: "Readings")
    fetchController.delegate = self
    
    var error : NSError?
    fetchController.performFetch(&error)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "didGetCloudChanges:", name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: appDel.persistentStoreCoordinator)
    
    if error != nil {
      println(error?.localizedDescription)
    }
  }
  
  func checkEmptyCase() {
    if fetchController.fetchedObjects?.count == 0 {
      self.emptyCaseView.alpha = 1
    } else {
      self.emptyCaseView.alpha = 0
    }
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
}
