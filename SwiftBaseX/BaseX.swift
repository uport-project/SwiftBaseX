//
//  BaseX.swift
//  SwiftBaseX
//
//  Created by Pelle Steffen Braendgaard on 7/22/17.
//  Copyright © 2017 Consensys AG. All rights reserved.
//

import Foundation


func buildAlphabetBase(_ alphabet: String) -> (map: [Character:UInt], indexed: [Character], base: UInt, leader: Character) {
    let characters = alphabet.characters
    let indexed:[Character] = characters.map {$0}
    var tmpMap = [Character:UInt]()
    var i:UInt = 0
    for c in characters {
        tmpMap[c] = i
        i+=1
    }
    
    let finalMap = tmpMap
    return (map: finalMap, indexed: indexed, base: UInt(characters.count), leader: characters.first!)
}

public let HEX = buildAlphabetBase("0123456789abcdef")
public let BASE58 = buildAlphabetBase("123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz")

public func encode (alpha:(map:[Character:UInt], indexed:[Character], base: UInt, leader: Character), data: Data) -> String {
    if data.count == 0 {
        return ""
    }
    let bytes = [UInt8](data)
    
    var digits:[UInt] = [0]
    for byte in bytes {
        var carry = UInt(byte)
        for j in 0..<digits.count {
            carry += digits[j] << 8
            digits[j] = carry % alpha.base
            carry = (carry / alpha.base) | 0
        }
        while (carry > 0) {
            digits.append(carry % alpha.base)
            carry = (carry / alpha.base) | 0
        }
    }
    
    var output: String = ""
    // deal with leading zeros
    for k in 0..<data.count {
        if (bytes[k] == UInt8(0)) {
            output.append(alpha.leader)
        } else {
            break
        }
    }
    // convert digits to a string
    for d in digits.reversed() {
        output.append(alpha.indexed[Int(d)])
    }
    
    let final = output
    return final
}

public func decode (alpha:(map:[Character:UInt], indexed:[Character], base: UInt, leader: Character), data: String) -> Data {
    if data.isEmpty {
        return Data()
    }
    var bytes:[UInt8] = [0]
    let characters = data.characters
    for c in characters {
        var carry = alpha.map[c]!

        for j in 0..<bytes.count {
            carry += UInt(bytes[j]) * alpha.base
            bytes[j] = UInt8(carry & 0xff)
            carry >>= 8
        }
        
        while (carry > 0) {
            bytes.append(UInt8(carry & 0xff))
            carry >>= 8
        }
    }
    
    // deal with leading zeros
    for k in 0..<characters.count {
        if (data[data.index(data.startIndex, offsetBy: k)] == alpha.leader) {
            bytes.append(0)
        } else {
            break
        }
    }
    
    return Data(bytes.reversed())
}

public extension Data {
    public func hexEncodedString() -> String {
        return encode(alpha:HEX, data: self)
    }

    public func base58EncodedString() -> String {
        return encode(alpha:BASE58, data: self)
    }
}

public extension String {
    public func decodeHex() -> Data {
        return decode(alpha:HEX, data: self)
    }
    
    public func decodeBase58() -> Data {
        return decode(alpha:BASE58, data: self)
    }
}

