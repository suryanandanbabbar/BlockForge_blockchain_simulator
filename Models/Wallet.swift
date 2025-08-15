//
//  Wallet.swift
//  BlockchainSimulator
//
//  Created by Suryanandan Babbar on 11/08/25.
//

import Foundation
import CryptoKit

struct Wallet: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let address: String
    
    init(name: String) {
        self.id = UUID().uuidString
        self.name = name
        // simple address: SHA256 of UUID + name
        let seed = "\(UUID().uuidString)-\(name)-\(Date().timeIntervalSince1970)"
        let digest = SHA256.hash(data: Data(seed.utf8))
        self.address = Data(digest).hexString.prefix(16).lowercased().description
    }
}

