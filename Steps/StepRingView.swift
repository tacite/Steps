//
//  StepRingView.swift
//  Steps
//
//  Created by David Tacite on 31/07/2023.
//

import SwiftUI

struct StepRingView: View {
    
    var maxSteps: Double
    var currentSteps: Double
    var lineWidth: CGFloat
    var gradient: Gradient
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(.blue.opacity(0.1), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: CGFloat(currentSteps / maxSteps))
                .rotation(.degrees(-90))
                .stroke(
                    AngularGradient(gradient: gradient,
                                    center: .center,
                                    startAngle: .degrees(-90),
                                    endAngle: .degrees(((currentSteps / maxSteps) * 360) - 90)),
                    style: .init(lineWidth: lineWidth, lineCap: .round))
                .overlay {
                    GeometryReader { geo in
                        Circle()
                            .fill(gradient.stops[1].color)
                            .frame(width: lineWidth, height: lineWidth)
                            .position(x: geo.size.width / 2, y: geo.size.height / 2)
                            .offset(x: min(geo.size.width, geo.size.height) / 2)
                            .rotationEffect(.degrees(((currentSteps / maxSteps) * 360 ) - 90))
                            .shadow(color: .black, radius: 3)
                    }
                    .clipShape(
                        Circle()
                            .rotation(.degrees(-90 + (currentSteps / maxSteps) * 360 - 0.5))
                            .trim(from: 0, to: 0.25)
                            .stroke(style: .init(lineWidth: lineWidth))
                    )
                }
            /*            VStack {
                    Text("Steps")
                        .font(.largeTitle)
                        .padding(1)
                    Text("\(String(format: "%.f", currentSteps)) / \(String(format: "%.f", maxSteps))")
                        .font(.system(size: 30))
                        .bold()
            }*/
        }
        .padding(lineWidth)
    }
}

#Preview {
    StepRingView(maxSteps: 7000, currentSteps: 1000, lineWidth: 35, gradient: Gradient(colors: [.red, .purple]))
}
