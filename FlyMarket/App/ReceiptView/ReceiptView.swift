//
//  ReceiptView.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 13/11/25.
//

import SwiftUI

struct ReceiptView: View {
    
    @StateObject private var viewModel: ReceiptViewModel
    @Environment(\.dismiss) private var dismiss
    
    @Binding var isPresented: Bool
    
    // Callback para devolver los productos a la vista padre
    var onComplete: (([ProductRemote]) -> Void)?
    
    init(
        isPresented: Binding<Bool>,
        products: [ProductRemote],
        currency: Currency,
        onComplete: (([ProductRemote]) -> Void)? = nil
    ) {
        self._isPresented = isPresented
        _viewModel = StateObject(wrappedValue: ReceiptViewModel(products: products, currency: currency))
        self.onComplete = onComplete
    }
    
    var body: some View {
        ZStack {
            // Contenido normal de la pantalla
            VStack (alignment: .leading){
                titleBanner
                Divider()
                listProducts
                totalAndSeatBanner
                cardCashBanner
                Spacer()
            }
            .padding()
            
            if let overlay = viewModel.activePaymentOverlay {
                cardInformationCard(overlay: overlay)
            }
        }
        .navigationBarBackButtonHidden(true) // Oculta el botón nativo
        .popup(isPresented: $viewModel.showingSeatMap) {
            SeatMapView(
                selectedSeat: $viewModel.selectedSeat,
                isPresented: $viewModel.showingSeatMap
            )
        }
        .animation(.easeInOut, value: viewModel.activePaymentOverlay)
    }
}

extension ReceiptView {
    private var titleBanner: some View {
        HStack {
            VStack (alignment: .leading, spacing: 5){
                Text("_Receipt")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .padding(.leading, 4)
                    .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                
                Text("_Selected Products")
                    .font(.system(size: 17, design: .rounded))
                    .foregroundColor(.gray)
                    .padding(.leading, 4)
                    .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        onComplete?(viewModel.products)
                        isPresented = false
                        dismiss()
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 27))
                        .foregroundColor(.black.opacity(0.55))
                        .shadow(radius: 4)
                }
            }
            .padding()
        }
    }
    
    private func cardInformationCard(overlay: ActivePaymentOverlay) -> some View {
        ZStack {
            // Fondo negro semitransparente para ver lo de abajo
            Color.black.opacity(0.55)
                .ignoresSafeArea()
                .transition(.opacity)
            
            // Contenido del pago
            Group {
                switch overlay {
                case .cash:
                    CashPaymentView(amountDue: 10)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                case .card:
                    CardDetailsView()
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                }
            }
            
            // Botón de cerrar arriba a la derecha
            VStack {
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            viewModel.activePaymentOverlay = nil
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white.opacity(0.85))
                            .shadow(radius: 4)
                    }
                }
                .padding()
                
                Spacer()
            }
        }
        .transition(.opacity)
    }
    
    private var listProducts: some View {
        List {
            ForEach(viewModel.products.indices, id: \.self) { index in
                ProductRectangularCellView(
                    productItem: viewModel.products[index],
                    currency: viewModel.currency
                )
                .listRowInsets(EdgeInsets())
                //.listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .onDelete { indexSet in
                withAnimation {
                    viewModel.removeProducts(at: indexSet)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
    
    private var totalAndSeatBanner: some View {
        HStack {
            VStack (alignment: .leading){
                Text("_Seat".uppercased())
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(.gray)
                    .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                
                Button(action: {
                    viewModel.showingSeatMap = true
                }) {
                    Text(viewModel.selectedSeat ?? "-")
                        .padding(.leading, 15)
                        .padding(.trailing, 15)
                        .padding(.top, 7)
                        .padding(.bottom, 7)
                        .background(.black.opacity(0.2))
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                        .cornerRadius(5)
                }
            }
            
            Spacer()
            
            VStack (alignment: .trailing){
                Text("_Total".uppercased())
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(.gray)
                    .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
                
                Text(viewModel.totalFormatted)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .padding(.leading, 4)
                    .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
            }
        }
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
    
    private var cardCashBanner: some View {
        HStack {
            // CASH → abre overlay
            RectancularButton(
                buttonText: "_Cash",
                backgroundColor: .black.opacity(0.8),
                imageName: "MoneyBag",
                systemImage: false,
                action: {
                    withAnimation {
                        viewModel.activePaymentOverlay = .cash
                    }
                }
            )
            
            Spacer()
            
            // CARD → abre overlay
            RectancularButton(
                buttonText: "_Card",
                imageName: "creditcard",
                action: {
                    withAnimation {
                        viewModel.activePaymentOverlay = .card
                    }
                }
            )
        }
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
}

#Preview {
    ReceiptView(isPresented: .constant(true), products: MockData.sampleProducts, currency: .eur)
}
