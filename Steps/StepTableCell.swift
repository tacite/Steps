//
//  StepTableCell.swift
//  Steps
//
//  Created by David Tacite on 08/08/2023.
//

import SwiftUI

struct StepTableCell: View {
    
    @State var date: Date
    @State var value: Double
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 1) {
                Text(date.printDayLetter().capitalized)
                    .font(.callout)
                Text(date.printDayNumber())
                    .font(.caption)
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 5)
            .frame(maxWidth: .infinity)
            .background(.black.opacity(0.10))
            VStack(spacing: 1) {
                Text(String(format: "%.f", value))
                Text("steps")
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 5)
            .frame(maxWidth: .infinity)
            .background(.black.opacity(0.05))
        }
    }
}

#Preview {
    StepTableCell(date: Date(), value: 3000)
}
