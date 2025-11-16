//
//  CircularCounterView.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 13/11/25.
//

import SwiftUI

struct CircularCounterView: View {
    let text: String
    
    var body: some View {
        circularText
    }
}

extension CircularCounterView {
    private var circularText: some View {
        Text(text)
            .font(.system(size: 20, weight: .bold))
            .padding(12)
            .background(
                Circle()
                    .fill(Color.white)
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: 2)   // <-- Borde negro
                    )
            )
            .foregroundColor(.black)
    }
}

#Preview {
    CircularCounterView(text: "2")
}
