# SwiftBaseX

Base encoding / decoding of any given alphabet using bitcoin style leading zero compression.

This is an rewrite of the multi base codec library [base-x](https://github.com/cryptocoinjs/base-x) from javascript to Swift.

## Installation

### Carthage

Add the following to your `Cartfile`

```ruby
github "uport-project/SwiftBaseX"
```

## Usage

To encode a `Data` object we include the `hexEncodedString()` and `base58EncodedString()` methods as an extension

```swift
import SwiftBaseX

let data: Data = ....
let encoded:String = data.hexEncodedString()
```

For cases where you need a full hex string without leading zero compression we've also included the following variation.

```swift
let encoded:String = data.fullHexEncodedString()
```

For `String` we include the `decodeHex()` and `decodeBase58()` methods as an extension.

```swift
import SwiftBaseX

let decoded: Data = "Cn8eVZg".decodeBase58()
```

