<p align="left">
    <img height=80 src="web/logo_github.png"/>
</p>

---

![Platform](https://img.shields.io/badge/platform-iOS-blue.svg?style=flat)
[![pod](https://img.shields.io/cocoapods/v/Straal.svg?style=flat)](https://cocoapods.org/pods/Straal)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg?style=flat)](LICENSE)
[![GitHub](https://github.com/straal/straal-ios/workflows/Build%20status/badge.svg?style=flat)](https://github.com/straal/straal-ios)
[![codebeat badge](https://codebeat.co/badges/73ab7e38-7c7e-4b48-8e20-376e04a93774?style=flat)](https://codebeat.co/projects/github-com-straal-straal-ios-master)
[![Language](https://img.shields.io/badge/Swift-5.3-FA7343.svg?logo=swift&style=flat)](https://swift.org/)
[![Twitter](https://img.shields.io/badge/twitter-@straal-blue.svg?style=flat)](http://twitter.com/straal_)

> Straal SDK for iOS written in Swift.
> A brilliant payment solution for disruptive businesses.

- [Features](#features)
- [Requirements](#requirements)
  - [Back end](#back-end)
  - [Return URL scheme](#return-url-scheme)
- [Installation](#installation)
  - [Cocoapods](#cocoapods)
  - [Carthage](#carthage)
  - [Swift Package Manager](#swift-package-manager)
- [Usage](#usage)
  - [Overview](#overview)
  - [Initial configuration](#initial-configuration)
  - [Operations](#operations)
    - [Create a card](#create-a-card)
    - [Create a transaction with a card](#create-a-transaction-with-a-card)
    - [Init 3D-Secure](#init-3d-secure)
  - [Validation](#validation)
- [Support](#support)
- [License](#license)

## Features

> Straal for iOS is a helper library to make it easier
  to make API requests directly from merchant's mobile iOS App.
  It utilizes client-side encryption and sends data
  over HTTPS to make secure requests creating transactions and adding cards.

## Requirements

Straal SDK requires deployment target of **iOS 13.0+** and Xcode **11.0+**.

### Back end

You also need a back-end service which will handle payment information and create `CryptKeys` for the app. For more, see [Straal API Reference](https://api-reference.straal.com).

Your back-end service needs to implement **at least one endpoint** at `https://_base_url_/straal/v1/cryptkeys`. This endpoint is used by this SDK to fetch `CryptKeys` that encrypt sensitive user data. To customize the path at which you fetch your `CryptKey`, you can use `StraalConfiguration`.

> It is your back end's job to authorize the user and reject the `CryptKey` fetch if necessary.

### Return URL Scheme

Our SDK performs external 3D-Secure user verification (it supports 3ds-v2). We need a way to return from user's browser (or any other verification banking app) to your application, once the transaction is verified. There are a few steps to configuring universal links in your app:

1. In Xcode, click on your project in the Project Navigator and navigate to App Target > Info
2. Under *URL Types* add a new type
3. Call it *Payment* (Identifier). Your *URL Scheme* is the most important part. Use a unique (globally) scheme. A good candidate is your app Bundle Identifier with a `.payments` suffix. So for example: `com.company.app.payments`.
4. That URL Scheme will now be handled by your app by iOS, so we will be able to redirect 3D-Secure operations back to the app.
5. Be sure to pass the exact same URL Scheme to `StraalConfiguration` when initializing it in runtime.

Then you need to let Straal know about external user activity during 3DS process. To do that, add a method to your `SceneDelegate`:

```swift
func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
  URLContexts.forEach { context in
    Straal.handle(context.url)
  }
}
```

Or if you're using Swift UI `App`, add an `onOpenURL` handler to your main `WindowGroup` view, like here:

```swift
var body: some Scene {
  WindowGroup {
    MyAwesomeView()
      .onOpenURL(perform: { url in
        Straal.handle(url)
      })
  }
}
```

This will allow Straal to close any `SFSafariViewController` View Controllers needed for 3DS processing.

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Straal into your project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'Straal', '~> 0.7.0'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

To integrate Straal into your project using Carthage, specify it in your `Cartfile`:

```ogdl
github "straal/straal-ios" ~> 0.7.0
```

Run `carthage update  --use-xcframeworks` to build the framework and drag the built `Straal.framework` into your Xcode project.

### Swift Package Manager

[Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift packages. It’s integrated with the Swift build system and Xcode.

To integrate Straal into your project using Swift Package Manager, add it to your Xcode project or to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/straal/straal-ios.git", .upToNextMajor(from: "0.7.0"))
]
```

## Usage

### Overview

To use [Straal](https://straal.com/) for iOS, you need your own back-end service and an iOS app which you want to use to accept payments.

This SDK lets you implement a secure payment process into your app. Your user's sensitive data (such as credit card numbers) is sent **directly** from the mobile application, so no card data will hit your servers. It results in improved security and fewer PCI compliance requirements.

The security of this process is ensured by a `CryptKey` mechanism. Your merchant back-end service is responsible for **authorizing** the app user for a specific `CryptKey` operation. This is done via `headers` in configuration.

### Initial configuration

First, create a `StraalConfiguration` object (which consists of your Merchant URL and **authorization headers**). Then, create your `Straal` object using the configuration.

You can also add additional `cryptKeyPath` which will be the URL at which we would fetch your backend service for a new crypt key. If you don't provide a value here, we'll use the default which is `https://_base_url_/straal/v1/cryptkeys`.

```swift
let url = URL(string: "https://your-merchant-backend-url.com")!
let returnURLScheme = "com.company.app.payments" // For more instructions see above
let headers = ["x-user-token": myUserToken] // You have to authorize your user on cryptkeys endpoint using this header!
let configuration = StraalConfiguration(baseUrl: url, returnURLScheme: returnURLScheme, headers: headers)
let straal = Straal(configuration: configuration)
```

> Note: Once your app needs to change the authorization headers (user logs out or in), you need to create a new `Straal` object. Neither `Straal` nor `StraalConfiguration` objects are meant to be reused or changed.

Once you have your `Straal` object, you can submit `Operations` to it.

### Operations

#### Create a card

The first operation is `CreateCard`.

```swift
//You should get those from your UI inputs
let name = CardholderName(fullName: "John Appleseed")
let cvv = CVV(rawValue: "000")
let expiry = Expiry(month: "04", year: "2021")
let number = CardNumber(rawValue: "5555 5555 5555 4444")

//Now create a card object. You can optionally validate a card.
let card = Card(name: name, number: number, cvv: cvv, expiry: expiry)

// Initialise a create card operation
let createCardOperation = CreateCard(card: card)

// Now you can submit the operation for execution
straal.perform(operation: createCardOperation) { (response, error) in
  // handle error and react to the response
}
```

> Note what happens under the hood when you call this last method. First, your merchant back end is fetched on `cryptkeys` endpoint with this `POST` request:

```json
{
  "permission": "v1.cards.create"
}
```

Your back end's job is to authenticate this request (using headers passed to `StraalConfiguration`), append this JSON with `customer_uuid` key-value pair and forward it to Straal using [this method](https://api-reference.straal.com/#resources-cryptkeys-create-a-cryptkey).

Then, the credit card data is encrypted, sent to Straal directly, processed by Straal, and responded to.

#### Create a transaction with a card

The second supported operation is `CreateTransactionWithCard`.

```swift
let card = ...
let transaction = Transaction(amount: 200, currency: "usd", reference: "order:92830948i98y")!
let transactionWithCardOperation = CreateTransactionWithCard(card: card, transaction: transaction)

straal.perform(operation: transactionWithCardOperation) { (response, error) in
  // handle error and react to the response
}
```

> Again, we first fetch your `cryptkeys` endpoint to fetch a `CryptKey`. This time with JSON:

```json
{
  "permission": "v1.transactions.create_with_card",
  "transaction": {
    "amount": 200,
    "currency": "usd",
    "reference": "order:92830948i98y"
  }
}
```

> It is your back end's responsibility to verify the transaction amount (possibly pairing it with an order using `reference`), and to authorize the user using request headers.

#### Init 3D-Secure

The third supported operation is `Init3DS`.
```swift

/// First, create a Card and a Transaction.
let card: Card = ...
let transaction: Transaction = Transaction(amount: 200, currency: "usd")!
let init3DSOperation = Init3DSOperation(card: card, transaction: transaction) { [weak self] controller in
  // This will be called when 3DS is initiated by Straal. Present the controller (UIViewController) passed by Straal to the user, whichever way suits your workflow and design pattern.
  self?.present(controller, animated: true)
} dismiss3DSViewController: { controller in
  // This will be called when 3DS is completed. Do not rely on this method being called, as the viewcontroller can be dismissed in other ways (when cancelled by the user)
  controller.dismiss(animated: true, completion: nil)
}
straal.perform(operation: operation) { (response, error) in
  // This will be called once the user completes 3DS and the controller dismisses, or cancels it.
  // This does NOT mean that the transaction succeeded. It indicates the success or failure of 3DS itself.
  // You must communicate with your backend service to be informed about trasaction status (it still needs to be completed)
  // TODO: Handle the response and error
}
```

> Again, we first fetch your `cryptkeys` endpoint to fetch a `CryptKey`. This time with JSON:

```json
{
  "permission": "v1.customers.authentications_3ds.init_3ds",
  "transaction": {
    "amount": 200,
    "currency": "usd",
    "success_url": "https://your-merchant-backend-url/x-callback-url/straal/success",
    "failure_url": "https://your-merchant-backend-url/x-callback-url/straal/failure"
  }
}
```

The failure and success urls are scanned for by 3DS view controller, so please don't change them, as we will not be able to dismiss it.

> It is your back end's responsibility to verify the transaction amount (possibly pairing it with an order using `reference`), and to authorize the user using request headers.

## Validation

> Coming soon

## Support

Any suggestions or reports of technical issues are welcome! Contact us via [email](mailto:devteam@straal.com).

## License

This library is released under Apache License 2.0. See [LICENSE](LICENSE) for more info.
