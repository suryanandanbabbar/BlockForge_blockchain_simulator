//
//  Blockchain.swift
//  BlockchainSimulator
//
//  Created by Suryanandan Babbar on 11/08/25.
//

import Foundation
import CryptoKit

class Blockchain: ObservableObject {
    @Published private(set) var chain: [Block] = []
    @Published var pendingTransactions: [Transaction] = []
    @Published var difficulty: Int = 3
    @Published var miningReward: Double = 10.0
    
    init() {
        createGenesisBlock()
    }
    
    private func createGenesisBlock() {
        let genesis = Block(index: 0, previousHash: "0", transactions: [], difficulty: difficulty)
        chain = [genesis]
    }
    
    var lastBlock: Block {
        chain.last!
    }
    
    func addTransaction(_ tx: Transaction) {
        pendingTransactions.append(tx)
    }
    
    func minePendingTransactions(minerAddress: String, progressHandler: ((UInt64, String) -> Void)? = nil, completion: @escaping (Block) -> Void) {
        let index = lastBlock.index + 1
        let previousHash = lastBlock.hash
        // reward transaction to miner
        let rewardTx = Transaction(from: "SYSTEM", to: minerAddress, amount: miningReward)
        var blockTxs = pendingTransactions
        blockTxs.append(rewardTx)
        
        // create mutable block
        var block = Block(index: index, previousHash: previousHash, transactions: blockTxs, difficulty: difficulty)
        
        DispatchQueue.global(qos: .userInitiated).async {
            var nonce: UInt64 = 0
            let targetPrefix = String(repeating: "0", count: self.difficulty)
            while true {
                block.nonce = nonce
                block.recalcHash()
                if nonce % 1000 == 0 {
                    DispatchQueue.main.async {
                        progressHandler?(nonce, block.hash)
                    }
                }
                if block.hash.hasPrefix(targetPrefix) {
                    // found a valid nonce
                    DispatchQueue.main.async {
                        self.chain.append(block)
                        self.pendingTransactions.removeAll()
                        completion(block)
                    }
                    break
                }
                nonce += 1
                // a tiny cooperative yield to prevent full CPU hogging
                if nonce % 10000 == 0 { Thread.sleep(forTimeInterval: 0.0001) }
            }
        }
    }
    
    func isChainValid() -> Bool {
        for i in 1..<chain.count {
            let current = chain[i]
            let previous = chain[i - 1]
            if current.previousHash != previous.hash {
                return false
            }
            let recalculated = Block.computeHash(index: current.index, previousHash: current.previousHash, timestamp: current.timestamp, transactions: current.transactions, nonce: current.nonce, difficulty: current.difficulty)
            if current.hash != recalculated {
                return false
            }
            if !current.isValidProof() {
                return false
            }
        }
        return true
    }
    
    func balanceOfAddress(_ address: String) -> Double {
        var balance: Double = 0
        for block in chain {
            for tx in block.transactions {
                if tx.from == address {
                    balance -= tx.amount
                }
                if tx.to == address {
                    balance += tx.amount
                }
            }
        }
        // pending transactions
        for tx in pendingTransactions {
            if tx.from == address {
                balance -= tx.amount
            }
            if tx.to == address {
                balance += tx.amount
            }
        }
        return balance
    }
}

