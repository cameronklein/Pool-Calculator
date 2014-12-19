//
//  HistoryViewController.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 12/18/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

  @IBOutlet weak var topBar: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

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
  

}
