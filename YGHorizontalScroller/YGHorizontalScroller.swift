//
//  YGHorizontalScroller.swift
//  YGHorizontalScroller
//
//  Created by Yi Gu on 5/9/16.
//  Copyright © 2016 yigu. All rights reserved.
//

import UIKit

public protocol YGHorizontalScrollerDelegate: class {
  // number of views to display inside the horizontal scroller
  func numberOfViews(scroller: YGHorizontalScroller) -> Int
  
  // return the view that should appear at <index>
  func cellForViewAtIndex(scroller: YGHorizontalScroller, index:Int) -> UIView
  
  // inform the delegate what the view at <index> has been clicked
  func didSelectViewAtIndex(scroller: YGHorizontalScroller, index:Int)
  
  // set up the initial view to display
  func initialViewIndex(scroller: YGHorizontalScroller) -> Int
}

public class YGHorizontalScroller: UIView {
  public weak var delegate: YGHorizontalScrollerDelegate?
  
  // MARK: - Variables
  public var viewPadding = 10
  public var viewWidth = 100
  public var viewHeight = 100
  public var viewOffset = 100
  
  var viewArray = [UIView]()
  var scroller : UIScrollView!
  
  // MARK: - Lifecycle
  override public init(frame: CGRect) {
    super.init(frame: frame)
    initializeScrollView()
  }
  
  required public init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    initializeScrollView()
  }
  
  func initializeScrollView() {
    scroller = UIScrollView()
    scroller.delegate = self
    addSubview(scroller)
    
    scroller.translatesAutoresizingMaskIntoConstraints = false
    
    // apply constraints
    self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
    self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
    self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
    self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
    
    // add tap recognizer
    let tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(YGHorizontalScroller.scrollerTapped(_:)))
    scroller.addGestureRecognizer(tapRecognizer)
  }
  
  // call reload when added to another view
  override public func didMoveToSuperview() {
    reload()
  }
  
  // MARK: - Internal Functions
  func scrollerTapped(gesture: UITapGestureRecognizer) {
    let location = gesture.locationInView(gesture.view)
    
    guard let delegate = delegate else {
      return
    }
    
    for index in 0 ..< delegate.numberOfViews(self) {
      let view = scroller.subviews[index]
      
      if CGRectContainsPoint(view.frame, location) {
        delegate.didSelectViewAtIndex(self, index: index)
        
        // center the tapped view in the scroll view
        scroller.setContentOffset(CGPoint(x: view.frame.origin.x - self.frame.size.width / 2 + view.frame.size.width / 2, y: 0), animated:true)
        
        break
      }
    }
  }
  
  public func viewAtIndex(index :Int) -> UIView {
    return viewArray[index]
  }
  
  public func reload() {
    // check if there is a delegate, if not there is nothing to load.
    if let delegate = delegate {
      // reset viewArray
      viewArray = []
      
      // remove all subviews
      let views: NSArray = scroller.subviews
      for view in views {
        view.removeFromSuperview()
      }
      
      // xValue is the starting point of the views inside the scroller
      var xValue = viewOffset
      for index in 0 ..< delegate.numberOfViews(self) {
        // add a view at the right position
        xValue += viewPadding
        
        let view = delegate.cellForViewAtIndex(self, index: index)
        view.frame = CGRectMake(CGFloat(viewPadding), CGFloat(viewPadding), CGFloat(viewWidth) - CGFloat(viewPadding * 2), CGFloat(viewHeight) - CGFloat(viewPadding * 2))
        let basicView = UIView(frame: CGRect(x: CGFloat(xValue), y: 0, width: CGFloat(viewWidth), height: CGFloat(viewHeight)))
        basicView.addSubview(view)
        
        scroller.addSubview(basicView)
        xValue += viewWidth + viewPadding
        
        // store the view to viewArray
        viewArray.append(basicView)
      }
      
      scroller.contentSize = CGSizeMake(CGFloat(xValue + viewOffset), frame.size.height)
      
      // if an initial view is defined, center the scroller on it
      let initialView = delegate.initialViewIndex(self)
      scroller.setContentOffset(CGPoint(x: CGFloat(initialView) * CGFloat((viewWidth + (2 * viewPadding))), y: 0), animated: true)
    }
  }
  
  func centerCurrentView() {
    var xFinal = Int(scroller.contentOffset.x) + (viewOffset / 2) + viewPadding
    let viewIndex = xFinal / (viewWidth + (2 * viewPadding))
    xFinal = viewIndex * (viewWidth + (2 * viewPadding))
    scroller.setContentOffset(CGPoint(x: xFinal, y: 0), animated: true)
    if let delegate = delegate {
      delegate.didSelectViewAtIndex(self, index: Int(viewIndex))
    }
  }
}

extension YGHorizontalScroller: UIScrollViewDelegate {
  public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      centerCurrentView()
    }
  }
  
  public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    centerCurrentView()
  }
}
