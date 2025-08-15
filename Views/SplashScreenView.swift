//
//  SplashScreenView.swift
//  BlockchainSimulator
//
//  Created by Suryanandan Babbar on 11/08/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var showMainView = false
    @State private var opacity = 0.0
    @State private var scale: CGFloat = 0.8
    @State private var fadeOut = false

    var body: some View {
        ZStack {
            if showMainView {
                ContentView()
                    .transition(.opacity) // smooth fade-in for main view
            } else {
                Color.black.ignoresSafeArea()

                VStack {
                    Image("Image") // logo from Assets.xcassets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 1.0)) {
                                self.opacity = 1.0
                                self.scale = 1.0
                            }
                        }

                    Text("BlockForge")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .opacity(opacity)
                        .padding(.top, 20)
                }
                .opacity(fadeOut ? 0 : 1) // fade out logo and text
            }
        }
        .onAppear {
            // Animate fade-in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeOut(duration: 1.0)) {
                    self.fadeOut = true
                }
            }
            // Switch to main view
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeIn(duration: 0.5)) {
                    self.showMainView = true
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
