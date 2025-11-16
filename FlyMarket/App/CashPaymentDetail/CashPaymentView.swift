//
//  CashPaymentView.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 14/11/25.
//

import SwiftUI

struct CashPaymentView: View {
    
    @StateObject private var viewModel: CashPaymentViewModel
    
    init(amountDue: Decimal) {
        _viewModel = StateObject(
            wrappedValue: CashPaymentViewModel(amountDue: amountDue)
        )
    }
    
    var body: some View {
        ZStack {
            // Fondo
            LinearGradient(
                colors: [
                    Color(.clear),
                    Color(.clear)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer(minLength: 24)
                
                // Card contenedora
                VStack(alignment: .leading, spacing: 20) {
                    titleBanner
                    amountSummary
                    Divider()
                    cashInputSection
                    confirmButton
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
extension CashPaymentView {
    
    private var titleBanner: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.black)
                    .frame(width: 42, height: 42)
                    .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 4)
                
                Image(systemName: "eurosign.circle.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .semibold))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Cash Payment")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("For cash payments, only the total amount needs to be entered. We'll show the change if applicable.")
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
    }
    
    private var amountSummary: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order Summary")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(.secondary)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total due")
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    Text(viewModel.formattedAmount(viewModel.amountDue))
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                }
                
                Spacer()
            }
            
            if viewModel.cashReceived > 0 {
                if viewModel.isEnoughCash {
                    changePill
                } else {
                    remainingPill
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.systemGray6))
        )
    }
    
    private var changePill: some View {
        HStack(spacing: 8) {
            Image(systemName: "arrow.2.squarepath")
                .font(.system(size: 14, weight: .semibold))
            
            Text("Change to give:")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
            
            Text(viewModel.formattedAmount(viewModel.change))
                .font(.system(size: 15, weight: .bold, design: .rounded))
        }
        .foregroundColor(Color.green)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule(style: .continuous)
                .fill(Color.green.opacity(0.08))
        )
    }
    
    private var remainingPill: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 14, weight: .semibold))
            
            Text("Remaining:")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
            
            Text(viewModel.formattedAmount(viewModel.remaining))
                .font(.system(size: 15, weight: .bold, design: .rounded))
        }
        .foregroundColor(Color.orange)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule(style: .continuous)
                .fill(Color.orange.opacity(0.08))
        )
    }
    
    private var cashInputSection: some View {
        VStack(spacing: 18) {
            // Reutiliza tu LabeledTextField "bonito"
            LabeledTextField(
                title: "Cash received",
                placeholder: "0,00",
                text: $viewModel.cashReceivedText
            ) { _ in
                viewModel.onCashReceivedChange()
            }
            .keyboardType(.decimalPad)
            
            Text("Enter the total cash given by the customer. The app will automatically calculate the change.")
                .font(.system(size: 12, weight: .regular, design: .rounded))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private var confirmButton: some View {
        Button(action: {
            // Acción de confirmar pago en efectivo
            print("Confirmed cash payment: received \(viewModel.cashReceivedText)")
        }) {
            HStack {
                Spacer()
                Text(viewModel.isEnoughCash ? "Confirm cash payment" : "Insufficient amount")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
            }
            .padding(.vertical, 14)
            .background(
                LinearGradient(
                    colors: viewModel.isEnoughCash
                    ? [Color.black, Color(.darkGray)]
                    : [Color(.systemGray3), Color(.systemGray4)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(16)
            .shadow(
                color: viewModel.isEnoughCash
                ? Color.black.opacity(0.25)
                : Color.clear,
                radius: 10,
                x: 0,
                y: 6
            )
            .scaleEffect(viewModel.isEnoughCash ? 1.0 : 0.99)
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: viewModel.isEnoughCash)
        }
        .disabled(!viewModel.isEnoughCash)
        .padding(.top, 8)
    }
}

#Preview {
    CashPaymentView(amountDue: 23.50)
}
