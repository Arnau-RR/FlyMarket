//
//  SeatMapView.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 13/11/25.
//

import SwiftUI

struct SeatMapView: View {
    @Binding var selectedSeat: String?
    @Binding var isPresented: Bool
    
    let columns = ["A", "B", "C", "D", "E", "F"]
    let rows = Array(4...24)
    
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
                    
                    Divider()
                    
                    seatLegend
                    
                    // Mapa de asientos en scroll
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 12) {
                            ForEach(rows, id: \.self) { row in
                                HStack(spacing: 0) {
                                    Text("\(row)")
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(.secondary)
                                        .frame(width: 30)
                                    
                                    HStack(spacing: 8) {
                                        ForEach(0..<3) { index in
                                            SeatButton(
                                                seatLabel: "\(columns[index])\(row)",
                                                isSelected: selectedSeat == "\(columns[index])\(row)"
                                            ) {
                                                selectedSeat = "\(columns[index])\(row)"
                                            }
                                        }
                                    }
                                    
                                    Spacer()
                                        .frame(width: 30)
                                    
                                    HStack(spacing: 8) {
                                        ForEach(3..<6) { index in
                                            SeatButton(
                                                seatLabel: "\(columns[index])\(row)",
                                                isSelected: selectedSeat == "\(columns[index])\(row)"
                                            ) {
                                                selectedSeat = "\(columns[index])\(row)"
                                            }
                                        }
                                    }
                                    
                                    Text("\(row)")
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .foregroundColor(.secondary)
                                        .frame(width: 30)
                                }
                            }
                        }
                        .padding(.vertical, 12)
                    }
                    .frame(maxHeight: 320)
                    
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

// MARK: - UI Components
extension SeatMapView {
    
    private var titleBanner: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.black)
                    .frame(width: 42, height: 42)
                    .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 4)
                
                Image(systemName: "airplane.circle.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Seat Selection")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Choose your preferred seat for a comfortable journey.")
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
            
        }
    }
    
    private var seatLegend: some View {
        HStack(spacing: 20) {
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.blue.opacity(0.7))
                    .frame(width: 30, height: 30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                    )
                
                Text("Available")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.green)
                    .frame(width: 30, height: 30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.green.opacity(0.8), lineWidth: 2)
                    )
                
                Text("Selected")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
    
    private var confirmButton: some View {
        Button(action: {
            isPresented = false
        }) {
            HStack {
                Spacer()
                Text(selectedSeat != nil ? "Confirm Seat \(selectedSeat!)" : "Select a Seat")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                if selectedSeat != nil {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .semibold))
                }
                Spacer()
            }
            .padding(.vertical, 14)
            .background(
                LinearGradient(
                    colors: selectedSeat != nil
                    ? [Color.black, Color(.darkGray)]
                    : [Color(.systemGray3), Color(.systemGray4)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(16)
            .shadow(
                color: selectedSeat != nil
                ? Color.black.opacity(0.25)
                : Color.clear,
                radius: 10,
                x: 0,
                y: 6
            )
            .scaleEffect(selectedSeat != nil ? 1.0 : 0.99)
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: selectedSeat)
        }
        .disabled(selectedSeat == nil)
        .padding(.top, 8)
    }
}

struct SeatButton: View {
    let seatLabel: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 6)
                .fill(isSelected ? Color.green : Color.blue.opacity(0.7))
                .frame(width: 35, height: 35)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(isSelected ? Color.green.opacity(0.8) : Color.gray.opacity(0.3), lineWidth: 2)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    @Previewable @State var selectedSeat: String? = nil
    @Previewable @State var isPresented = true
    
    SeatMapView(selectedSeat: $selectedSeat, isPresented: $isPresented)
}
