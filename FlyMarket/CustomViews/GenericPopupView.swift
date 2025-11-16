//
//  GenericPopupView.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 15/11/25.
//


import SwiftUI

// MARK: - Generic Popup View
struct GenericPopupView<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content
    
    // Configuración opcional
    var backgroundOpacity: Double = 0.55
    var showCloseButton: Bool = true
    var closeButtonSize: CGFloat = 30
    
    init(
        isPresented: Binding<Bool>,
        backgroundOpacity: Double = 0.55,
        showCloseButton: Bool = true,
        closeButtonSize: CGFloat = 30,
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.backgroundOpacity = backgroundOpacity
        self.showCloseButton = showCloseButton
        self.closeButtonSize = closeButtonSize
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            if isPresented {
                // Fondo negro semitransparente
                Color.black.opacity(backgroundOpacity)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }
                
                // Contenido personalizado
                content
                    .transition(.scale.combined(with: .opacity))
                
                // Botón de cerrar (opcional)
                if showCloseButton {
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                withAnimation {
                                    isPresented = false
                                }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: closeButtonSize))
                                    .foregroundColor(.white.opacity(0.85))
                                    .shadow(radius: 4)
                            }
                        }
                        .padding()
                        
                        Spacer()
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isPresented)
    }
}

// MARK: - View Extension para facilitar el uso
extension View {
    func popup<Content: View>(
        isPresented: Binding<Bool>,
        backgroundOpacity: Double = 0.55,
        showCloseButton: Bool = true,
        closeButtonSize: CGFloat = 30,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self
            
            GenericPopupView(
                isPresented: isPresented,
                backgroundOpacity: backgroundOpacity,
                showCloseButton: showCloseButton,
                closeButtonSize: closeButtonSize,
                content: content
            )
        }
    }
}

// MARK: - Ejemplo de uso
struct ContentViewExample: View {
    @State private var showCurrencyPopup = false
    @State private var showSettingsPopup = false
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Mostrar Currency Converter") {
                withAnimation {
                    showCurrencyPopup = true
                }
            }
            
            Button("Mostrar Settings") {
                withAnimation {
                    showSettingsPopup = true
                }
            }
        }
        // Opción 1: Usando el modifier .popup()
        .popup(isPresented: $showCurrencyPopup) {
            CurrencyConverterCard()
        }
        .popup(isPresented: $showSettingsPopup, backgroundOpacity: 0.7) {
            SettingsCard()
        }
        
        // Opción 2: Usando GenericPopupView directamente
        // GenericPopupView(isPresented: $showCurrencyPopup) {
        //     CurrencyConverterCard()
        // }
    }
}

// MARK: - Cards de ejemplo
struct CurrencyConverterCard: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Currency Converter")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Base Amount: 27,97€")
                .font(.headline)
            
            // Aquí iría tu CurrencyConverterView
            Text("Contenido del convertidor...")
                .foregroundColor(.secondary)
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(radius: 20)
        )
        .padding(40)
    }
}

struct SettingsCard: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Settings")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Configuración de la app")
                .foregroundColor(.secondary)
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(radius: 20)
        )
        .padding(40)
    }
}

#Preview {
    ContentViewExample()
}