# RxGmail

[![CI Status](http://img.shields.io/travis/Andy Chou/RxGmail.svg?style=flat)](https://travis-ci.org/Andy Chou/RxGmail)
[![Version](https://img.shields.io/cocoapods/v/RxGmail.svg?style=flat)](http://cocoapods.org/pods/RxGmail)
[![License](https://img.shields.io/cocoapods/l/RxGmail.svg?style=flat)](http://cocoapods.org/pods/RxGmail)
[![Platform](https://img.shields.io/cocoapods/p/RxGmail.svg?style=flat)](http://cocoapods.org/pods/RxGmail)

## Example

Sign up for [Google Sign-In][]. This enables authentication for the example app
(it is not required to use RxGmail). You only need to perform the step "Get a configuration file". 



1. Turn on the [Gmail API][]. Do not follow all of the instructions (which are
   for a quickstart project, not this project). Just follow the wizard link to
   automatically turn on the Gmail API, and create a project to use for
   testing. Click cancel when prompted to add a crendential.

2. Add your cloud service details to `debug.xcconfig`. This file contains
   information that connects the project settings in this directory to cloud
   services. For example, Firebase Auth requires some changes to set a URL
   Type for Google login, and Facebook login requires changes to
   `Info.plist`. Instead of hard-coding settings like these into `Info.plist`,
   we use `debug.xcconfig` to store these settings locally. **This way your
   Firebase client ID and Facebook App ID are kept locally only, and never in
   the repository.** To create `debug.xcconfig`, copy
   `debug.xcconfig.template` and fill in these values:
   
   `GOOGLE_CLIENT_ID` should be set to the value of
   `CLIENT_ID` from `GoogleService-Info.plist`. It has the form:
   
     `GOOGLE_CLIENT_ID = XXXXXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.apps.googleusercontent.com`

   `GOOGLE_REVERSED_CLIENT_ID` should be set to the value of
   `REVERSED_CLIENT_ID` from `GoogleService-Info.plist`. It is used as a URL
   type: select the Info tab, and expand the URL Types section to see its
   usage, which fulfills the [Google sign-in URL Type][]. It should have the form:
   
     `GOOGLE_REVERSED_CLIENT_ID = com.googleusercontent.apps.XXXXXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`
   
   `FACEBOOK_APP_ID` can be found in the [Facebook developer console][]. Make
   sure you use the **App ID** you created for this testsuite, not another
   one. This should consist of digits only.
   
     `FACEBOOK_APP_ID = XXXXXXXXXXXXXXXX`
   
   `FACEBOOK_DISPLAY_NAME` is the name of Facebook App you created. If you
   followed these directions, it should be `SwiftFirebaseTests`:
   
     `FACEBOOK_DISPLAY_NAME = SwiftFirebaseTests`
     
  `GMAIL_TEST_ACCOUNT` should be a gmail account used only for testing purposes:
  
     `GMAIL_TEST_ACCOUNT = XXXXX@gmail.com`
   
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

RxGmail is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "RxGmail"
```

## Author

Andy Chou, acchou2@gmail.com

## License

RxGmail is available under the MIT license. See the LICENSE file for more info.

[Google Sign-In]: https://developers.google.com/identity/sign-in/ios/start-integrating
