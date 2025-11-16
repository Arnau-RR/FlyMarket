import SwiftUI

struct CurrencyConverterView: View {
    @State var baseAmount: String = "100"
    @State private var selectedCurrency: Currency = .eur
    
    // Tasas de cambio aproximadas
    let exchangeRates: [Currency: [Currency: Double]] = [
        .eur: [.usd: 1.09, .gbp: 0.86],
        .usd: [.eur: 0.92, .gbp: 0.79],
        .gbp: [.eur: 1.16, .usd: 1.27]
    ]
    
    var body: some View {
        ZStack {
            Color(.clear)
                .ignoresSafeArea()
            
            VStack {
                Spacer(minLength: 24)
                
                // Contenedor tipo tarjeta
                VStack(alignment: .leading, spacing: 20) {
                    titleBanner
                    currencySelector
                    
                    Divider()
                    conversionsDisplay
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
    
    // MARK: - UI Components
    
    private var titleBanner: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.black)
                    .frame(width: 42, height: 42)
                    .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 4)
                
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Currency Converter")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Select your base currency and view real-time conversions.")
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
    }
    
    private var currencySelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Base Amount")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundColor(.secondary)
            
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(.secondarySystemBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(Color.black.opacity(0.06), lineWidth: 1)
                        )
                    
                    TextField("Amount", text: $baseAmount)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 9)
                        .disabled(true)
                }
                .frame(height: 44)
                
                Menu {
                    ForEach(Currency.allCases) { currency in
                        Button(action: {
                            selectedCurrency = currency
                        }) {
                            HStack {
                                Text(currency.symbol)
                                Text(currency.rawValue)
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text(selectedCurrency.symbol)
                            .font(.system(size: 16, weight: .semibold))
                        Text(selectedCurrency.rawValue)
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
        }
    }
    
    private var conversionsDisplay: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Equivalent Prices")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundColor(.secondary)
            
            HStack(spacing: 12) {
                ForEach(Currency.allCases.filter { $0 != selectedCurrency }) { currency in
                    ConversionCard(
                        amount: convertAmount(to: currency),
                        symbol: currency.symbol,
                        currency: currency.rawValue
                    )
                }
            }
        }
        .padding(.top, 4)
    }
    
    func convertAmount(to targetCurrency: Currency) -> String {
        guard let amount = Double(baseAmount.replacingOccurrences(of: ",", with: ".")),
              let rate = exchangeRates[selectedCurrency]?[targetCurrency] else {
            return "0.00"
        }
        let converted = amount * rate
        return String(format: "%.2f", converted)
    }
}

struct ConversionCard: View {
    let amount: String
    let symbol: String
    let currency: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(currency)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundColor(.secondary)
            
            HStack(spacing: 4) {
                Text(amount)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(symbol)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
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

#Preview {
    CurrencyConverterView()
}
