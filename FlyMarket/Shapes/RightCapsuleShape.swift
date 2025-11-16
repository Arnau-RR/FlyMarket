//
//  RightCapsuleShape.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 12/11/25.
//

import SwiftUI

struct RightCapsuleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let radius = rect.height / 2
        
        // Comenzar desde arriba a la izquierda
        path.move(to: CGPoint(x: 0, y: 0))
        
        // Línea superior
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: 0))
        
        // Semicírculo derecho
        path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.midY),
                    radius: radius,
                    startAngle: .degrees(270),
                    endAngle: .degrees(90),
                    clockwise: false)
        
        // Línea inferior
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        
        // Línea izquierda (recta)
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        return path
    }
}
