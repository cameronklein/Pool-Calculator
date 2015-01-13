//
//  TableLeftCircleView.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 1/12/15.
//  Copyright (c) 2015 Cameron Klein. All rights reserved.
//

import UIKit

class TableLeftCircleView: UIView {
  
  var isBottom = false
  var isTop = false

  
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
  override func drawRect(rect: CGRect) {
    
    let context = UIGraphicsGetCurrentContext()
    
    let circleDiameter : CGFloat = 8.0
    let circleRadius : CGFloat = circleDiameter / 2
    let circleOriginX = rect.width / 2 - circleRadius
    let circleOriginY = rect.height / 2 - circleRadius
    
    let lineX = rect.width / 2
    
    if !isTop{
      let path = UIBezierPath(roundedRect: CGRect(x: circleOriginX, y: circleOriginY, width: circleDiameter, height: circleDiameter), cornerRadius: circleRadius)
      CGContextAddPath(context, path.CGPath)
    }
    
    let path2 = UIBezierPath()
    
    path2.moveToPoint(CGPoint(x: lineX, y: 0))
    
    path2.addLineToPoint(CGPoint(x: lineX, y: circleOriginY))
    
    if !isBottom {
      if !isTop{
        path2.moveToPoint(CGPoint(x: lineX, y: circleOriginY + circleDiameter))
      }
      path2.addLineToPoint(CGPoint(x: lineX, y: rect.height))
    }
    
    
    CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
    CGContextSetLineWidth(context, 1)
    
    CGContextAddPath(context, path2.CGPath)
    CGContextStrokePath(context)
    
  }


}
