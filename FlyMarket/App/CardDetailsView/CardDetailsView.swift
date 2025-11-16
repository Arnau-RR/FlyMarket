//
//  CardDetailsView.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 14/11/25.
//

import SwiftUI

struct CardDetailsView: View {
    
    // MARK: - Card fields
    @StateObject private var viewModel = CardDetailsViewModel()
    
    var body: some View {
        ZStack {
            // Fondo general
            Color(.clear)
                .ignoresSafeArea()
            
            VStack {
                Spacer(minLength: 24)
                
                // Contenedor tipo tarjeta
                VStack(alignment: .leading, spacing: 20) {
                    titleBanner
                    cardPreview
                    Divider()
                    cardInformation
                    payButton
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.08), radius: 18, x: 0, y: 10)
                )
                .padding(.horizontal, 16)
                
                Spacer()
            }
        }
    }
}

// MARK: - UI pieces
extension CardDetailsView {
    
    private var titleBanner: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.black)
                    .frame(width: 42, height: 42)
                    .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 4)
                
                Image(systemName: "creditcard.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Card Information")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Add your card details to complete your purchase securely.")
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
    }
    
    /// Pequeña “preview” de la tarjeta con info básica
    private var cardPreview: some View {
        let maskedNumber = viewModel.cardNumber.isEmpty
        ? "••••  ••••  ••••  ••••"
        : viewModel.cardNumber
        
        return ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.black,
                            Color(.darkGray)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text(viewModel.cardBrand.isEmpty ? "Your Card" : viewModel.cardBrand)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Spacer()
                }
                
                Text(maskedNumber)
                    .font(.system(size: 17, weight: .semibold, design: .monospaced))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("CARD HOLDER")
                            .font(.system(size: 9, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.5))
                        
                        Text(viewModel.cardHolder.isEmpty ? "NAME SURNAME" : viewModel.cardHolder.uppercased())
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("EXPIRES")
                            .font(.system(size: 9, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.5))
                        
                        Text(viewModel.expiryDate.isEmpty ? "MM/YY" : viewModel.expiryDate)
                            .font(.system(size: 11, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(16)
        }
        .frame(height: 120)
    }
    
    private var cardInformation: some View {
        VStack(spacing: 18) {
            // Número de tarjeta
            LabeledTextField(
                title: "Card Number",
                placeholder: "1234 5678 9012 3456",
                text: $viewModel.cardNumber
            ) { _ in
                viewModel.formatCardNumber()
                viewModel.detectCardBrand()
            }
            .keyboardType(.numberPad)
            
            if !viewModel.cardNumber.isEmpty && !viewModel.isCardNumberValid {
                errorLabel("Invalid card number")
            }
            
            if !viewModel.cardBrand.isEmpty {
                subtleInfoLabel("Detected card: \(viewModel.cardBrand)")
            }
            
            // Titular
            LabeledTextField(
                title: "Card Holder",
                placeholder: "Name on card",
                text: $viewModel.cardHolder
            )
            .textInputAutocapitalization(.words)
            
            if !viewModel.cardHolder.isEmpty && !viewModel.isCardHolderValid {
                errorLabel("Please enter the full name")
            }
            
            HStack(spacing: 12) {
                // Expiry
                VStack(alignment: .leading, spacing: 6) {
                    LabeledTextField(
                        title: "Expiry",
                        placeholder: "MM/YY",
                        text: $viewModel.expiryDate
                    ) { _ in
                        viewModel.formatExpiry()
                    }
                    .keyboardType(.numberPad)
                    
                    if !viewModel.expiryDate.isEmpty && !viewModel.isExpiryValid {
                        errorLabel("Invalid expiry date")
                    }
                }
                
                // CVV
                VStack(alignment: .leading, spacing: 6) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("CVV")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundColor(.secondary)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color(.secondarySystemBackground))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                                )
                            
                            HStack {
                                SecureField("•••", text: $viewModel.cvv)
                                    .keyboardType(.numberPad)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 9)
                                
                                Image(systemName: "questionmark.circle")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.secondary)
                                    .padding(.trailing, 10)
                            }
                        }
                        .frame(height: 44)
                    }
                    
                    if !viewModel.cvv.isEmpty && !viewModel.isCVVValid {
                        errorLabel("Invalid CVV")
                    }
                }
                .frame(width: 120)
            }
        }
        .padding(.top, 4)
    }
    
    private func errorLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .medium, design: .rounded))
            .foregroundColor(.red)
            .transition(.opacity)
    }
    
    private func subtleInfoLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .regular, design: .rounded))
            .foregroundColor(.secondary)
    }
    
    private var payButton: some View {
        Button(action: {
            print("Pagar con tarjeta: \(viewModel.cardNumber)")
        }) {
            HStack {
                Spacer()
                Text("Pay now")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                Image(systemName: "arrow.right")
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
            }
            .padding(.vertical, 14)
            .background(
                LinearGradient(
                    colors: viewModel.canPay
                    ? [Color.black, Color(.darkGray)]
                    : [Color(.systemGray3), Color(.systemGray4)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(16)
            .shadow(
                color: viewModel.canPay
                ? Color.black.opacity(0.25)
                : Color.clear,
                radius: 10,
                x: 0,
                y: 6
            )
            .scaleEffect(viewModel.canPay ? 1.0 : 0.99)
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: viewModel.canPay)
        }
        .disabled(!viewModel.canPay)
        .padding(.top, 8)
    }
}

#Preview {
    CardDetailsView()
}
