//
//  ViewController.swift
//  YGHorizontalScrollerDemo
//
//  Created by Yi Gu on 5/9/16.
//  Copyright © 2016 yigu. All rights reserved.
//

import UIKit
import YGHorizontalScroller

class ViewController: UIViewController {

  @IBOutlet weak var scroller: YGHorizontalScroller!
  
  private var images = [UIImage]()
  private var currentIndex = 0
  
  private let VIEW_WIDTH = 200
  private let VIEW_HEIGHT = 300
  private let VIEW_PADDING = 10
  private let VIEW_OFFSET = 100
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    setupUI()
    setupData()
    setupScroller()
  }
  
  func setupUI() {
    self.scroller.layer.borderWidth = 3.0
    self.scroller.layer.borderColor = UIColor.whiteColor().CGColor
  }
  
  func setupData() {
    for i in 1 ... 4 {
      let image = UIImage(named: "photo0\(i)")
      images.append(image!)
    }
  }
  
  func setupScroller() {
    // set up UI
    scroller.viewWidth = VIEW_WIDTH
    scroller.viewHeight = VIEW_HEIGHT
    scroller.viewPadding = VIEW_PADDING
    scroller.viewOffset = VIEW_OFFSET
  
    scroller.delegate = self
    scroller.reload()
  }
  
  private func highlightView(view: UIView, isHighlight: Bool) {
    if isHighlight {
      view.backgroundColor = UIColor.whiteColor()
    } else {
      view.backgroundColor = scroller.backgroundColor
    }
  }
}

extension ViewController: YGHorizontalScrollerDelegate {
  func numberOfViews(scroller: YGHorizontalScroller) -> Int {
    return images.count
  }
  
  func cellForViewAtIndex(scroller: YGHorizontalScroller, index: Int) -> UIView {
    let image = images[index]
    let imageView = UIImageView(image: image)
      
    if currentIndex == index {
      highlightView(imageView, isHighlight: true)
    } else {
      highlightView(imageView, isHighlight: false)
    }
    
    return imageView
  }
  
  func didSelectViewAtIndex(scroller: YGHorizontalScroller, index: Int) {
    let previousView = scroller.viewAtIndex(currentIndex)
    highlightView(previousView, isHighlight: false)
    
    currentIndex = index
    
    let currentView = scroller.viewAtIndex(currentIndex)
    highlightView(currentView, isHighlight: true)
  }
  
  func initialViewIndex(scroller: YGHorizontalScroller) -> Int {
    return 0
  }
}



