//
//  ProductCellView.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 12/11/25.
//

import SwiftUI

struct ProductCellView: View {
    @ObservedObject private var viewModel: ProductCellViewModel
    private let onChange: ((ProductRemote, QuantityChange) -> Void)?
    
    init(
        product: ProductRemote,
        currency: Currency,
        onChange: ((ProductRemote, QuantityChange) -> Void)? = nil
    ) {
        _viewModel = ObservedObject(
            wrappedValue: ProductCellViewModel(
                product: product,
                currency: currency,
            )
        )
        self.onChange = onChange
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
        ZStack(alignment: .topLeading) {
            imageBackground()
            colorBlack()
            if (viewModel.returnProductQuantity() != 0) {
                counterComponent
            }
            textAndComponents
        }
        .frame(width: 370, height: 250)
    }
}

extension ProductCellView {
    private func imageBackground() -> some View {
        return AsyncImage(url: URL(string: viewModel.product.imageUrl)) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ZStack {
                Color.gray.opacity(0.3)
                ProgressView()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .clipped()
    }
    
    private func colorBlack () -> some View {
        return Color.black.opacity(0.4)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private var textAndComponents: some View {
        VStack (alignment: .leading){
            titleAndSubtitle
            Spacer()
            buttonsPlusMinorAndPrice
        }
    }
    
    private var titleAndSubtitle: some View {
        VStack (alignment: .leading){
            // Texto encima
            Text(viewModel.product.name)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.top, 20)
            
            // Texto encima
            Text(String(viewModel.product.units) + "_Units")
                .font(.system(size: 17))
                .foregroundColor(.white)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.top, 1)
        }
    }
    
    private var counterComponent: some View {
        HStack {
            Spacer()
            CircularCounterView(text: "\(viewModel.returnProductQuantity())")
        }
        .padding(.trailing, 7)
    }
    
    private var buttonsPlusMinorAndPrice: some View {
        HStack (spacing: 15){
            if (viewModel.returnProductQuantity() != 0) {
                CircularButton(buttonText: attributedMinor, color: Color.red, size: 44,  width: 44, shape: Capsule(), action: {
                    onChange?(viewModel.product, .decrement)
                })
            }
            
            if (viewModel.returnProductQuantity() != viewModel.product.units) {
                CircularButton(buttonText: attributedPlus, size: 44,  width: 44, shape: Capsule(), action: {
                    onChange?(viewModel.product, .increment)
                })
            }
            
            Spacer()
            
            PriceTagView(priceText: viewModel.showPriceWithCurrency())
        }
        .padding()
    }
}

#Preview {
    ProductCellView(product: MockData.sampleProducts.first!, currency: .eur)
}


