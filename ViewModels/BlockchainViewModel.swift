//
//  BlockchainViewModel.swift
//  BlockchainSimulator
//
//  Created by Suryanandan Babbar on 11/08/25.
//

import Foundation
import Combine

class BlockchainViewModel: ObservableObject {
    @Published var blockchain = Blockchain()
    @Published var wallets: [Wallet] = []
    @Published var selectedMinerWalletID: String?
    @Published var miningNoncePreview: UInt64 = 0
    @Published var miningHashPreview: String = ""
    @Published var isMining: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // pre-seed with two wallets for convenience
        let w1 = Wallet(name: "Alice")
        let w2 = Wallet(name: "Bob")
        wallets = [w1, w2]
    }
    
    func createWallet(name: String) -> Wallet {
        let w = Wallet(name: name)
        wallets.append(w)
        return w
    }
    
    func sendTransaction(from fromAddr: String, to toAddr: String, amount: Double) -> Bool {
        // minimal validation
        let balance = blockchain.balanceOfAddress(fromAddr)
        guard amount > 0 else { return false }
        guard balance >= amount else { return false }
        let tx = Transaction(from: fromAddr, to: toAddr, amount: amount)
        blockchain.addTransaction(tx)
        return true
    }
    
    func startMining(with minerAddress: String?, completion: @escaping (Block) -> Void) {
        guard let miner = minerAddress ?? wallets.first?.address else {
            return
        }
        isMining = true
        blockchain.minePendingTransactions(minerAddress: miner, progressHandler: { [weak self] nonce, hash in
            self?.miningNoncePreview = nonce
            self?.miningHashPreview = hash
        }, completion: { [weak self] block in
            self?.isMining = false
            self?.miningNoncePreview = block.nonce
            self?.miningHashPreview = block.hash
            completion(block)
        })
    }
    
    func changeDifficulty(to value: Int) {
        blockchain.difficulty = max(1, min(value, 6)) // cap difficulty lightly
    }
}

