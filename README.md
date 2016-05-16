# YGHorizontalScroller
[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![CocoaPods](https://img.shields.io/badge/pod-v0.0.4-blue.svg)]()

YGHorizontalScroller is a simple horizontal scroller implemented by Swift, this scroller will automatically center and highlight the subview you select or click.

## Requirements

* iOS 8.0+
* Xcode 6.0+

##Instalation

###CocoaPods

[CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate AutoLayoutPlus into your Xcode project using CocoaPods, include this in your Podfile:

```ruby
platform :ios, '8.0'
use_frameworks!

pod 'YGHorizontalScroller'
```

Or just copy YGHorizontalScroller.swift into your project

## Usage

YGHorizontalScroller works by wrapping sroller and UIViews together and offers a flexiable protocal with methods. To make use of methods don't forget to import YGHorizontalScroller into your code:

```swift
import YGHorizontalScroller
```
**Note: If you encounter an import error, building your project may resolve the problem**

You can create the scroll view by:
```swift
scroller = YGHorizontalScroller(frame: CGRect(x: 0, y: 100, width: screenWidth, height: 300))
view.addSubview(scroller)

scroller.viewWidth = 200
scroller.viewHeight = 300
scroller.viewPadding = 10
scroller.viewOffset = 100
  
scroller.delegate = self
scroller.reload()
```

Then implement `YGHorizontalScrollerDelegate` protocol:
```swift
func numberOfViews(scroller: YGHorizontalScroller) -> Int {
  return images.count
}
  
func cellForViewAtIndex(scroller: YGHorizontalScroller, index: Int) -> UIView {
  let image = images[index]
  let imageView = UIImageView(image: image)
      
  if currentIndex == index {
    imageView.backgroundColor = UIColor.whiteColor()
  } else {
    imageView.backgroundColor = UIColor.blackColor()
  }
    
  return imageView
}
  
func didSelectViewAtIndex(scroller: YGHorizontalScroller, index: Int) {
  let previousView = scroller.viewAtIndex(currentIndex)
  previousView.backgroundColor = UIColor.blackColor()
    
  currentIndex = index
    
  let currentView = scroller.viewAtIndex(currentIndex)
  currentView.backgroundColor = UIColor.whiteColor
}
  
func initialViewIndex(scroller: YGHorizontalScroller) -> Int {
  return 0
}
```

# Screenshots
![portrait](https://github.com/soapyigu/YGHorizontalScroller/blob/master/Screenshots/portrait.gif)
![landscape](https://github.com/soapyigu/YGHorizontalScroller/blob/master/Screenshots/landscape.gif)

## Credits

Owned and maintained by Yi. 

## Contributing

Bug reports and pull requests are welcome.

## License

YGHorizontalScroller is released under the MIT license. See LICENSE for details.
