# StegaImg

Image Steganography built using Flutter and Dart.

Support for Android and IOS only for now.
Tested on Android & IOS.

## Android

### Installation

Go to my [Releases page](https://github.com/SathvikTn/StegaImg/releases) and download & install the latest version.

## IOS

### Installation

Note: You need a system running mac os and Xcode and flutter installed in it.

To install Xcode (only in macos): 
- Download the latest version from [Apple developer website](https://developer.apple.com/download/all/?q=Xcode) (Preferred) 
or
- Download it from App Store directly.

To install Flutter in macos: 
- Follow steps provided in [Flutter macos doc](https://docs.flutter.dev/get-started/install/macos).

Step 1: Clone this repo to your mac.

Step 2: In Xcode, open Runner.xcworkspace present in StegaImg/stegaimg/ios folder. More info on [Flutter dev doc](https://docs.flutter.dev/deployment/ios#review-xcode-project-settings)

Step 3: Connect your iphone or ipad to the mac system.

Step 4: In Xcode, select the current scheme from the toolbar and click "Edit Schemes". More about [running app](https://developer.apple.com/documentation/xcode/running-your-app-in-the-simulator-or-on-a-device) and [schemes](https://help.apple.com/xcode/mac/current/#/dev0bee46f46)

Step 5: Select "Run" from left menu bar and Under "Info", "Build Configuration" should be set to "Release" and uncheck "Debug executable".

Step 6: Back to Runner, Select scheme and make sure your device is visible and selected.

Step 7: Press the play button to run the app.

Step 8: Make sure to allow permissions to install. You will encounter an error states "Untrusted Developer, Your device management settings does not allow using an app from ME on this iPhone. You can allow using these apps in Settings". To resolve this, (for iOS 15.2) Settings > General > VPN & Device Management > select the profile to trust. More on [this](https://developer.apple.com/forums/thread/660288).

Step 9: Try to re-run the app again from Xcode and Done.

## Reference

- [Photochat](https://github.com/tianhaoz95/photochat)

- [IOS Deployment](https://docs.flutter.dev/deployment/ios)
