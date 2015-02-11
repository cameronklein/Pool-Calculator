//
//  CKExtensions.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 2/10/15.
//  Copyright (c) 2015 Cameron Klein. All rights reserved.
//

import UIKit

extension UIView {
  
  func addShadowWithOpacity(opacity: CGFloat, radius: CGFloat, xOffset: CGFloat, yOffset: CGFloat){
    
    self.layer.shadowColor = UIColor.blackColor().CGColor
    self.layer.shadowOpacity = opacity
    self.layer.shadowRadius = radius
    self.layer.shadowOffset = CGSize(width: xOffset, height: yOffset)
    
  }
  
}
