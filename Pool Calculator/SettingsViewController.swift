//
//  SettingsViewController.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 12/22/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

  @IBOutlet weak var topBar: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
      // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    addTopBarShadow()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
  
  func addTopBarShadow() {
    topBar.layer.shadowColor = UIColor.blackColor().CGColor
    topBar.layer.shadowOffset = CGSize(width: 0, height: 3)
    topBar.layer.shadowOpacity = 0.5
    topBar.layer.shadowRadius = 3
  }

}
