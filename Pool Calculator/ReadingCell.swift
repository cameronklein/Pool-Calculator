//
//  ReadingCell.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 12/18/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

import UIKit

class ReadingCell: UITableViewCell {

  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var readingValue: UILabel!
  var readingType : ReadingType?
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

  }
    
}
