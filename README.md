# Mosaic

**Mosaic** makes it easy to create [Photographic mosaics](https://en.wikipedia.org/wiki/Photographic_mosaic) on still images or live video feeds.

## Demo

## Features
- [x] Fast: capable of processing live videos
- [x] Lightweight
- [x] Cheat mode

## Requirements

## Installation

## Usage
### Quick Start
The following steps give you a quick way to get started with **Mosaic**. It's not meant to be used as is, since errors are not properly handled.

For a more in depth example, please refer to the `Mosaic Sample App` included in this repository.

1. Get an array of `UIImage` instances. This is the image pool that will be used to populate the photo mosaic.
```swift
let images = [
    UIImage(named:"myImage_1.jpg")
    UIImage(named:"myImage_2.jpg")
    UIImage(named:"myImage_3.jpg")
    ...
]
```

2. Initialize a `Mosaic` instance, passing in the `UIImage` instances created in the previous step.
```swift
let mosaic = try! Mosaic(imagePool: images)
```

3. Finally, call the `generate()` function on the `Mosaic` instance previously created, and pass in the image (as a `CGImage`) that needs to be transformed into a photo mosaic.
```swift
let imageToTransform = UIImage(named:"myImage_4.jpg").cgImage!
let photoMosaic: UIImage = mosaic.generate(for: imageToTransform)
```

### Pre Heat
There are a number of expensive tasks that need to be done before a photo mosaic can be generated for the first time.

For example, the average color of each image in the image pool needs to be computed exactly once.

This means that once a `Mosaic` instance is initialized, calling the `generate()` function for the first time will take longer than the subsequent calls.

To prevent this, `Mosaic` provides the `preHeat()` function.
Use the `preHeat()` function when you know that there is a chance that a photo mosaic will be created in the future. This will ensure that the photo mosaic is created as fast as possible.

```swift
let mosaic = try! Mosaic(imagePool: images)
mosaic.preHeat()
```

### Cheat Mode
It can be challenging to come up with enough images for the image pool.
Indeed, for the photo mosaic to work well, the image pool needs a wide variety of images of different dominant colors.

Thankfully, **Mosaic** comes with a cheat mode!
It is represented by an enum with the following values:
- `enabled`: **Mosaic** will actively complete the image pool by generating new images close to the colors that are missing. It does so by adding an overlay on the image closest to the desired color. It will do so only for colors that are not already represented in the image pool.

<p align="center"><img src="https://github.com/Boris-Em/Mosaic/blob/master/Assets/Mosaic_Cheat.jpg"/></p>

<p align="center"><i> If the image pool doesn't contain any image with a blue average color, enabling cheating will generate a new image with a blue overlay. </i></p>

- `automatic` (default): **Mosaic** will try to determine if it should cheat.
- `disabled`: **Mosaic** will use the image pool as is. This is recommended when you have an image pool with a wide variety of dominant colors.

To use a specific cheat mode instead of the default one (`automatic`), simply pass a value when initializing a `Mosaic` instance.

```swift
Mosaic(imagePool: images, cheatDecision: .enabled)
```

## How It Works

**Mosaic** takes an image to transform into a mosaic, as well as a pool of images. It recreates the image to transform using the pool of images.

<p align="center"><img src="https://github.com/Boris-Em/Mosaic/blob/master/Assets/Mosaic_Diagram.jpg"/></p>	

## Contributing

## Communication

## License