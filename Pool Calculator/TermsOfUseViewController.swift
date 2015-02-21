//
//  TermsOfUseViewController.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 12/28/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit

class TermsOfUseViewController: UIViewController {
  
  @IBOutlet weak var label1: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    var text = "";
    text = text + "By accessing this app, you are agreeing to be bound by these terms and conditions of use, all applicable laws and regulations, and agree that you are responsible for compliance with any applicable local laws. If you do not agree with any of these terms, you are prohibited from using or accessing this app. The materials contained in this app are protected by applicable copyright and trade mark law."
    text = text + "\n\nThe materials in this app are provided \"as is\". The developers make no warranties, expressed or implied, and hereby disclaim and negate all other warranties, including without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights. Further, we do not warrant or make any representations concerning the accuracy, likely results, or reliability of the use of the materials on its app or otherwise relating to such materials or on any sites linked to this app."
    text = text + "\n\nIn no event shall Pool Operator or its suppliers or developers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption,) arising out of the use or inability to use the materials on the app, even if a Pool Operator authorized representative has been notified orally or in writing of the possibility of such damage."
    text = text + "\n\nAlways double check pool chemical calculations before adding chemicals and wear proper personal protective equipment. Use best practices when adding chemicals to pools. Follow local laws and regulations when handling chemicals."
    label1.text = text
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()

  }

}
