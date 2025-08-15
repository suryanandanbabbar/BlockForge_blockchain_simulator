//
//  Transaction.swift
//  BlockchainSimulator
//
//  Created by Suryanandan Babbar on 11/08/25.
//

import Foundation

struct Transaction: Identifiable, Codable {
    let id: String
    let from: String
    let to: String
    let amount: Double
    let timestamp: Date
    
    init(from: String, to: String, amount: Double) {
        self.id = UUID().uuidString
        self.from = from
        self.to = to
        self.amount = amount
        self.timestamp = Date()
    }
}

