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
  
  var context : NSManagedObjectContext!
  var fetchController : NSFetchedResultsController!
  var dateFormatter = NSDateFormatter()
  var timeFormatter = NSDateFormatter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.registerNib(UINib(nibName: "HistoryCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CELL")
    dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
    dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
    timeFormatter.dateStyle = NSDateFormatterStyle.NoStyle
    timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 30.0
    
    setupFetchController()

  }
  
  override func viewWillAppear(animated: Bool) {
    //tableView.reloadData()
    topBar.layer.shadowColor = UIColor.blackColor().CGColor
    topBar.layer.shadowOffset = CGSize(width: 0, height: 3)
    topBar.layer.shadowOpacity = 0.5
    topBar.layer.shadowRadius = 3
    graphHeight.constant = 0
    var dummyView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40.0))
    self.tableView.tableHeaderView = dummyView;
    self.tableView.contentInset = UIEdgeInsetsMake(-40.0, 0, 0, 0);
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    if let sections = self.fetchController.sections {
      println("\(sections.count) sections")
      return sections.count
    }
    return 0
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let sections = self.fetchController.sections {
      if let sectionInfo = sections[section] as? NSFetchedResultsSectionInfo {
        return sectionInfo.numberOfObjects
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
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
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
    label.font = UIFont(name: "AvenirNext-DemiBold", size: 14.0)
    
    return headerView
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("CELL") as HistoryCell
    let reading = self.fetchController.objectAtIndexPath(indexPath) as Reading
    println(reading.timestamp)
    
    if reading.freeChlorine.doubleValue >= 0 {
      cell.freeChlorineLabel.text = String(format: "%.1f", reading.freeChlorine.doubleValue)
    } else {
      cell.freeChlorineLabel.text = "--"
    }
    if reading.combinedChlorine.doubleValue >= 0 {
      cell.combinedChlorineLabel.text = String(format: "%.1f", reading.combinedChlorine.doubleValue)
    } else {
      cell.combinedChlorineLabel.text = "--"
    }
    if reading.totalChlorine.doubleValue >= 0 {
      cell.totalChlorineLabel.text = String(format: "%.1f", reading.totalChlorine.doubleValue)
    } else {
      cell.totalChlorineLabel.text = "--"
    }
    if reading.pH.doubleValue >= 0 {
      cell.pHLabel.text = String(format: "%.1f", reading.pH.doubleValue)
    } else {
      cell.pHLabel.text = "--"
    }
    if reading.totalAlkalinity.doubleValue >= 0 {
      cell.totalAlkalinityLabel.text = String(reading.totalAlkalinity.integerValue)
    } else {
      cell.totalAlkalinityLabel.text = "--"
    }
    if reading.calciumHardness.doubleValue >= 0 {
      cell.calciumHardnessLabel.text = String(reading.calciumHardness.integerValue)
    } else {
      cell.calciumHardnessLabel.text = "--"
    }
    
    cell.timeLabel.text = timeFormatter.stringFromDate(reading.timestamp)
    cell.selectionStyle = .None
    
    return cell
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
  
  func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
    
    switch type {
    case .Delete:
      tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
    case .Insert:
      println("Did Change Row Called")
      tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
    default:
      return ()
    }
  }
  
  func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
    switch type {
    case .Delete:
      tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
    case .Insert:
      println("Did Change Section Called")
      tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
    default:
      println("Doing nothing!")
    }

  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
}
