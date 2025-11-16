//
//  ProductsView.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 12/11/25.
//

import SwiftUI

struct ProductsView: View {
    
    @StateObject private var viewModel = ProductsViewModel()
    
    let columns = [
        GridItem(.flexible(), spacing: 8),
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack (alignment: .leading){
                    titleBanner
                    Divider()
                    productsList
                    buttonsBanner
                    buttonConverterCurrency
                }
                .padding()
                .popup(isPresented: $viewModel.showListPopup) {
                    showListPopupView
                }
                .popup(isPresented: $viewModel.showCurrencyPopup) {
                    showCurrencyConverterPopupView
                }
                .popup(isPresented: $viewModel.isLoading) {
                    showLoadingPopup
                }
            }
            .navigationDestination(isPresented: $viewModel.navigateToReceiptScreen) {
                ReceiptView(products: viewModel.productsSelected, currency: viewModel.currency)
             }
        }
    }
}

extension ProductsView {
    
    private var titleBanner: some View {
        HStack {
            Text("Products")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.leading, 4)
                .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
            
            Spacer()
            
            filterDropdown
            currencyDropdown
        }
    }
    
    private var filterDropdown: some View {
        Button(action: {
            print("Hola")
        }) {
            HStack(spacing: 6) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.system(size: 16, weight: .semibold))
                Text("Filter")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 9)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color.black.opacity(0.06), lineWidth: 1)
                    )
            )
        }
    }
    
    private var currencyDropdown: some View {
        Menu {
            ForEach(Currency.allCases) { currency in
                Button(action: {
                    viewModel.updateCurrency(currency)
                }) {
                    HStack {
                        Text(currency.symbol)
                        Text(currency.rawValue)
                    }
                }
            }
        } label: {
            HStack(spacing: 6) {
                Text(viewModel.currency.symbol)
                    .font(.system(size: 16, weight: .semibold))
                Text(viewModel.currency.rawValue)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                Image(systemName: "chevron.down")
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundColor(.primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 9)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(Color.black.opacity(0.06), lineWidth: 1)
                    )
            )
        }
        .frame(width: 120)
    }
    
    
    private var productsList: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.products) { product in
                    ProductCellView(product: product, currency: viewModel.currency) { product, change, newQuantity in
                        switch change {
                        case .increment:
                            viewModel.addProduct(product)
                            print("Añadido: \(product.name), cantidad: \(newQuantity)")
                        case .decrement:
                            viewModel.removeProduct(product)
                            print("Eliminado: \(product.name), cantidad: \(newQuantity)")
                        }
                    }
                    .aspectRatio(0.68, contentMode: .fit)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }
    
    private var buttonsBanner: some View {
        HStack (spacing: 0){
            CircularButton(buttonText: viewModel.attributedPrice, shape: LeftCapsuleShape(), action: {
                print("Toco botón, navego")
                viewModel.navigateToReceiptScreen = true
            })
            
            CircularButton(buttonText: AttributedString(viewModel.selectedCustomerType.rawValue), color: Color(red: 73/255, green: 84/255, blue: 99/255), fontSize: 14, width: 120, shape:
                            RightCapsuleShape(), action: {
                viewModel.showListPopup = true
            })
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
    }
    
    private var buttonConverterCurrency: some View {
        HStack {
            Spacer()
            Button(action: { viewModel.showCurrencyPopup = true }) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.right.square")
                        .font(.caption2)
                    Text("_Show Currency Converter")
                        .font(.caption)
                }
                .padding(.leading, 5)
                .padding(.trailing, 5)
                .foregroundColor(.black.opacity(0.85))
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .stroke(Color.black.opacity(0.25), lineWidth: 1)
                )
            }
            .padding(.top, 1)
            Spacer()
        }
    }
    
    private var showListPopupView: some View {
        ListSelectionPopup(
            isPresented: $viewModel.showListPopup,
            title: "_Customer Type",
            subtitle: "_Select the applicable customer type for this sale",
            items: viewModel.customerTypes,
            onSelect: { item in
                //viewModel.selectedSaleTypeAttributed(item)
                viewModel.showListPopup = false
            }
        )
    }
    
    private var showCurrencyConverterPopupView: some View {
        CurrencyConverterView(baseAmount: viewModel.returnTotalAmountString())
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
    }
    
    private var showLoadingPopup: some View {
        LoadingPopup(
            title: "Loading",
            message: "Loading products, please wait..."
        )
    }
}

#Preview {
    ProductsView()
}
