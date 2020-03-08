![Sundeed](https://raw.githubusercontent.com/noursandid/SundeedSharedElement/master/SundeedLogo.png)

# SundeedSharedElement
[![License](https://img.shields.io/cocoapods/l/MarkdownKit.svg?style=flat)](http://cocoapods.org/pods/SundeedQLite) [![Language](https://img.shields.io/badge/Language-Swift-brightgreen)](https://github.com/apple/swift) [![Last Commit](https://img.shields.io/github/last-commit/noursandid/SundeedSharedElement?style=flat)](https://github.com/noursandid/SundeedSharedElement)

##### SundeedSharedElement is the and easy and fast way to implement present and push with animations ( like shared elements in Android ), built using Swift language
# Requirements
- ##### iOS 12.0+
- ##### XCode 10.3+
- ##### Swift 5+
### Installation
----
### Manually

You can easily download the project and copy the files in Library/PresentationController folder into your own project and voilà you have it ready to use


# Documentation
```swift
SundeedPresentationController.shared.present(viewController2)
            .onTopOf(self)
            .withDuration(3)
            .withSharedElement(from: self.view1, to: viewController2.view1)
            .withSharedElement(from: self.view2, to: viewController2.view2)
            .withSharedElement(from: self.view3, to: viewController2.view3)
            .now()
```

License
--------
MIT

