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
  
  var context : NSManagedObjectContext!
  var fetchController : NSFetchedResultsController!
  var dateFormatter = NSDateFormatter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.registerNib(UINib(nibName: "HistoryCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CELL")
    dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
    dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    setupFetchController()
  }
  
  override func viewWillAppear(animated: Bool) {
    tableView.reloadData()
    topBar.layer.shadowColor = UIColor.blackColor().CGColor
    topBar.layer.shadowOffset = CGSize(width: 0, height: 3)
    topBar.layer.shadowOpacity = 0.5
    topBar.layer.shadowRadius = 3
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fetchController.fetchedObjects!.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("CELL") as HistoryCell
    let reading = self.fetchController.fetchedObjects![indexPath.row] as Reading
    
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
    
    cell.timeLabel.text = dateFormatter.stringFromDate(reading.timestamp)
    cell.selectionStyle = .None
    
    cell.widthConstraint.constant = cell.frame.width
    
    return cell
  }
  
  func setupFetchController() {
    let appDel = UIApplication.sharedApplication().delegate as AppDelegate
    context = appDel.managedObjectContext
    
    var fetchRequest = NSFetchRequest(entityName: "Reading")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
    self.fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
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
      tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
    case .Insert:
      tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
    default:
      println("Doing nothing!")
    }
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
}
