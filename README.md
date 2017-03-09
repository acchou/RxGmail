# RxGmail

[![CI Status](http://img.shields.io/travis/Andy Chou/RxGmail.svg?style=flat)](https://travis-ci.org/Andy Chou/RxGmail)
[![Version](https://img.shields.io/cocoapods/v/RxGmail.svg?style=flat)](http://cocoapods.org/pods/RxGmail)
[![License](https://img.shields.io/cocoapods/l/RxGmail.svg?style=flat)](http://cocoapods.org/pods/RxGmail)
[![Platform](https://img.shields.io/cocoapods/p/RxGmail.svg?style=flat)](http://cocoapods.org/pods/RxGmail)

RxGmail provides a thin [RxSwift][] wrapper around Gmail's Objective-C
API. Requests return an Observable<T> that can be transformed with a powerful set
of [operators][].

## Usage

Create an RxGmail object by passing in a `GTLRGmailService` object:

```swift
let gmailService = GTLRGmailService()
var rxGmail = RxGmail(gmailService: gmailService))
```

If you use Google Sign-In to authenticate, you'll need to pass in an
appropriate authorization scope. The authorization scope specifies what
permissions the user is granting to your app when they login. Without the
proper scope, the Gmail API will reject your API requests.

```swift
// Typical Google Sign-In setup
let signIn = GIDSignIn.sharedInstance()!
signIn.delegate = self

// Request an authorization scope the includes the Gmail API.
let scopes: NSArray = signIn.scopes as NSArray? ?? []

// This scope only allows for read-only API calls.
let requiredScopes = [kGTLRAuthScopeGmailReadonly]

// Add requested scopes to existing scopes.
signIn.scopes = scopes.addingObjects(from: requiredScopes)
```

RxGmail provides requests that return `Observable`s of Gmail API responses:

```swift
// Get all of the user's mailbox labels
let labels = rxGmail.listLabels()   // Observable<LabelsListResponse>
    .map { $0.labels }              // Observable<[Label]?>
    .unwrap()                       // Observable<[Label]>
    .map { $0.name }                // Observable<[String]>
    .shareReplay(1)                 // Share response values for all observers
```

## Example App

The Example app is a simple read-only email client that allows you to navigate
labels, threads, message lists, and messages.


1. Sign up for [Google Sign-In][]. This enables authentication for the example
   app. You only need to perform the step "Get a configuration file".

2. Turn on the [Gmail API][]. Do not follow all of the instructions (which are
   for a quickstart project, not this project). Just follow the wizard link to
   automatically turn on the Gmail API, and create a project to use for
   testing. Click cancel when prompted to add a crendential.
   
3. Copy the `GoogleService-Info.plist` file from step 1 into the directory
   `Example/RxGmail/`.

4. In this step we'll add some Google service identifiers to a custom Xcode
   configuration file. This file captures your service-specific details that
   are used in the Xcode project configuration, so they that are not checked
   into the repository. Copy the template file
   `Example/RxGmail/debug.xcconfig.template` to `debug.xcconfig` in the same
   directory. Fill in these values:
   
   `GOOGLE_CLIENT_ID` should be set to the value of
   `CLIENT_ID` from `GoogleService-Info.plist`. It has the form:
   
     `GOOGLE_CLIENT_ID = xxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com`

   `GOOGLE_REVERSED_CLIENT_ID` should be set to the value of
   `REVERSED_CLIENT_ID` from `GoogleService-Info.plist`. It is used as a URL
   type: select the Info tab on the project's target, and expand the URL Types
   section to see its usage, which fulfills the
   [Google sign-in URL Type][]. It should have the form:
   
     `GOOGLE_REVERSED_CLIENT_ID = com.googleusercontent.apps.xxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
   
5. Run `pod install` from the Example directory.

6. Open the file `Example/RxGmail/RxGmail.xcworkspace` with Xcode and it should build and run.

## Requirements

## Installation

RxGmail is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "RxGmail"
```

## Author

Andy Chou, acchou4@gmail.com

## License

RxGmail is available under the MIT license. See the LICENSE file for more info.


[RxSwift]: https://github.com/ReactiveX/RxSwift
[operators]: http://reactivex.io/documentation/operators.html
[Google Sign-In]: https://developers.google.com/identity/sign-in/ios/start-integrating
