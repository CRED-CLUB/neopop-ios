# NeoPop

[![CI Status](https://img.shields.io/travis/yadhu-cred/CheeseCake.svg?style=flat)](https://travis-ci.org/yadhu-cred/neopop-ios)
[![Version](https://img.shields.io/cocoapods/v/CheeseCake.svg?style=flat)](https://cocoapods.org/pods/neopop-ios)
[![License](https://img.shields.io/cocoapods/l/CheeseCake.svg?style=flat)](https://cocoapods.org/pods/neopop-ios)
[![Platform](https://img.shields.io/cocoapods/p/CheeseCake.svg?style=flat)](https://cocoapods.org/pods/neopop-ios)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

NeoPop is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'NeoPop'
```


# Usage

# PopView

`PopView` is a subclass of UIView, which can exhibit the Neopop effect.

The design of a `PopView` can be primarily classified with respect to the direction of viewing `PopView`.
those are called the `EdgeDirection` of the PopView, 
which are:
 - *topLeft*
 - *topRight*
 - *bottomLeft*
 - *bottomRight*
 - *top*
 - *bottom*
 - *left*
 - *right*
 
 `PopView.Model` holds the properties of a `PopView`, which helps you to customise the view w.r.t your requirements.

`PopView.Model` can be initialised as follows.
```swift
    let model = PopView.Model.createModel(popEdgeDirection: .bottomRight, backgroundColor: UIColor.gray)
```    

 for more customisations use
```swift
    let model: PopView.Model = PopView.Model.createModel(popEdgeDirection: .bottomRight, customEdgeVisibility: customEdgeVisibility, customBorderVisibility: customBorderVisibility, edgeOffSet: 3, backgroundColor: UIColor.gray, verticalEdgeColor: UIColor.darkGray, horizontalEdgeColor: UIColor.lightGray, verticalBorderColors: verticalBorderColors, horizontalBorderColors: horizontalBorderColors, clipsToOffSetWidth: clipsToOffsetWidth, clipsToOffSetHeight: clipsToOffsetHeight, delegate: self, modelIdentifier: "model-1", borderWidth: 0.5)
```
**`PopView.Model` initialiser arguments**

| attribute  | description  | value | 
|--|--|--|
| `popEdgeDirection`| Direction of edge of the pop view.  | EdgeDirection |
| `customEdgeVisibility`| Change the visibility of the available edges..  | EdgeVisibilityModel |
| `customBorderVisibility`| Change the visibility of the border.  | EdgeVisibilityModel |
| `edgeOffSet`| depth of the edge.  | CGFloat |
| `backgroundColor`| Background color of the view.  | UIColor |
| `verticalEdgeColor`| Color of the vertical edge in the view. (either of left/right). Optional input as it will be derived from bg color.  | UIColor |
| `horizontalEdgeColor`| Color of the horizontal edge in the view. (either of top/bottom). Optional input as it will be derived from bg color.  | UIColor |
| `verticalBorderColors`| Color of the vertical edge borders. (customisable for each side of the edge).  | EdgeColors |
| `horizontalBorderColors`| Color of the horizontal edge borders. (customisable for each side of the edge).  | EdgeColors |
| `clipsToOffSetWidth`| Whether clipping needs to be done to the horizontal edge (clipping position options are available here).  | EdgeDirection |
| `clipsToOffSetHeight`| Whether clipping needs to be done to the vertical edge (clipping position options are available here).  | EdgeDirection |
| `delegate`| Delegate to handle the callbacks. customisations in the drawing path can be achieved through this delegate.  | PopViewDrawable |
| `modelIdentifier`| Identifier for model/view for reference  | String? |
| `borderWidth`| width for the border.  | CGFloat |

 

**Initialising a `PopView`**

You can create a `PopView` through code using the below approach.
```swift
	let model = PopView.Model.createModel(popEdgeDirection: .bottomRight, backgroundColor: UIColor.black)
	let popView = PopView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), model: model)
```
apply Neopop effect on a neopop view as:
```swift
    @IBOutlet private weak var popView: PopView!
    ...
    let model = PopView.Model.createModel(popEdgeDirection: .bottomRight, backgroundColor: UIColor.black)
    popView.configurePopView(withModel: model)
```
There is also an extension created on `UIView`, which enables to apply Neopop Style in any existing `UIView` element,

```swift
    var view: UIView!
    
    let model = PopView.Model.createModel(popEdgeDirection: .bottomRight, backgroundColor: UIColor.black)
    view.applyNeoPopStyle(model: model)
```

# Buttons

## PopButton

![Frame 11181](https://user-images.githubusercontent.com/72977449/172914976-25860b42-9f0e-408e-8cf2-a444fa87e5b6.png)


The structure and the behavior of a PopButton mainly depends on two parameters which are `EdgeDirection` & `PopButton.Position`.

`EdgeDirection` is the possible directions of viewing the 3-dimentional `PopButton`, 
which are :
 - *topLeft*
 - *topRight*
 - *bottomLeft*
 - *bottomRight*
 - *top*
 - *bottom*
 - *left*
 - *right*
 
`PopButton.Position` is the possible positions of a button on a 3-dimentional `PopView`, 
which are  :
 - *bottomRight*
 - *bottomLeft*
 - *topRight*
 - *topLeft*
 - *bottomEdge*
 - *topEdge*
 - *leftEdge*
 - *rightEdge*
 - *center*
 
`PopButton.Model` is an entity which holds the behavioural properties of a PopButton, which can help you to customise the PopButton w.r.t your requirements.

**Initialising a `PopButton.Model`** 
```swift
    let model = PopButton.Model.createButtonModel(position: .bottomRight, buttonColor: UIColor.gray)
```
OR
```swift
    let faceBorderColors = EdgeColors.init(left: UIColor.gray, right: UIColor.gray, top: UIColor.gray, bottom: UIColor.gray)
    let customEdgeColors = EdgeColors.init(left: UIColor.gray, right: UIColor.gray, top: UIColor.gray, bottom: UIColor.gray)
    let edgeBorderColors = PopButton.BorderModel(allEdgeIn: UIColor.black)
    let customadjacentButtonAvailability: AdjacentButtonAvailability = AdjacentButtonAvailability.create(top: false, bottom: false, left: false, right: false)
    let shimmerStyle = ShimmerStyle.none
        
    let model = PopButton.Model.createButtonModel(direction: .bottomRight, position: .bottomRight, buttonColor: UIColor.gray, superViewColor: UIColor.white, parentContainerBGColor: UIColor.white, buttonFaceBorderColor: faceBorderColors, edgeBorderColors: edgeBorderColors, borderWidth: 0.5, edgeWidth: 3, customadjacentButtonAvailability: customadjacentButtonAvailability, customEdgeColor: customEdgeColors, showStaticBaseEdges: false, shimmerStyle: shimmerStyle)
```

**`PopButton.Model` initialiser arguments**
| attribute  | description  | value | 
|--|--|--|
| `direction`| Direction of the edges of the button.  | EdgeDirection |
| `position`| Position of the button w.r.t the super Neopop view.  | PopButton.Position |
| `backgroundColor`| color of the button  | UIColor |
| `superViewColor`| color of the neopop container color (bg color of the neopop-view which is the super view of the button)  | UIColor? |
| `parentContainerBGColor`| bg color of the container(bg color of container view which is the super view of the neopop-view which is holding the neopop button). This will be necessary to draw the edges of the button in some positions.  | UIColor? |
| `buttonFaceBorderColor`| border colors of button's content face.  | EdgeColors? |
| `borderColors`| border colors of the edges of the button.  | PopButton.BorderModel? |
| `borderWidth`| width of the border  | CGFloat |
| `adjacentButtonAvailability`| presence of the other button close the edges the current button.  | AdjacentButtonAvailability |
| `customEdgeColor`| customise the color of the edges.  | EdgeColors? |
| `edgeLength`| depth of the edges.  | CGFloat |
| `showStaticBaseEdges`| decides whether to draw borders at the bottom edges of the button.  | Bool |
| `shimmerStyle`| shimmer configurations.  | ShimmerStyle? |


**How to setup the Button content ?**
The content to show on a button surface differs w.r.t your use case and design requirements.
So, all buttons in Neopop framework is designed to accept a UIView confirming to the protocol `PopButtonCustomContainerDrawable`  as its contentView. So, you can create any number of custom views w.r.t your requirements and use it on any buttons in Neopop framework.

`PopButtonCustomContainerDrawable` protocol will be listening to state changes of the owner button, such that you can also update the button content view (confirming `PopButtonCustomContainerDrawable`) w.r.t state changes.

```swift
	let contentView: PopButtonCustomContainerDrawable = PopButtonContainerView.Model(attributedTitle: nil, leftImage: UIImage(named: "arrow_image"), leftImageScale: 2.25)
	button.configureButtonContent(withModel: contentView)
```

## PopFloatingButton 

`PopFloatingButton` is a pop button with shadow exhibiting a floating effect.

use ``PopFloatingButton.Model`` to configure the button parameters.

```swift	
	//Create button config model.
	let model = PopFloatingButton.Model(buttonColor: UIColor.yellow, edgeWidth: 10, shimmerModel: PopShimmerModel(spacing: 10, lineColor1: UIColor.white, lineColor2: UIColor.white, lineWidth1: 10, lineWidth2: 25, duration: 2, delay: 5))
	//configure the button.
	button.configureFloatingButton(withModel: model)

	//Setup custom container model
	let contentView: PopButtonCustomContainerDrawable = PopButtonContainerView.Model(attributedTitle: nil, rightImage: UIImage(named: "some image"), rightImageScale: 4.81)
	button.configureButtonContent(withModel: contentView)
	//Starting shimmer animation.
	button.startShimmerAnimation() 
```

