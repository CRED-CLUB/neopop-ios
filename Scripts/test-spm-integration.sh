#!/bin/bash

set -e # Any subsequent(*) commands which fail will cause the shell script to exit immediately

PROJECT_NAME=TempProject

function clean_up {
  cd ../
  rm -rf $PROJECT_NAME
  echo "exited"
}

# Delete the temp folder if the script exited with error.
trap "clean_up" 0 1 2 3 6

# Clean up.
rm -rf $PROJECT_NAME

mkdir -p $PROJECT_NAME && cd $PROJECT_NAME

# Create the package.
swift package init

# Create the Package.swift.
echo "// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription
let package = Package(
    name: \"TempProject\",
    defaultLocalization: \"en-US\",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: \"TempProject\",
            targets: [\"TempProject\"]
        )
    ],
    dependencies: [
        .package(name: \"NeoPop\", path: \"../\"),
    ],
    targets: [
        .target(
            name: \"TempProject\",
            dependencies: [
                .product(name: \"NeoPop\", package: \"NeoPop\")
            ]
        )
    ]
)
" > Package.swift

swift package update

# Archive for generic iOS device
echo '############# Archive for generic iOS device ###############'
xcodebuild archive -scheme TempProject -destination 'generic/platform=iOS'

# Build for generic iOS device
echo '############# Build for generic iOS device ###############'
xcodebuild build -scheme TempProject -destination 'generic/platform=iOS'

# Archive for x86_64 simulator
echo '############# Archive for x86_64 simulator ###############'
xcodebuild archive -scheme TempProject -destination 'generic/platform=iOS Simulator' ARCHS=x86_64

# Build for x86_64 simulator
echo '############# Build for x86_64 simulator ###############'
xcodebuild build -scheme TempProject -destination 'generic/platform=iOS Simulator' ARCHS=x86_64
