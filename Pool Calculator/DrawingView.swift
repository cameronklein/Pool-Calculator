//
//  DrawingView.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 3/6/15.
//  Copyright (c) 2015 Cameron Klein. All rights reserved.
//

import UIKit

class DrawingView: UIView {
  
  var path = UIBezierPath()
  
  override func drawRect(rect: CGRect) {

    let context = UIGraphicsGetCurrentContext()
  
    CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
    CGContextSetLineWidth(context, 4)
    
    CGContextAddPath(context, path.CGPath)
    CGContextStrokePath(context)
    
  }
  
  func addPoint(point : CGPoint) {
    self.path.addLineToPoint(point)
    self.setNeedsDisplay()
  }

}
