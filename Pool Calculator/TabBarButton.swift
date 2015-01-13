//
//  TabBarButton.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 1/10/15.
//  Copyright (c) 2015 Cameron Klein. All rights reserved.
//

import UIKit

class TabBarButton: UIView {
  
  var isSelected = false
  var color : UIColor!

  override func drawRect(rect: CGRect) {
    let shapeLayer = CAShapeLayer()
    var path : UIBezierPath!
    
    if isSelected {
      
      path = UIBezierPath()
      
      path.moveToPoint(CGPoint(x: rect.maxX / 2, y: rect.minY))
      path.addLineToPoint(CGPoint(x: rect.maxX, y: rect.maxY / 1.5))
      path.addLineToPoint(CGPoint(x: rect.minX, y: rect.maxY / 1.5))
      path.addLineToPoint(CGPoint(x: rect.maxX / 2, y: rect.minY))
      
      //      path.addQuadCurveToPoint(CGPoint(x: rect.maxX, y: rect.maxY / 2), controlPoint: CGPoint(x: rect.maxX, y: rect.minY))
      //      path.addQuadCurveToPoint(CGPoint(x: rect.maxX * 2, y: rect.maxY), controlPoint: CGPoint(x: rect.maxX, y: rect.maxY))
      //      path.addLineToPoint(CGPoint(x: -rect.minX, y: rect.maxY * 1.5))
      
    } else {
      
//      path = UIBezierPath(
//        roundedRect: rect,
//        byRoundingCorners: UIRectCorner.AllCorners,
//        cornerRadii: CGSize(width: rect.width, height: rect.height)
//      )
      
      path = UIBezierPath()
      
      path.moveToPoint(CGPoint(x: rect.maxX / 2, y: rect.minY))
      path.addLineToPoint(CGPoint(x: rect.maxX, y: rect.maxY / 2))
      path.addLineToPoint(CGPoint(x: rect.maxX / 2, y: rect.maxY))
      path.addLineToPoint(CGPoint(x: rect.minX, y: rect.maxY / 2))
      
      
    }
    
    if let context = UIGraphicsGetCurrentContext() {
      
      CGContextSetFillColorWithColor(context, color.CGColor)
      CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
      CGContextAddPath(context, path.CGPath)
      CGContextFillPath(context)
      CGContextStrokePath(context)
      
    }
    
  }


}
