//
//  LeftCapsuleShape.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 12/11/25.
//

import SwiftUI

struct LeftCapsuleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let radius = rect.height / 2
        
        // Comenzar desde arriba a la izquierda
        path.move(to: CGPoint(x: radius, y: 0))
        
        // Línea superior
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        
        // Línea derecha (recta)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        
        // Línea inferior
        path.addLine(to: CGPoint(x: radius, y: rect.maxY))
        
        // Semicírculo izquierdo
        path.addArc(center: CGPoint(x: radius, y: rect.midY),
                    radius: radius,
                    startAngle: .degrees(90),
                    endAngle: .degrees(270),
                    clockwise: false)
        
        return path
    }
}
