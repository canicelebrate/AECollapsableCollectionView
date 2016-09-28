# AECollapsableCollectionView
A generic collapsable UICollectionView with default layout UICollectionViewFlowLayout.

This library is inspired by the another similar project APLExpandableCollectionView.  That shortcoming of that project is that it need comsumer to prepare extra collection cell as the clickable header to tigger the collapse or expand action. As a result, the developer have to take more effort to deal with the stuffs besides their core business logic.

AECollapsableCollectionView defined the toggle method for a spefic section, so that the developers can trigger the toggle action conventiently. The section can be expanded by tapping the button in the header view. You can check detail in the sample project.

Some codes of the project come from APLExpandableCollectionView. Many thanks for the code sharing from apploft.
  
## Screen shot
![](https://github.com/canicelebrate/AECollapsableCollectionView/blob/master/AECollapsableCollectionView.gif?raw=true)

## Implementation
  Subclassed the UICollectionView and utilize its performBatchUpdates, insertItemsAtIndexPaths and deleteItemsAtIndexPaths to implement the collapse and expand behavor of the collection section.

## Setup
### Using [CocoaPods](http://cocoapods.org)
1. Add the pod `AECollapsableCollectionView` to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html).

  ```ruby
  pod 'AECollapsableCollectionView'
  ```

2. Run `pod install` from Terminal, then open your app's `.xcworkspace` file to launch Xcode.

3. Import the `AECollapsableCollectionView.h` umbrella header.
    * Objective-C: `#import "AECollapsableCollectionView.h"`


That's it - now go write a cool APP with AECollapsableCollectionView!

## Usage
### Sample Code (Objective-C)
AECollapsableCollectionView wrapped the section collaps and expand actions. Let's take a quick look at an example,

Steps

1. In the storyboard, set the class of the collection view in your view controller to AECollapsableCollectionView.

2. Add the collection view outlet in your view controller by dragging the AECollapsableCollectionView instance as a outlet from the storyboard to your .h or .m file.

3. In the proper place of your own .m file, invoke AECollapsableCollectionView's method toggleCollapsableSection:

Please check more detail information in the sample project in this repository.

```objective-c
[self.collectionView toggleCollapsableSection:btn.tag];
```

## Meta
Originally designed & built by William ([@canicelebrate](https://github.com/canicelebrate)). Distributed with the MIT license.
