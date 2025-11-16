//
//  PriceTagView.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 12/11/25.
//

import SwiftUI

struct PriceTagView: View {
    var priceText: String
    
    var body: some View {
        ZStack {
            rectangleWithPrice
        }
    }
}

extension PriceTagView {
    private var rectangleWithPrice: some View {
        Text(priceText)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.leading, 15)
            .padding(.trailing, 15)
            .padding(.top, 10)
            .padding(.bottom, 10)


            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black)
            )
    }
}

#Preview {
    PriceTagView(priceText: "19.90 $")
}

