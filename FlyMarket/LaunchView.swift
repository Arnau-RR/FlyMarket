//
//  LaunchView.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 16/11/25.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            Image("LaunchScreen")   // el mismo nombre usado en Assets
                .resizable()
                .scaledToFit()
                .frame(width: 260)
        }
    }
}
