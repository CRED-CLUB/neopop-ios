# NeoPop
![enter image description here](https://i.imgur.com/1gN3wzy.jpg)
NeoPop is CRED’s inbuilt library for using NeoPop components in your app.

What really is NeoPop? NeoPop was created with one simple goal, to create the next generation of the next beautiful, more affirmative, design system. neopop stays true to everything that design at CRED stands for.


## Installation

### CocoaPods


NeoPop is available through [CocoaPods](https://cocoapods.org). 
To install it, add the following line to your Podfile:

```ruby
pod 'neopop-ios'
```

### Swift Package Manager
Follow  [this doc](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app)  to add a new dependency to your project. If your  `Package.swift`  is already setup, add this line to project dependencies.

```ruby
dependencies: [
    .package(url: "https://github.com/CRED-CLUB/neopop-ios", from: "1.0.0")
],
```

## Requirements

-   iOS 11.0+
-   Swift 5.5+

# Usage

## PopView

`PopView` is a subclass of UIView, which can exhibit the Neopop effect.

The design of a `PopView` can be primarily classified with respect to the direction of viewing the `PopView`.
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
 
 `PopView.Model` holds the properties of a `PopView`, which helps you to customise the view with respect to your requirements.

`PopView.Model` can be initialised as follows.
```swift
let model = PopView.Model(
				popEdgeDirection: .bottomRight, 
				backgroundColor: UIColor.gray
			)
```    

Let's see some of the examples of drawing  a `PopView` with different `EdgeDirections`
- *topLeft*

![enter image description here](https://user-images.githubusercontent.com/72977449/175024211-4a36867f-d9c5-43d5-b52d-3c44c7b9a71b.png)

```swift
PopView.Model(
	popEdgeDirection: .topLeft, 
	backgroundColor: UIColor.black, 
	verticalEdgeColor: PopHelper.verticalEdgeColor(for: UIColor.green), 
	horizontalEdgeColor: PopHelper.horizontalEdgeColor(for: UIColor.green)
	)
```

 - *topRight*

 ![enter image description here](https://user-images.githubusercontent.com/72977449/175024585-e60e63b7-8642-4827-b98f-35cfb6d4dc85.png)
 
```swift
PopView.Model(
	popEdgeDirection: .topRight, 
	backgroundColor: UIColor.black, 
	verticalEdgeColor: PopHelper.verticalEdgeColor(for: UIColor.green), 
	horizontalEdgeColor: PopHelper.horizontalEdgeColor(for: UIColor.green)
	)
```

 - *bottomLeft*

 ![enter image description here](https://user-images.githubusercontent.com/72977449/175024721-5ccb8763-0170-480c-92bf-567dd11f5654.png)
 
```swift
PopView.Model(
	popEdgeDirection: .bottomLeft, 
	backgroundColor: UIColor.black, 
	verticalEdgeColor: PopHelper.verticalEdgeColor(for: UIColor.green), 
	horizontalEdgeColor: PopHelper.horizontalEdgeColor(for: UIColor.green)
	)
```

 - *bottomRight*

 ![enter image description here](https://user-images.githubusercontent.com/72977449/175024804-d7f7d8d3-106c-4014-a884-11c0771a6026.png)
 
```swift
PopView.Model(
	popEdgeDirection: .bottomRight, 
	backgroundColor: UIColor.black, 
	verticalEdgeColor: PopHelper.verticalEdgeColor(for: UIColor.green), 
	horizontalEdgeColor: PopHelper.horizontalEdgeColor(for: UIColor.green)
	)
```

similarly you can use other directions too.

##
 for more customisations you may use the properties of `PopView.Model`

**`PopView.Model` initialiser arguments**

| attribute  | description  | value | 
|--|--|--|
| `neoPopEdgeDirection`| Direction of edge of the pop view.  | EdgeDirection |
| `customEdgeVisibility`| Change the visibility of the available edges..  | EdgeVisibilityModel |
| `customBorderVisibility`| Change the visibility of the border.  | EdgeVisibilityModel |
| `edgeOffSet`| depth of the edge.  | CGFloat |
| `backgroundColor`| Background color of the view.  | UIColor |
| `verticalEdgeColor`| Color of the vertical edge in the view. (either of left/right). Optional input as it will be derived from bg color.  | UIColor |
| `horizontalEdgeColor`| Color of the horizontal edge in the view. (either of top/bottom). Optional input as it will be derived from bg color.  | UIColor |
| `verticalBorderColors`| Color of the vertical edge borders. (customisable for each side of the edge).  | EdgeColors |
| `horizontalBorderColors`| Color of the horizontal edge borders. (customisable for each side of the edge).  | EdgeColors |
| `clipsToOffSetWidth`| Whether clipping needs to be done to the horizontal edge (clipping poition options are available here).  | EdgeDirection |
| `clipsToOffSetHeight`| Whether clipping needs to be done to the vertical edge (clipping poition options are available here).  | EdgeDirection |
| `delegate`| Delegate to handle the callbacks. customisations in the drawing path can be achieved through this delegate.  | PopViewDrawable |
| `modelIdentifier`| Identifier for model/view for reference  | String? |
| `borderWidth`| width for the border.  | CGFloat |

## 

**Initialising a `PopView`**

You can create a `PopView` through code using the below approach.
```swift
let model = PopView.Model(
				popEdgeDirection: .bottomRight, 
				backgroundColor: UIColor.black
			)
let popView = PopView(
	frame: CGRect(x: 0, y: 0, width: 100, height: 100), 
	model: model
	)
```
apply Neopop effect on a neopop view as:
```swift
@IBOutlet private weak var popView: PopView!
    ...
let model = PopView.Model(
				popEdgeDirection: .bottomRight, 
				backgroundColor: UIColor.black
			)
popView.configurePopView(withModel: model)
```
There is also an extension created on `UIView`, which enables to apply Neopop Style in any existing `UIView` element,

```swift
var view: UIView!
let model = PopView.Model(
				popEdgeDirection: .bottomRight, 
				backgroundColor: UIColor.black
			)
view.applyNeoPopStyle(model: model)
```

# Buttons

## PopButton


![Frame 11181](https://user-images.githubusercontent.com/72977449/172914976-25860b42-9f0e-408e-8cf2-a444fa87e5b6.png)


The structure and the behaviour of a PopButton mainly depends on two parameters which are `EdgeDirection` & `PopButton.Position`.

`EdgeDirection` is the possible directions of viewing a 3-dimentional `PopButton`, 
which are :
 - *topLeft*
 - *topRight*
 - *bottomLeft*
 - *bottomRight*
 - *top*
 - *bottom*
 - *left*
 - *right*
 
 All the below examples are derives with `EdgeDirection` as `bottomRight`.

`PopButton.Position` is the possible positions of a `PopButton` when you place it in a 3-dimentional `PopView`,  like mentioned in this image:

![Group 11479-2](https://user-images.githubusercontent.com/72977449/175024978-ae5a6a24-6e3a-4973-9209-84fbcbc45077.png)

here 1-9 are the buttons placed at different possible positions of a popView.
which are  :

 1. *topLeft*
 2. *topEdge*
 3. *topRight*
 4. *leftEdge*
 5. *center*
 6. *rightEdge*
 7. *bottomLeft*
 8. *bottomEdge*
 9. *bottomRight*

 
`PopButton.Model` is an entity which holds the behavioural properties of a PopButton, which can help you to customise the PopButton w.r.t your requirements.
##
**Initialising a `PopButton.Model`** 
```swift
let model = PopButton.Model(
					position: .bottomRight, 
					backgroundColor: UIColor.gray
				)
```
The above case of buttons appearing on the different edges of a `PopView` is achieved only by changing the `PopButton.Position` in the `PopButton.Model`. 
(Please [refer the sample app](https://github.com/CRED-CLUB/neopop-ios/blob/80c7c906c129d99e7bb5eadc568913d7ea351f9d/NeoPopExamples/NeoPopExamples/Example%20Controllers/AdvancedButtonsViewController.swift#L83:L133) for this usage)
##
**Popular Styles of  `PopButton`**


 - *ELEVATED BUTTON*

 ![elevated_button](https://user-images.githubusercontent.com/72977449/175022154-67d60091-1847-464f-b02f-c8e018b1ad91.gif)

```swift
let elevatedButton = PopButton()
let model = PopButton.Model(
					position: .bottomRight, 
				backgroundColor: UIColor.white
				)
elevatedButton.configurePopButton(withModel: model)
```

 - *FLAT BUTTON*
 
![flat_button](https://user-images.githubusercontent.com/72977449/175022544-7f7ca1b2-cd8c-4393-9761-8fac87e14385.gif)

```swift
let flatButton = PopButton()
let model = PopButton.Model(
					position: .bottomRight, 
					backgroundColor: .white, 
					superViewColor: .black
				)
flatButton.configurePopButton(withModel: model)
```

 - *ELEVATED STROKE BUTTON*
 
 ![ele_stroke_btn](https://user-images.githubusercontent.com/72977449/175022674-8b3432d8-be13-4ba4-8601-14f15009d07b.gif)

```swift
let elevatedStrokeButton = PopButton()
let model = PopButton.Model(
				position: .bottomRight, 
				backgroundColor: .black, 
				buttonFaceBorderColor: EdgeColors(color: UIColor.white), 
				borderWidth: 0.31, 
				edgeLength: 1.87, 
				customEdgeColor: EdgeColors(left: nil, right: PopHelper.horizontalEdgeColor(for: UIColor.white), 
				top: nil, 
				bottom: PopHelper.verticalEdgeColor(for: UIColor.white))
				)
elevatedStrokeButton.configurePopButton(withModel: model)
```
 
-  *FLAT STROKE BUTTON*

![flat_stroke_btn](https://user-images.githubusercontent.com/72977449/175022798-9f112067-4de6-496f-b1e3-9763cd8f4c5a.gif)

```swift
let flatStrokeButton = PopButton()
let model = PopButton.Model(
					position: .bottomRight, 
					backgroundColor: .black, 
					buttonFaceBorderColor: EdgeColors(color: UIColor.white),  
					borderWidth: 0.31, 
					edgeLength: 1.87, 
					customEdgeColor: EdgeColors(left: nil, right: PopHelper.horizontalEdgeColor(for: UIColor.white), 
					top: nil, 
					bottom: PopHelper.verticalEdgeColor(for: UIColor.white))
				)
flatStrokeButton.configurePopButton(withModel: model)
```

##

For more customisations make use of the properties of `PopButton.Model` 

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
| `adjacentButtonAvailibity`| presence of the other button close the edges the current button.  | AdjacentButtonAvailability |
| `customEdgeColor`| customise the color of the edges.  | EdgeColors? |
| `edgeLength`| depth of the edges.  | CGFloat |
| `showStaticBaseEdges`| decides whether to draw borders at ethe bottom edges of the button.  | Bool |
| `shimmerStyle`| shimmer configurations.  | ShimmerStyle? |

##
**How to setup the Button content ?**

The content of a `PopButton` has a 
- an imageView on left
- a label
- an image view on right of the label

And you can set up a `PopButton` content through.
```swift
let contentModel = PopButtonContainerView.Model(
						attributedTitle: nil, 
						leftImage: UIImage(named: "arrow"), 
						leftImageScale: 3
					)
popButton.configureButtonContent(withModel: contentModel)
```
more customisations on these contents are available, for which please refer the `CustomButtonContainerView`.

##

We know, the content to show on a button surface differs varies with your usecases and design requirements.
So, all buttons in NeoPop framework is designed to accept a UIView confirming to the protocol `PopButtonCustomContainerDrawable`  as its contentView. That means, you can create any number of custom views w.r.t your requirements and use it on any buttons in Neopop framework.

`PopButtonCustomContainerDrawable` protocol will be listening to state changes of the owner button, such that you can also update the button content view (confirming `PopButtonCustomContainerDrawable`) w.r.t state changes.

```swift
class  ContainerNew: UIView, PopButtonCustomContainerDrawable {
    public let  titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    func updateOnStateChange(state: PopButton.State) {
        //Use this space to listen to button state changes
    }
}

let newContainer = ContainerNew()
newContainer.titleLabel.text = "Continue"
popButon.setCustomContainerView(container)
```

## PopFloatingButton 

`PopFloatingButton` is a pop button with shadow, exhibiting a floating effect.

![floating_button_press_animation](https://user-images.githubusercontent.com/72977449/175023303-5344bcb4-b40c-481d-862b-77a63854ba96.gif)

![enter image description here](https://i.postimg.cc/sDQFjqpy/Frame-11183.png)

use ``PopFloatingButton.Model`` to configure the button parameters.

```swift    
//Create button config model.
let model = PopFloatingButton.Model(
				backgroundColor: UIColor.yellow, 
				edgeWidth: 9, 
				shimmerModel: PopShimmerModel(
									spacing: 10, 
									lineColor1: UIColor.white, 
									lineColor2: UIColor.white, 
									lineWidth1: 16, 
									lineWidth2: 35, 
									duration: 2, 
									delay: 5
									)
				)	
//configure the button.
button.configureFloatingButton(withModel: model)

//Setup custom container model
let contentModel = PopButtonContainerView.Model(attributedTitle: nil, rightImage: UIImage(named: "play_now_text"), rightImageScale: 4.81)
button.configureButtonContent(withModel: contentModel)
	
//Starting shimmer animation.
button.startShimmerAnimation() 
```

post adding shimmer effect :
![shimmer_animation](https://user-images.githubusercontent.com/72977449/175023722-c548fa26-f5fa-42c7-b4b1-71305f08f3f6.gif)


## Contributing

Pull requests are welcome! We'd love help improving this library. Feel free to browse through open issues to look for things that need work. If you have a feature request or bug, please open a new issue so we can track it.

## Contributors

Neopop would not have been possible if not for the contributions made by CRED's design and frontend teams. 

Specifically:
- Yadhu Manoharan —  [Github](https://github.com/yadhu-cred) | [Linkedin](https://www.linkedin.com/in/yadhu-manoharan-92020083/)
- Somesh Karthik — [Github](https://github.com/SomeshKarthikK) | [Linkedin](https://www.linkedin.com/in/somesh-karthik-875aa3167/)
- Saranjith PK — [Github](https://github.com/saranjith-pk) | [Linkedin](https://www.linkedin.com/in/saranjithpk/)
- Harleen Singh — [Github](https://github.com/harleen-s) | [Linkedin](https://www.linkedin.com/in/harleen-20/)


## License

```
Copyright 2022 Dreamplug Technologies Private Limited

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
