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
  @IBOutlet weak var leftCircleView: TableLeftCircleView!
  
  @IBOutlet weak var horizontalConstraintOne: NSLayoutConstraint!
  @IBOutlet weak var horizontalConstraintTwo: NSLayoutConstraint!
  @IBOutlet weak var horizontalConstraintThree: NSLayoutConstraint!
  @IBOutlet weak var horizontalConstraintFour: NSLayoutConstraint!
  @IBOutlet weak var horizontalConstraintFive: NSLayoutConstraint!

  override func awakeFromNib() {
    super.awakeFromNib()
    
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

  }
  
  func setHorizontalConstraintsForScreenWidth(width: CGFloat) {
    
    switch width {
    case 320:
      setHorizontalConstraintsWithConstant(14)
    case 375:
      setHorizontalConstraintsWithConstant(32)
    case 414:
      setHorizontalConstraintsWithConstant(50)
    case 480:
      setHorizontalConstraintsWithConstant(0)
    case 568:
      setHorizontalConstraintsWithConstant(16)
    case 667:
      setHorizontalConstraintsWithConstant(34)
    case 736:
      setHorizontalConstraintsWithConstant(46)
    default:
      setHorizontalConstraintsWithConstant(32)
    }

  }
  
  func setHorizontalConstraintsWithConstant(constant: CGFloat) {
    for constraint in [horizontalConstraintOne, horizontalConstraintTwo, horizontalConstraintThree, horizontalConstraintFour, horizontalConstraintFive] {
      
      constraint.constant = constant
      
    }
  }
    
}
