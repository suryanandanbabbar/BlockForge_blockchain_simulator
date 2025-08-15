//
//  Block.swift
//  BlockchainSimulator
//
//  Created by Suryanandan Babbar on 11/08/25.
//

import Foundation
import CryptoKit

struct Block: Identifiable, Codable {
    let id: String
    let index: Int
    let previousHash: String
    let timestamp: Date
    let transactions: [Transaction]
    var nonce: UInt64
    var hash: String
    let difficulty: Int
    
    init(index: Int, previousHash: String, transactions: [Transaction], difficulty: Int) {
        self.id = UUID().uuidString
        self.index = index
        self.previousHash = previousHash
        self.timestamp = Date()
        self.transactions = transactions
        self.nonce = 0
        self.difficulty = difficulty
        self.hash = Block.computeHash(index: index, previousHash: previousHash, timestamp: Date(), transactions: transactions, nonce: 0, difficulty: difficulty)
    }
    
    static func computeHash(index: Int, previousHash: String, timestamp: Date, transactions: [Transaction], nonce: UInt64, difficulty: Int) -> String {
        let txData = transactions.map { "\($0.id)\($0.from)\($0.to)\($0.amount)\($0.timestamp.timeIntervalSince1970)" }.joined()
        let input = "\(index)\(previousHash)\(timestamp.timeIntervalSince1970)\(txData)\(nonce)\(difficulty)"
        let digest = SHA256.hash(data: Data(input.utf8))
        return Data(digest).hexString
    }
    
    mutating func recalcHash() {
        self.hash = Block.computeHash(index: index, previousHash: previousHash, timestamp: timestamp, transactions: transactions, nonce: nonce, difficulty: difficulty)
    }
    
    func isValidProof() -> Bool {
        // check hash has required leading zeros per difficulty
        let prefix = String(repeating: "0", count: difficulty)
        return hash.hasPrefix(prefix)
    }
}

