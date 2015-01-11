//
//  CalculatorController.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 1/10/15.
//  Copyright (c) 2015 Cameron Klein. All rights reserved.
//

import WatchKit
import Foundation


class CalculatorController: WKInterfaceController {

  @IBOutlet weak var table: WKInterfaceTable!
  
  var dataSource = ["Chlorine", "pH", "Total Alkalinity", "Calcium Hardness"]
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    
  }

  override func willActivate() {
    super.willActivate()
    loadTableData()
  }

  override func didDeactivate() {
      // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }
  
  func loadTableData() {
    
    table.setNumberOfRows(dataSource.count, withRowType: "CalculatorTableRowController")
    
    var index = 0
    for name in dataSource {
      let row = table.rowControllerAtIndex(index) as CalculatorTableRowController
      row.title.setText(name)
      index++
    }
  }

}
