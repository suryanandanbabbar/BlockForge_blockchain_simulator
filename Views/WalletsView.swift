//
//  WalletView.swift
//  BlockchainSimulator
//
//  Created by Suryanandan Babbar on 11/08/25.
//

import SwiftUI

struct WalletsView: View {
    @ObservedObject var viewModel: BlockchainViewModel
    @State private var topUpAmount: String = "100"
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.wallets) { wallet in
                    VStack(alignment: .leading) {
                        Text(wallet.name)
                            .font(.headline)
                        Text("Address: \(wallet.address)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Balance: \(viewModel.blockchain.balanceOfAddress(wallet.address), specifier: "%.2f")")
                            .bold()
                            .padding(.top, 2)
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .navigationTitle("Wallets")
    }
}


//#Preview {
//    WalletsView()
//}
