//
//  SendTransaction.swift
//  BlockchainSimulator
//
//  Created by Suryanandan Babbar on 11/08/25.
//

import SwiftUI

struct SendTransactionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: BlockchainViewModel
    @State private var fromIndex = 0
    @State private var toIndex = 1
    @State private var amountText = ""
    @State private var showError = false
    @State private var errorMsg = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("From")) {
                    Picker("From", selection: $fromIndex) {
                        ForEach(0..<vm.wallets.count, id: \.self) { i in
                            Text("\(vm.wallets[i].name) (\(vm.wallets[i].address.prefix(6)))").tag(i)
                        }
                    }
                }
                Section(header: Text("To")) {
                    Picker("To", selection: $toIndex) {
                        ForEach(0..<vm.wallets.count, id: \.self) { i in
                            Text("\(vm.wallets[i].name) (\(vm.wallets[i].address.prefix(6)))").tag(i)
                        }
                    }
                }
                Section(header: Text("Amount")) {
                    TextField("Amount", text: $amountText).keyboardType(.decimalPad)
                }
                Button("Send") {
                    guard vm.wallets.indices.contains(fromIndex) && vm.wallets.indices.contains(toIndex) else { return }
                    let from = vm.wallets[fromIndex].address
                    let to = vm.wallets[toIndex].address
                    guard let amt = Double(amountText), amt > 0 else {
                        showError = true
                        errorMsg = "Enter valid amount."
                        return
                    }
                    if from == to {
                        showError = true
                        errorMsg = "From and To must be different."
                        return
                    }
                    let success = vm.sendTransaction(from: from, to: to, amount: amt)
                    if !success {
                        showError = true
                        errorMsg = "Insufficient balance or invalid transaction."
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Send Transaction")
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(errorMsg), dismissButton: .default(Text("OK")))
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { presentationMode.wrappedValue.dismiss() }
                }
            }
        }
    }
}


//#Preview {
//    SendTransactionView()
//}
