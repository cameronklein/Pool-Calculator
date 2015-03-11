//
//  MeasurementsView.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 3/9/15.
//  Copyright (c) 2015 Cameron Klein. All rights reserved.
//

import UIKit

class MeasurementsView: UIView {

  var type : PoolShape = .Rectangle
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
      
      var path = UIBezierPath()
      
      switch type {
      case .Rectangle:
        let insetRect = CGRectInset(rect, 8, 32)
        path = UIBezierPath(rect: insetRect)
      case .Circle:
        let insetRect = CGRectInset(rect, 8, 8)
        path = UIBezierPath(roundedRect: insetRect, cornerRadius: insetRect.width/2)
      case .Ellipse:
        let insetRect = CGRectInset(rect, 8, 28)
        path = UIBezierPath(ovalInRect: insetRect)
      case .Oblong:
        
        let insetRect = CGRectInset(rect, 8, 28)
        let insetX : CGFloat = 8.0
        let insetY : CGFloat = 24.0
        
        path.moveToPoint(CGPointMake(24 + insetX, insetY))
        path.addLineToPoint(CGPointMake(insetRect.width - 16 + insetX, 16 + insetY))
        path.addQuadCurveToPoint((CGPointMake(insetRect.width - 16 + insetX, insetRect.height - 16 + insetY)), controlPoint: CGPointMake(insetRect.width + insetX, insetRect.height / 2 + insetY))
        path.addLineToPoint(CGPointMake(24 + insetX, insetRect.height + insetY))
        path.addQuadCurveToPoint((CGPointMake(24 + insetX, 0 + insetY)), controlPoint: CGPointMake(0 + insetX, insetRect.height / 2 + insetY))
        path.closePath()
        
      }
      
      let context = UIGraphicsGetCurrentContext();
      CGContextAddPath(context, path.CGPath);
      CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor);
      CGContextSetLineWidth(context, 3)
      CGContextStrokePath(context);
      
      }
  
}



