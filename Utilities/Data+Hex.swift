//
//  Data+Hex.swift
//  BlockchainSimulator
//
//  Created by Suryanandan Babbar on 11/08/25.
//

import Foundation

extension Data {
    var hexString: String {
        self.map { String(format: "%02x", $0) }.joined()
    }
}

extension String {
    var dataFromHex: Data? {
        var data = Data()
        var temp = self
        if temp.count % 2 != 0 { temp = "0" + temp }
        var index = temp.startIndex
        while index < temp.endIndex {
            let nextIndex = temp.index(index, offsetBy: 2)
            let byteString = temp[index..<nextIndex]
            if let num = UInt8(byteString, radix: 16) {
                data.append(num)
            } else {
                return nil
            }
            index = nextIndex
        }
        return data
    }
}

