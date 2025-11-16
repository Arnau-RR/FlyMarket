//
//  LabeledTextField.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 14/11/25.
//

import SwiftUI

struct LabeledTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var onChange: (String) -> Void = { _ in }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title.uppercased())
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundColor(.secondary)
            
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color.black.opacity(0.06), lineWidth: 1)
                    )
                
                TextField(placeholder, text: $text)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 9)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .onChange(of: text) { newValue in
                        onChange(newValue)
                    }
            }
            .frame(height: 44)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        LabeledTextField(
            title: "Card Number",
            placeholder: "1234 5678 9012 3456",
            text: .constant("")
        )
        
        LabeledTextField(
            title: "Card Holder",
            placeholder: "Name on card",
            text: .constant("Arnau Rivas")
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
