//
//  StepsTableView.swift
//  Steps
//
//  Created by David Tacite on 05/08/2023.
//

import SwiftUI

struct StepsTableView: View {
    @Environment(StepsViewModel.self) private var vm
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(vm.weeklySteps, id: \.date) { data in
                    StepTableCell(date: data.date, value: data.steps)
                }
            }
        }
    }
}

#Preview {
    StepsTableView()
        .environment(StepsViewModel())
}
