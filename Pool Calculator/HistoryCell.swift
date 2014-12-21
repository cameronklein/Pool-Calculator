//
//  HistoryCell.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 12/19/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
  
  @IBOutlet weak var freeChlorineLabel: UILabel!
  @IBOutlet weak var combinedChlorineLabel: UILabel!
  @IBOutlet weak var totalChlorineLabel: UILabel!
  @IBOutlet weak var pHLabel: UILabel!
  @IBOutlet weak var totalAlkalinityLabel: UILabel!
  @IBOutlet weak var calciumHardnessLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var widthConstraint: NSLayoutConstraint!
  

  override func awakeFromNib() {
    super.awakeFromNib()
    
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)


  }
    
}
