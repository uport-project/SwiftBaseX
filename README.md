# SwiftBaseX

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

For `String` we include the `decodeHex()` and `decodeBase58()` methods as an extension.

```swift
import SwiftBaseX

let decoded: Data = "Cn8eVZg".decodeBase58()
```

