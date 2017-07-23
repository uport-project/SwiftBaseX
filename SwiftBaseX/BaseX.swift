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

let HEX = buildAlphabetBase("0123456789abcdef")
let BASE58 = buildAlphabetBase("123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz")

func encode (alpha:(map:[Character:UInt], indexed:[Character], base: UInt, leader: Character), data: Data) -> String {
    if data.count == 0 {
        return ""
    }
    var digits:[UInt] = [0]
    data.forEach {
        var carry = UInt($0)
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
    // for (var k = 0; data[k] === 0 && k < data.count - 1; k += 1) {
    //    output.append(alpha.leader)
    //}
    // convert digits to a string
    for d in digits.reversed() {
        output.append(alpha.indexed[Int(d)])
    }
    
    let final = output
    return final
}
/*
func decodeUnsafe (string) {
    if (string.length === 0) return Buffer.allocUnsafe(0)
    
    var bytes = [0]
    for (var i = 0; i < string.length; i++) {
        var value = ALPHABET_MAP[string[i]]
        if (value === undefined) return
        
        for (var j = 0, carry = value; j < bytes.length; ++j) {
            carry += bytes[j] * BASE
            bytes[j] = carry & 0xff
            carry >>= 8
        }
        
        while (carry > 0) {
            bytes.push(carry & 0xff)
            carry >>= 8
        }
    }
    
    // deal with leading zeros
    for (var k = 0; string[k] === LEADER && k < string.length - 1; ++k) {
        bytes.push(0)
    }
    
    return Buffer.from(bytes.reverse())
}

func decode (string) {
    var buffer = decodeUnsafe(string)
    if (buffer) return buffer
    
    throw new Error('Non-base' + BASE + ' character')
}
 */
