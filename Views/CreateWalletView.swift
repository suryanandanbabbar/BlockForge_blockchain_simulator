//
//  CreateNewWallet.swift
//  BlockchainSimulator
//
//  Created by Suryanandan Babbar on 11/08/25.
//

import SwiftUI

struct CreateWalletView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: BlockchainViewModel
    @State private var name = ""
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Wallet Name")) {
                    TextField("Name", text: $name)
                }
                Button("Create") {
                    guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    _ = vm.createWallet(name: name.trimmingCharacters(in: .whitespaces))
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("New Wallet")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { presentationMode.wrappedValue.dismiss() }
                }
            }
        }
    }
}


//#Preview {
//    CreateWalletView()
//}
