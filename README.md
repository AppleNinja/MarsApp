# MarsApp

A Swift iOS app showcasing a gallery of Mars images using the NASA Image and Video Library API. This app demonstrates the ability to fetch and display images along with their descriptions and creation dates.

## Features

- Displays a gallery of Mars images.
- Each image card shows the image, description, and the date the image was created.
- Built with offline capabilities—images are cached for offline viewing using CoreData.

## Getting Started

- Clone the repo:
- Navigate to the project directory:
- Install the necessary CocoaPods:
- Open the `MarsApp.xcworkspace` file in Xcode to view the project.

## Architectural Pattern

- Implemented using the MVVM (Model-View-ViewModel) Clean architecture to ensure clean separation of concerns and enhance maintainability.

## Application Flow

- **GalleryViewController**: The starting point of the app, presenting a gallery of Mars images.
- Each image is displayed as a card with an image fetched using the Kingfisher library for asynchronous loading.

## Pods Integrated

- **Kingfisher**: Used for efficient and cacheable image loading.

## Supports

- iOS 17 and above.
- Optimized for iPhone 14 Pro and iPhone 15 Pro.
- Light and Dark mode support.

## Tests

- **XCTest** is used for unit and UI testing to ensure the app meets its functional requirements and handles expected and unexpected user interactions gracefully.

## How to run the tests

- Open the `MarsApp.xcworkspace` in Xcode.
- Press `⌘ + U` or navigate to Product -> Test to execute the test cases.
- View the test report in the Xcode Report Navigator to check test outcomes and coverage.

## Notes for Reviewers

- Please ensure to run `pod install` before building the project as it includes the Kingfisher library for image loading.
- The project has been developed and tested using Xcode 5.4 on iOS 18, targeting iPhone 14 Pro and iPhone 15 Pro devices.

## Additional Notes

Given more time, the following enhancements could be made:
- Adding more interactive elements to the UI such as zooming and sharing options for images.
- Implementing more comprehensive error handling to manage API limits and connectivity issues.

## Tools Used

- macOS Sequoia 15.3
- Xcode 5.4
- Swift 5
- iOS 18 SDK
- iPhone 14 Pro and iPhone 15 Pro for testing
