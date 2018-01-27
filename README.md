# Straal

[![Twitter](https://img.shields.io/badge/twitter-@Straal_-blue.svg?style=flat)](http://twitter.com/straal_)
[![Travis](https://img.shields.io/travis/straal/straal-ios/master.svg?style=flat)](https://travis-ci.org/straal/straal-ios)
![Platforms](https://img.shields.io/badge/platforms-iOS-blue.svg)
[![pod](https://img.shields.io/cocoapods/v/Straal.svg)](https://cocoapods.org/pods/Straal)
[![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

> Straal SDK for iOS written in Swift.
> A brilliant payment solution for disruptive businesses.

- [Features](#features)
- [Requirements](#requirements)
  - [Backend](#backend)
- [Installation](#installation)
- [Usage](#usage)
  - [Overview](#Overview)
  - [Initial configuration](#initial-configuration)
  - [Operations](#operations)
    - [Create card](#create-card)
    - [Create transaction with a card](#create-transaction-with-card)
  - [Validation](#valdation)
- [Support](#support)
- [Licence](#licence)

## Features

> Straal for iOS is a helper library to make it easier
  to make API requests directly from merchant's mobile iOS App.
  It utilizes client-side encryption and sends data
  over HTTPS to make secure requests creating transactions and adding cards.

## Requirements

Straal SDK requires deployment target of **iOS 9.0+** and Xcode **8.0+**.

### Backend

You also need a backend service which will handle payment information and issue `CryptKeys` for the app. For more see [here](https://api-reference.straal.com).

You backend service needs to implement **at least one endpoint** at *https://_base_url_/straal/v1/cryptkeys*. This endpoint is used by this SDK to fetch cryptkeys that encrypt sensitive user data.

> It is your backend's job to authorize the user and reject the cryptkey fetch if need be.

## Installation

We recommend using *CocoaPods*

Add the following lines to your **Podfile**:

```ruby
pod 'Straal',    '~> 0.1.0'
```

Then run `pod install`.

## Usage

### Overview

To use [Straal](https://straal.com/) for iOS you need an iOS (in which you want to accept payments), as well as you own backend service.

This SDK let's you implement a secure payment process in your app. User's sensitive data (as credit card numbers) is sent directly from mobile application, so no card data will hit your servers, which results in improved security and fewer PCI compliance requirements.

The security of this process is ensured by a `CryptKey` mechanism. Your merchant backend service is responsible for **authorizing** the app user for a specific CryptKey operation. This is done via `headers` in configuration.

### Initial configuration

First, create a `StraalConfiguration` object (which consists of your Merchant URL and **authorization headers**). Then you create your `Straal` object using the configuration.

```swift
let url = URL(string: "https://my-merchant-backen-url.com")!
let headers = ["x-user-token": myUserToken] // You have to authorize your user on cryptkeys endpoint using this header!
let configuration = StraalConfiguration(baseUrl: url, headers: headers)
let straal = Straal(configuration: configuration)
```

> Note: Once your app needs to change the authorization headers (user logs out or in), you need to create a new Straal object. Neither Straal nor StraalConfiguration objects are meant to be reused or changed.

Once you have your `Straal` object, you can submit `Operations` to it.

#### Create a card

The first operation is `CreateCard` operation.

```swift
//You should get those from your UI inputs
let name = CardholderName(fullName: "John Appleseed")
let cvv = CVV(rawValue: "000")
let expiry = Expiry(month: "04", year: "2021")
let number = CardNumber(rawValue: "5555 5555 5555 4444")

//Now create a card object. You can optionally validate a card.
let card = Card(name: name, number: number, cvv: cvv, expiry: expiry)

// Create a card create operation
let createCardOperation = CreateCard(card: card)

// Now you can submit the operation for execution
straal.perform(operation: createCardOperation) { (response, error) in
  // handle error and react to the response
}
```

> Note what happens under the hood when you call this last method. First, your merchant backend is fetched on `cryptkeys` endpoint with this `POST` request:

```json
{
  "permission": "v1.cards.create"
}
```

Your backend's job is to authenticate this request (using headers passed to `StraalConfiguration`), append this json with `customer_uuid` key-value pair and forward it to Straal using [this method](https://api-reference.straal.com/#resources-cryptkeys-create-a-cryptkey).

Then, the credit card data is encrypted, sent to Straal directly, processed by Straal, and responded to.

#### Create transaction with a card

The second supported operation is `CreateTransactionWithCard`.

```swift
let card = ...
let transaction = Transaction(amount: 200, currency: "usd", reference: "order:92830948i98y")!
let transactionWithCardOperation = CreateTransactionWithCard(card: card, transaction: transaction)

straal.perform(operation: transactionWithCardOperation) { (response, error) in
  // handle error and react to the response
}
```

> Again, we first fetch your `cryptkeys` endpoint to fetch a crypt key. This time with JSON like this:

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

> It is your backend's responsibility to verify the transaction amounts (possibly pairing it with an order using `reference`), and to authorize the user using request headers.

## Validation

> Coming soon

## Support

Any suggestions or reports of technical issues are welcome! Contact us via [email](mailto:devteam@straal.com).

## Licence

This library is released under Apache License 2.0. See [LICENSE](LICENSE).
