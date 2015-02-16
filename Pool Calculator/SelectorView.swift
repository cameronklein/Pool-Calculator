//
//  SelectorView.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 1/13/15.
//  Copyright (c) 2015 Cameron Klein. All rights reserved.
//

import UIKit

class SelectorView: UIView {

  var color : UIColor!

    override func drawRect(rect: CGRect) {
      
      let path = UIBezierPath()
      
      path.moveToPoint(CGPoint(x: rect.maxX / 2, y: rect.minY))
      path.addLineToPoint(CGPoint(x: rect.maxX, y: rect.maxY - 20))
      path.addLineToPoint(CGPoint(x: rect.minX, y: rect.maxY - 20))
      path.addLineToPoint(CGPoint(x: rect.maxX / 2, y: rect.minY))
      
      if let context = UIGraphicsGetCurrentContext() {
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextAddPath(context, path.CGPath)
        CGContextFillPath(context)
        CGContextStrokePath(context)
        
      }
    }
  
  
  

}
