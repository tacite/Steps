//
//  StepsChartView.swift
//  Steps
//
//  Created by David Tacite on 12/08/2023.
//

import SwiftUI
import Charts

enum ChartSelected: String, CaseIterable {
    case day = "Day"
    case week = "Week"
    case year = "Year"
}

struct StepsChartView: View {
    @Environment(StepsViewModel.self) private var vm
    @State private var chartSelected: ChartSelected = .week
    @State private var rawSelectedDate: Date?
    @State private var selectedValue: StepsData? = nil
    
    var body: some View {
        VStack {
            Picker("", selection: $chartSelected) {
                ForEach(ChartSelected.allCases, id:\.rawValue) { type in
                    Text(type.rawValue)
                        .tag(type)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .padding(.bottom, 80)
            
            Chart {
                ForEach(getSelectedChart(), id: \.date) { data in
                    BarMark(x: .value("day", data.date, unit: getSelectedComponnent()),
                            y: .value("steps", data.steps))
                    .foregroundStyle(.blue.gradient)
                    .cornerRadius(3)
                }
                if let selectedValue, selectedValue.steps != 0 {
                    RuleMark(x: .value("Selected", self.getSelectedValue(from: selectedValue.date)))
                        .foregroundStyle(.gray.opacity(0.3))
                        .zIndex(-1)
                        .annotation(
                            position: .top,
                            spacing: 10,
                            overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                                Text("\(String(format: "%.f", selectedValue.steps)) steps")
                                .padding()
                                .background(.gray.opacity(0.1))
                        }
                }
            }
            .chartXAxis {
                let chart = getSelectedChart()
                if chartSelected == .day {
                    AxisMarks(values: chart.filter { $0.date.isDateInLegend()}.map { $0.date }) { date in
                        AxisGridLine()
                        AxisValueLabel() {
                            if let date = date.as(Date.self) {
                                Text("\(date.printHourNumber()) h")

                            }
                        }
                    }
                } else {
                    AxisMarks(values: chart.map { $0.date}) { date in
                        if chartSelected == .week {
                            AxisValueLabel() {
                                if let date = date.as(Date.self) {
                                    Text("\(date.printDayLetter()).")
                                }
                            }
                        } else {
                            AxisValueLabel(format: .dateTime.month(.narrow))
                        }
                        AxisGridLine()
                    }
                }
            }
            .chartXSelection(value: $rawSelectedDate)
            .onChange(of: rawSelectedDate) { oldValue, newValue in
                if let newValue {
                    let componnent = getSelectedNewValueComponnent(from: newValue)
                    if let newDateCorrected = Calendar.current.date(from: componnent) {
                        selectedValue = fillSelectedValue(from: newDateCorrected)
                    }
                } else {
                    selectedValue = nil
                }
            }
            .onTapGesture {
                print("Re: Tap gesture")
                print("Re: Value of rawSelectedData : \(rawSelectedDate)")
            }
            
            //            .animation(.smooth, value: chartSelected)
        }
    }
    
    private struct DailyChart: View {
        var body: some View {
            Text("toto")
        }
    }
    
    private func fillSelectedValue(from: Date) -> StepsData? {
        switch chartSelected {
        case .day:
            return vm.dailySteps.first(where: { $0.date == from})
        case .week:
            return vm.weeklySteps.first(where: { $0.date == from})
        case .year:
            return vm.monthlySteps.first(where: { $0.date == from})
        }
    }
    
    private func getSelectedNewValueComponnent(from: Date) -> DateComponents {
        switch chartSelected {
        case .day:
            return Calendar.current.dateComponents([.year, .month, .day, .hour], from: from)
        case .week:
            return Calendar.current.dateComponents([.year, .month, .day], from: from)
        case .year:
            return Calendar.current.dateComponents([.year, .month], from: from)
        }
    }
    
    private func getSelectedValue(from: Date) -> Date {
        switch chartSelected {
        case .day:
            if let value = from.getNextMinutes(30) { return value }
        case .week:
            if let value = from.getNextHour(12) { return value }
        case .year:
            if let value = from.getNextDays(14) { return value }
        }
        return Date()
    }
    
    private func getSelectedChart() -> [StepsData] {
        switch chartSelected {
        case .day:
            return vm.dailySteps
        case .week:
            return vm.weeklySteps
        case .year:
            return vm.monthlySteps
        }
    }
    
    private func getSelectedComponnent() -> Calendar.Component {
        switch chartSelected {
        case .day:
            return .hour
        case .week:
            return .day
        case .year:
            return .month
        }
    }
}

#Preview {
    StepsChartView()
        .environment(StepsViewModel())
}
