//
//  CustomPopup.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 15/11/25.
//

import SwiftUI

// MARK: - Main Popup View
struct CustomPopup<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content
    let onDismiss: () -> Void
    
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var offset: CGFloat = 20
    
    init(
        isPresented: Binding<Bool>,
        onDismiss: @escaping () -> Void = {},
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.onDismiss = onDismiss
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Backdrop
            Color.black.opacity(0.1)
                .ignoresSafeArea()
                .opacity(opacity)
                .onTapGesture {
                    dismissPopup()
                }
            
            // Popup Container
            VStack(spacing: 0) {
                content
            }
            .frame(maxWidth: 360)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.15), radius: 30, x: 0, y: 15)
            )
            .padding(.horizontal, 24)
            .scaleEffect(scale)
            .offset(y: offset)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                opacity = 1
                scale = 1
                offset = 0
            }
        }
    }
    
    private func dismissPopup() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
            opacity = 0
            scale = 0.9
            offset = 20
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            isPresented = false
            onDismiss()
        }
    }
}

// MARK: - Popup Header Component
struct PopupHeader: View {
    let icon: String
    let title: String
    let subtitle: String?
    let onClose: () -> Void
    
    init(icon: String, title: String, subtitle: String? = nil, onClose: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.onClose = onClose
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            Spacer()
            
        }
        .padding(20)
    }
}

// MARK: - List Selection Popup Content
struct ListSelectionPopup: View {
    @Binding var isPresented: Bool
    let icon: String
    let title: String
    let subtitle: String?
    let items: [String]
    let onSelect: (String) -> Void
    
    @State private var selectedItem: String?
    
    init(
        isPresented: Binding<Bool>,
        icon: String = "list.bullet",
        title: String,
        subtitle: String? = nil,
        items: [String],
        onSelect: @escaping (String) -> Void
    ) {
        self._isPresented = isPresented
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.items = items
        self.onSelect = onSelect
    }
    
    var body: some View {
        CustomPopup(isPresented: $isPresented) {
            VStack(spacing: 0) {
                PopupHeader(
                    icon: icon,
                    title: title,
                    subtitle: subtitle,
                    onClose: {
                        isPresented = false
                    }
                )
                
                Divider()
                    .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(items, id: \.self) { item in
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedItem = item
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    onSelect(item)
                                }
                            }) {
                                HStack {
                                    Text(item)
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    if selectedItem == item {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(width: 20, height: 20)
                                            .background(
                                                Circle()
                                                    .fill(Color.black)
                                            )
                                            .transition(.scale.combined(with: .opacity))
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(selectedItem == item ? Color.black.opacity(0.05) : Color(.secondarySystemBackground))
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                }
                .frame(maxHeight: 400)
            }
        }
    }
}

// MARK: - Confirmation Popup
struct ConfirmationPopup: View {
    @Binding var isPresented: Bool
    let icon: String
    let title: String
    let subtitle: String?
    let message: String
    let confirmText: String
    let cancelText: String
    let isDestructive: Bool
    let onConfirm: (Bool) -> Void
    
    init(
        isPresented: Binding<Bool>,
        icon: String = "exclamationmark.triangle.fill",
        title: String,
        subtitle: String? = nil,
        message: String,
        confirmText: String = "Confirm",
        cancelText: String = "Cancel",
        isDestructive: Bool = false,
        onConfirm: @escaping (Bool) -> Void
    ) {
        self._isPresented = isPresented
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.message = message
        self.confirmText = confirmText
        self.cancelText = cancelText
        self.isDestructive = isDestructive
        self.onConfirm = onConfirm
    }
    
    var body: some View {
        CustomPopup(isPresented: $isPresented) {
            VStack(spacing: 0) {
                PopupHeader(
                    icon: icon,
                    title: title,
                    subtitle: subtitle,
                    onClose: {
                        isPresented = false
                        onConfirm(false)
                    }
                )
                
                Divider()
                    .padding(.horizontal, 20)
                
                VStack(spacing: 20) {
                    Text(message)
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    HStack(spacing: 12) {
                        // Cancel button
                        Button(action: {
                            onConfirm(false)
                            isPresented = false
                        }) {
                            Text(cancelText)
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(Color(.secondarySystemBackground))
                                )
                        }
                        
                        // Confirm button
                        Button(action: {
                            onConfirm(true)
                            isPresented = false
                        }) {
                            Text(confirmText)
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(
                                            LinearGradient(
                                                colors: isDestructive
                                                ? [Color.red, Color.red.opacity(0.8)]
                                                : [Color.black, Color(.darkGray)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .shadow(
                                            color: (isDestructive ? Color.red : Color.black).opacity(0.25),
                                            radius: 10,
                                            x: 0,
                                            y: 6
                                        )
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

// MARK: - Text Input Popup
struct TextInputPopup: View {
    @Binding var isPresented: Bool
    let icon: String
    let title: String
    let subtitle: String?
    let placeholder: String
    let buttonText: String
    let onSubmit: (String) -> Void
    
    @State private var text: String = ""
    @FocusState private var isFocused: Bool
    
    init(
        isPresented: Binding<Bool>,
        icon: String = "pencil",
        title: String,
        subtitle: String? = nil,
        placeholder: String = "Enter text...",
        buttonText: String = "Submit",
        onSubmit: @escaping (String) -> Void
    ) {
        self._isPresented = isPresented
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.placeholder = placeholder
        self.buttonText = buttonText
        self.onSubmit = onSubmit
    }
    
    var body: some View {
        CustomPopup(isPresented: $isPresented) {
            VStack(spacing: 0) {
                PopupHeader(
                    icon: icon,
                    title: title,
                    subtitle: subtitle,
                    onClose: {
                        isPresented = false
                    }
                )
                
                Divider()
                    .padding(.horizontal, 20)
                
                VStack(spacing: 20) {
                    // Text field
                    VStack(alignment: .leading, spacing: 4) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color(.secondarySystemBackground))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .stroke(isFocused ? Color.black.opacity(0.3) : Color.black.opacity(0.06), lineWidth: 1.5)
                                )
                            
                            TextField(placeholder, text: $text)
                                .font(.system(size: 15, weight: .regular, design: .rounded))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 12)
                                .focused($isFocused)
                        }
                        .frame(height: 48)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Submit button
                    Button(action: {
                        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                        onSubmit(text)
                        isPresented = false
                    }) {
                        HStack {
                            Spacer()
                            Text(buttonText)
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 15, weight: .semibold))
                            Spacer()
                        }
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                colors: !text.isEmpty
                                ? [Color.black, Color(.darkGray)]
                                : [Color(.systemGray3), Color(.systemGray4)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .shadow(
                            color: !text.isEmpty ? Color.black.opacity(0.25) : Color.clear,
                            radius: 10,
                            x: 0,
                            y: 6
                        )
                        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: !text.isEmpty)
                    }
                    .disabled(text.isEmpty)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isFocused = true
                    }
                }
            }
        }
    }
}

// MARK: - Loading Popup
struct LoadingPopup: View {
    let title: String
    let message: String
    
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var offset: CGFloat = 20
    @State private var rotationAngle: Double = 0
    
    init(
        title: String = "Loading",
        message: String = "Loading products, please wait..."
    ) {
        self.title = title
        self.message = message
    }
    
    var body: some View {
        ZStack {
            // Backdrop
            Color.black.opacity(0.1)
                .ignoresSafeArea()
                .opacity(opacity)
            
            // Popup Container
            VStack(spacing: 0) {
                VStack(spacing: 24) {
                    // Progress Circle
                    ZStack {
                        Circle()
                            .stroke(Color.black.opacity(0.1), lineWidth: 4)
                            .frame(width: 60, height: 60)
                        
                        Circle()
                            .trim(from: 0, to: 0.7)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.black, Color(.darkGray)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 4, lineCap: .round)
                            )
                            .frame(width: 60, height: 60)
                            .rotationEffect(Angle(degrees: rotationAngle))
                            .animation(
                                Animation.linear(duration: 1)
                                    .repeatForever(autoreverses: false),
                                value: rotationAngle
                            )
                    }
                    .padding(.top, 32)
                    
                    // Text content
                    VStack(spacing: 8) {
                        Text(title)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text(message)
                            .font(.system(size: 15, weight: .regular, design: .rounded))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 32)
                }
            }
            .frame(maxWidth: 320)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.15), radius: 30, x: 0, y: 15)
            )
            .padding(.horizontal, 24)
            .scaleEffect(scale)
            .offset(y: offset)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                opacity = 1
                scale = 1
                offset = 0
            }
            rotationAngle = 360
        }
        .onDisappear {
            rotationAngle = 0
        }
    }
}

// MARK: - Usage Examples
struct PopupExamplesView: View {
    @State private var showListPopup = false
    @State private var showConfirmPopup = false
    @State private var showInputPopup = false
    @State private var showLoadingPopup = false
    @State private var selectedItem = "None"
    @State private var inputText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    Text("Selected: \(selectedItem)")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    Text("Input: \(inputText)")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    // List Popup Button
                    Button("Show List Selection") {
                        showListPopup = true
                    }
                    .buttonStyle(buttonBlackWhiteStyle())
                    
                    // Confirmation Popup Button
                    Button("Show Confirmation") {
                        showConfirmPopup = true
                    }
                    .buttonStyle(buttonBlackWhiteStyle())
                    
                    // Input Popup Button
                    Button("Show Text Input") {
                        showInputPopup = true
                    }
                    .buttonStyle(buttonBlackWhiteStyle())
                    
                    Button("Show Loading Popup") {
                        showLoadingPopup = true
                        
                        // Simulate loading for 3 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            showLoadingPopup = false
                        }
                    }
                    .buttonStyle(buttonBlackWhiteStyle())
                }
                .navigationTitle("Popup Examples")
                
                // Popups
                if showListPopup {
                    ListSelectionPopup(
                        isPresented: $showListPopup,
                        title: "Select an Option",
                        subtitle: "Choose one item from the list below",
                        items: ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5"],
                        onSelect: { item in
                            selectedItem = item
                            showListPopup = false
                        }
                    )
                }
                
                if showConfirmPopup {
                    ConfirmationPopup(
                        isPresented: $showConfirmPopup,
                        title: "Confirm Action",
                        subtitle: "This action cannot be undone",
                        message: "Are you sure you want to proceed with this action?",
                        confirmText: "Delete",
                        cancelText: "Cancel",
                        isDestructive: true,
                        onConfirm: { confirmed in
                            selectedItem = confirmed ? "Confirmed" : "Cancelled"
                        }
                    )
                }
                
                if showInputPopup {
                    TextInputPopup(
                        isPresented: $showInputPopup,
                        title: "Enter Text",
                        subtitle: "Type something below",
                        placeholder: "Enter your text here...",
                        buttonText: "Submit",
                        onSubmit: { text in
                            inputText = text
                        }
                    )
                }
                if showLoadingPopup {
                    LoadingPopup(
                        title: "Loading",
                        message: "Loading products, please wait..."
                    )
                }
            }
        }
    }
}



#Preview {
    PopupExamplesView()
}
