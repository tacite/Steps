//
//  ContentView.swift
//  Steps
//
//  Created by David Tacite on 15/07/2023.
//

import SwiftUI
import HealthKit
import HealthKitUI

struct ContentView: View {
    
    @Environment(\.scenePhase) var scenePhase
    @Environment(StepsViewModel.self) private var vm
    @State var isPresented = false
    
    var body: some View {
            if vm.isAuthorized {
                GeometryReader { geometry in
                    VStack( spacing: 10) {
                        HStack {
                            StepRingView(maxSteps: Double(vm.stepTarget), currentSteps: vm.value, lineWidth: 35, gradient: Gradient(colors: [.red, .orange]))
                                .frame(width: geometry.size.width / 2)
                            Text("\(vm.value)/\(vm.stepTarget)")
                        }
                        StepsChartView()
                            .environment(vm)
                            .padding()
                        Button {
                            print("Re: weeklySteps : \(vm.weeklySteps)")
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundStyle(.red)
                                    .frame(width: 120, height: 40)
                                Text("Text Values")
                                    .foregroundStyle(.white)
                            }
                        }
                        Button {
                            self.isPresented.toggle()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(.blue)
                                    .frame(height: 40)
                                Text("Change goal")
                                    .foregroundStyle(.white)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .sheet(isPresented: $isPresented) {
                        GoalSheet()
                            .environment(vm)
                            .presentationDetents([.medium])
                            .presentationDragIndicator(.visible)
                    }
                    .onChange(of: scenePhase) { oldPhase, newPhase in
                        if newPhase == .active {
                            print("RE: Active")
                            vm.readStepCount()
                        } else if newPhase == .inactive {
                            print("RE: Inactive")
                        } else if newPhase == .background {
                            print("RE: Background")
                        }
                    }
                    .onAppear {
                        print("RE: toto")
                        vm.readStepCount()
                        vm.fillWeeklySteps()
                        vm.fillMonthlySteps()
                        vm.fillDailySteps()
                    }
                }
            } else {
                VStack {
                    Text("Authorize Health")
                        .font(.title)
                    Button {
                        vm.setupHealthRequest()
                    } label: {
                        Text("Authorize HealthKit")
                            .font(.headline)
                            .foregroundStyle(Color.white)
                    }
                    .frame(width: 300, height: 100)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
            }
        }
//        .padding()
}

#Preview {
    ContentView()
        .environment(StepsViewModel())
}
