//
//  ContentView.swift
//  BlockchainSimulator
//
//  Created by Suryanandan Babbar on 11/08/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = BlockchainViewModel()
    @State private var showCreateWallet = false
    @State private var showSendTx = false
    @State private var minerSelection: Int = 0
    var body: some View {
        NavigationView {
            VStack {
                // Controls
                HStack(spacing: 12) {
                    Button(action: { showCreateWallet = true }) {
                        Label("New Wallet", systemImage: "plus.circle")
                    }
                    Button(action: { showSendTx = true }) {
                        Label("Send Tx", systemImage: "indianrupeesign.circle")
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Difficulty: \(vm.blockchain.difficulty)")
                        Slider(value: Binding(get: {
                            Double(vm.blockchain.difficulty)
                        }, set: { newVal in
                            vm.changeDifficulty(to: Int(newVal.rounded()))
                        }), in: 1...6, step: 1)
                            .frame(width: 160)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Wallet balances and miner selection
                VStack {
                    HStack {
                        Text("Miner:").bold()
                        Picker("Miner", selection: $minerSelection) {
                            ForEach(0..<max(1, vm.wallets.count), id: \.self) { i in
                                Text(vm.wallets.indices.contains(i) ? vm.wallets[i].name : "None").tag(i)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        Spacer()
                        Button(action: {
                            let minerAddr = vm.wallets.indices.contains(minerSelection) ? vm.wallets[minerSelection].address : nil
                            vm.startMining(with: minerAddr) { block in
                            }
                        }) {
                            if vm.isMining {
                                Label("Mining...", systemImage: "bolt.fill")
                            } else {
                                Label("Mine Block", systemImage: "hammer.fill")
                            }
                        }
                    }
                    .padding(.horizontal)
                    HStack {
                        Text("Nonce: \(vm.miningNoncePreview)")
                        Spacer()
                        Text(vm.miningHashPreview.prefix(10) + "...")
                    }
                    .padding(.horizontal)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                }
                .padding(.vertical, 6)
                
                // Blocks list
                List {
                    Section(header: Text("Blockchain")) {
                        ForEach(vm.blockchain.chain.reversed()) { block in
                            BlockRowView(block: block)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("BlockForge")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: WalletsView(viewModel: vm))
{
                        Image(systemName: "wallet.bifold")
                    }
                }
            }
            .sheet(isPresented: $showCreateWallet) {
                CreateWalletView(vm: vm)
            }
            .sheet(isPresented: $showSendTx) {
                SendTransactionView(vm: vm)
            }
        }
    }
}


#Preview {
    ContentView()
}
