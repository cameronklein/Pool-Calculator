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
  var done : Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.drawingView.layer.borderColor = UIColor.whiteColor().CGColor
    self.drawingView.layer.borderWidth = 2
    
    let dragger = UIPanGestureRecognizer()
    dragger.addTarget(self, action: "didPan:")
    self.drawingView.addGestureRecognizer(dragger)
  }
  
  func didPan(sender : UIPanGestureRecognizer) {
    println(drawingView.path.currentPoint)
    if drawingView.path.currentPoint == CGPointZero  {
      drawingView.path.moveToPoint(sender.locationInView(drawingView));
    }
    drawingView.addPoint(sender.locationInView(drawingView));
    
  }
  
}
