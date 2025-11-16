//
//  ProductRectangularCellView.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 13/11/25.
//

import SwiftUI

struct ProductRectangularCellView: View {
    
    let productItem: ProductItem
    var currency: Currency = .eur
    
    var body: some View {
        HStack {
            imageCircle()
            productName
            Spacer()
            counterText
        }
        .padding()
    }
}

extension ProductRectangularCellView {
    
    private func imageCircle() -> some View {
        let imageSize: CGFloat = 50
        
        return AsyncImage(url: URL(string: productItem.imageUrl)) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: imageSize, height: imageSize)
                .clipShape(Circle())
        } placeholder: {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                ProgressView()
            }
            .frame(width: imageSize, height: imageSize)
        }
    }
    
    private var productName: some View {
        VStack (alignment: .leading, spacing: 2){
            Text(productItem.name)
                .font(.system(size: 18, design: .rounded))
                .foregroundColor(.black)
                .padding(.leading, 4)
                .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
            
            Text(String(productItem.basePrice) + currency.symbol)
                .font(.system(size: 15, design: .rounded))
                .foregroundColor(.gray)
                .padding(.leading, 4)
                .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
        }
    }
    
    private var counterText: some View {
        Text(String(productItem.quantity))
            .font(.system(size: 17, weight: .bold, design: .rounded))
            .foregroundColor(.black)
            .padding(.leading, 4)
            .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
    }
}

#Preview {
    ProductRectangularCellView(productItem: ProductItem(imageUrl: "https://images.pexels.com/photos/327158/pexels-photo-327158.jpeg",
                                                        name: "Chicken Sandwich",
                                                        units: 2,
                                                        basePrice: 19.99))
}
