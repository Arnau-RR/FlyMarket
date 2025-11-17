//
//  FlyMarketApp.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 12/11/25.
//

import SwiftUI

@main
struct FlyMarketApp: App {
    @State private var showLaunch = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ProductsView()
                    .preferredColorScheme(.light)
                
                if showLaunch {
                    LaunchView()
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation {
                                    showLaunch = false
                                }
                            }
                        }
                }
            }
        }
    }
}
