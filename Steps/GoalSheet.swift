//
//  GoalSheet.swift
//  Steps
//
//  Created by David Tacite on 28/07/2023.
//

import SwiftUI

struct GoalSheet: View {

    @Environment(StepsViewModel.self) private var vm
    @Environment(\.dismiss) var dismiss
    @State var stepTarget = 0
    private var maxGoal = 20000
    private var minGoal = 3000
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.1)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    Text("Edit Goal")
                        .bold()
                        .font(.title)
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "x.circle")
                            .foregroundStyle(.gray)
                    }
                    .offset(x: -25)
                }
                .padding(.top, 10)
                .padding(.bottom, 40)
                Text("Everyday, I want to walk at least")
                    .fontWeight(.bold)
                Text("\(String(stepTarget)) steps")
                    .foregroundStyle(.blue)
                    .underline()
                    .padding(.bottom, 15)
                HStack {
                    Button {
                        if stepTarget > minGoal {
                            stepTarget -= 1000
                        }
                    } label: {
                        Image(systemName: "minus.circle")
                    }
                    .disabled(stepTarget > minGoal ? false : true)
                    .padding(.leading, 10)
                    Text("\(String(stepTarget)) steps")
                        .padding(.horizontal, 50)
                    Button {
                        if stepTarget < maxGoal {
                            stepTarget += 1000
                        }
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                    .disabled(stepTarget < maxGoal ? false : true)
                    .padding(.trailing, 10)
                }
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.white)
                        .frame(height: 60)
                        .shadow(color: .black, radius: 3)
                }
                .padding(.vertical, 40)
                Button {
                    vm.stepTarget = stepTarget
                    dismiss()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(height: 40)
                            .foregroundStyle(.blue)
                        Text("Save")
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 10)
            }
            .onAppear {
                stepTarget = vm.stepTarget
            }
        }
        
    }
}

#Preview {
    GoalSheet()
        .environment(StepsViewModel())
        .presentationDetents([.medium])
}
