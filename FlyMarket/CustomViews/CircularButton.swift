//
//  CircularButton.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 12/11/25.
//

import SwiftUI

struct CircularButton<S: Shape>: View {
    var buttonText: AttributedString
    var color: Color = .blue
    var fontSize: CGFloat = 17
    var size: CGFloat = 60
    var width: CGFloat? = nil // Parámetro opcional para controlar el ancho
    var shape: S
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

extension CircularButton {
    private var buttonTexts: some View {
        HStack {
            Text(buttonText)
                .font(.system(size: fontSize))
                .foregroundColor(.white)
                .padding(.horizontal)
                .frame(maxWidth: width == nil ? .infinity : nil) // Solo expande si width es nil
                .frame(width: width) // Usa el ancho específico si se proporciona
                .frame(height: size)
                .background(color)
                .clipShape(shape)
        }
    }
}

#Preview {
    PreviewContainer()
}

struct PreviewContainer: View {
    var attributedPrice: AttributedString {
        let text = AttributedString("Pay ")
        var boldText = AttributedString("27.97")
        let normalText = AttributedString(" USD")
        boldText.font = .system(size: 20, weight: .bold)
        return text + boldText + normalText
    }
    
    var attributedPlus: AttributedString {
        var text = AttributedString("+")
        text.font = .system(size: 20, weight: .bold)
        return text
    }
    
    var attributedMinor: AttributedString {
        var text = AttributedString("- ")
        text.font = .system(size: 20, weight: .bold)
        return text
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Botones que se reparten el espacio
            HStack(spacing: 0) {
                CircularButton(buttonText: attributedPrice, shape: LeftCapsuleShape(), action: {
                    print("Hola")
                })
                
                CircularButton(buttonText: "Retail", color: Color.gray, fontSize: 14, shape: RightCapsuleShape(), action: {
                    print("Hola")
                })
            }
            .padding(.horizontal)
            
            // Botones con ancho fijo
            HStack(spacing: 10) {
                CircularButton(buttonText: attributedMinor, color: Color.red, size: 44, width: 44, shape: Capsule(), action: {
                    print("Hola")
                })
                
                CircularButton(buttonText: attributedPlus, size: 44, width: 44, shape: Capsule(), action: {
                    print("Hola")
                })
            }
            .padding(.horizontal)
            
            // Botón que llena toda la pantalla
            CircularButton(buttonText: "Full Width", color: .green, shape: Capsule(), action: {
                print("Full width")
            })
            .padding(.horizontal)
        }
    }
}
