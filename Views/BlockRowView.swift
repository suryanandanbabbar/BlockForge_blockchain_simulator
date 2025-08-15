//
//  BlockRowView.swift
//  BlockchainSimulator
//
//  Created by Suryanandan Babbar on 11/08/25.
//

import SwiftUI

struct BlockRowView: View {
    let block: Block
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Block #\(block.index)").bold()
                Spacer()
                Text(block.timestamp, style: .time).font(.caption)
            }
            Text("Hash: \(block.hash)").font(.caption2).lineLimit(1)
            Text("Prev: \(block.previousHash)").font(.caption2).lineLimit(1)
            HStack {
                Text("Nonce: \(block.nonce)").font(.caption2)
                Spacer()
                Text("Tx: \(block.transactions.count)").font(.caption2)
            }
            ForEach(block.transactions.prefix(3)) { tx in
                HStack {
                    Text("\(tx.from.prefix(6)) → \(tx.to.prefix(6))")
                    Spacer()
                    Text(String(format: "%.2f", tx.amount))
                }
                .font(.caption)
            }
            if block.transactions.count > 3 {
                Text("... \(block.transactions.count - 3) more transactions").font(.caption2).foregroundColor(.secondary)
            }
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
    }
}


//#Preview {
//    BlockRowView()
//}
