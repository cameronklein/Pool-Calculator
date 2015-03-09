//
//  PoolDrawingViewController.swift
//  Pool Calculator
//
//  Created by Cameron Klein on 3/6/15.
//  Copyright (c) 2015 Cameron Klein. All rights reserved.
//

import UIKit

class PoolDrawingViewController: UIViewController {
  
  @IBOutlet weak var drawingView: DrawingView!
  @IBOutlet weak var rectangleWrapper: UIView!
  @IBOutlet weak var circleWrapper: UIView!
  @IBOutlet weak var oblongWrapper: UIView!
  @IBOutlet weak var ellipseWrapper: UIView!
  
  @IBOutlet weak var squareView: PoolShapeView!
  @IBOutlet weak var circleView: PoolShapeView!
  @IBOutlet weak var ellipseView: PoolShapeView!
  @IBOutlet weak var oblongView: PoolShapeView!
  
  var done : Bool = false
  
  var views : [UIView]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let dragger = UIPanGestureRecognizer()
    dragger.addTarget(self, action: "didPan:")
    self.drawingView.addGestureRecognizer(dragger)
    
    squareView.type = .Rectangle
    circleView.type = .Circle
    ellipseView.type = .Ellipse
    oblongView.type = .Oblong
    
    views = [rectangleWrapper, circleWrapper, oblongWrapper, ellipseWrapper]
    
    for view in views {
      let tapper = UITapGestureRecognizer()
      tapper.addTarget(self, action: "didTapView:")
      view.addGestureRecognizer(tapper)
    }
    
  }
  
  func didPan(sender : UIPanGestureRecognizer) {
    println(drawingView.path.currentPoint)
    if drawingView.path.currentPoint == CGPointZero  {
      drawingView.path.moveToPoint(sender.locationInView(drawingView));
    }
    drawingView.addPoint(sender.locationInView(drawingView));
    
  }
  
  func didTapView(sender: UITapGestureRecognizer) {
    
    if sender.state == .Ended {
      if let view = sender.view {
        self.growView(view)
      }
    }
  }
  
  func growView(view: UIView) {
    
    let constraints = self.drawingView.constraints()
    for constraint in constraints {
      var myConstraint : NSLayoutConstraint!
      if let thisConstraint = constraint as? NSLayoutConstraint {
        myConstraint = thisConstraint as NSLayoutConstraint
      }
      var myView : UIView!
      if let thisItem = myConstraint.secondItem as? UIView {
        myView = thisItem as UIView
      }
      if myView == view {
        if myConstraint.firstAttribute == .Height || myConstraint.firstAttribute == .Width {
          if myConstraint.priority == 999 {
            myConstraint.priority = 500
          }
        }
      }
    }
    
    UIView .animateWithDuration(1.0, animations: { () -> Void in
      self.drawingView.layoutIfNeeded()
      view.setNeedsDisplay()
      for otherView in self.views {
        if otherView != view {
          otherView.alpha = 0
          otherView.transform = CGAffineTransformMakeScale(0.4, 0.4)
        }
      }
    }) { (success) -> Void in
      println("Done")
    }
  }
  
}
