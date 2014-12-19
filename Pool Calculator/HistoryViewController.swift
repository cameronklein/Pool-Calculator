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

  @IBOutlet weak var topBar: UIView!
  @IBOutlet weak var tableView: UITableView!
  
  var context : NSManagedObjectContext!
  var fetchController : NSFetchedResultsController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.registerNib(UINib(nibName: "HistoryCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CELL")
    
  }
  
  override func viewWillAppear(animated: Bool) {
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
    cell.freeChlorineLabel.text = reading.freeChlorine.stringValue
    cell.combinedChlorineLabel.text = reading.combinedChlorine.stringValue
    cell.totalChlorineLabel.text = reading.totalChlorine.stringValue
    cell.pHLabel.text = reading.pH.stringValue
    cell.totalAlkalinityLabel.text = reading.totalAlkalinity.stringValue
    cell.calciumHardnessLabel.text = reading.calciumHardness.stringValue
    
    return cell
  }
  
  func setupFetchController() {
    let appDel = UIApplication.sharedApplication().delegate as AppDelegate
    context = appDel.managedObjectContext
    
    var fetchRequest = NSFetchRequest(entityName: "Reading")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
    self.fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: "Reminders")
    fetchController.delegate = self
    var error : NSError?
    fetchController.performFetch(&error)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "didGetCloudChanges:", name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: appDel.persistentStoreCoordinator)
    
    if error != true {
      println(error?.localizedDescription)
    }
  }

  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
}
