//
//  RectancularButton.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 14/11/25.
//

import SwiftUI

struct RectancularButton: View {
    var buttonText: String
    var backgroundColor: Color = .blue
    var foregroundColorText: Color = .white
    var foregroundColorImage: Color = .black
    var imageName: String
    var systemImage: Bool = true
    var fontSize: CGFloat = 17
    var action: () -> Void
    
    var body: some View {
        ZStack {
            Button(action: {
                action()
            }) {
                buttonTexts
            }
        }
    }
}

extension RectancularButton {
    private var buttonTexts: some View {
        VStack(spacing: 10) {
            if (systemImage) {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .foregroundColor(foregroundColorImage)
            } else {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .foregroundColor(foregroundColorImage)
            }
            
            Text(buttonText)
                .font(.system(size: 15))
                .foregroundColor(foregroundColorText)
        }
        .padding(.top, 18)
//        .padding(.leading, 65)
//        .padding(.trailing, 65)
        .padding(.bottom, 18)
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
        .cornerRadius(10)
    }
}

#Preview {
    RectancularButton(buttonText: "Card", imageName: "creditcard", action: {
        print("Hola")
    })
}
