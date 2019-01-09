# ReactiveMetal
ReactiveSwift + Metal

Image Processing with Metal
API was inspired by BradLarson/GPUImage

Make strong references to these

let source = Camera()

let filter = LuminanceFilter() + RGBFilter(red: 0.1, green: 0.2, blue: 0.3) // Filter is 

let target = RenderView()

filter <-- source
target <-- filter

Installation via Carthage
github "kananats/ReactiveMetal" "master"

Project > Targets > Build Settings > Metal Compiler - Build Options > Header Search Paths
$(SRCROOT)/Carthage/Build/iOS/ReactiveMetal.framework/Headers
