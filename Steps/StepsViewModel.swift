//
//  StepsViewModel.swift
//  Steps
//
//  Created by David Tacite on 15/07/2023.
//

import Foundation
import HealthKit
import Observation


@Observable class StepsViewModel {
    var healthStore = HKHealthStore()
    var isAuthorized = false
    var value: Double = 0
    var stepTarget: Int = 7000
    var recentSteps: [Double] = []
    var weeklySteps : [StepsData] = []
    var monthlySteps: [StepsData] = []
    var dailySteps: [StepsData] = []
    
    init() {
        changeAuthorizationStatus()
        populateSteps()
    }
    
    func setupHealthRequest() {
        if HKHealthStore.isHealthDataAvailable(), let steps = HKObjectType.quantityType(forIdentifier: .stepCount) {
            healthStore.requestAuthorization(toShare: [steps], read: [steps]) { success, error in
                if success {
                    self.isAuthorized = true
                    print("access granted")
                } else {
                    print("soucis d'access poto")
                }
            }
        }
    }
    
    func readStepCount() {
        guard let stepQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        let now = Date()
        let startOfTheDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfTheDay, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepQuantityType, quantitySamplePredicate: predicate) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else { return }
            self.value = sum.doubleValue(for: HKUnit.count())
        }
        self.healthStore.execute(query)
    }
    
    func getStepByDate(_ startDate: Date, _ endDate: Date, completion: @escaping (Double) -> Void) {
        guard let stepQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        let query = HKStatisticsQuery(quantityType: stepQuantityType, quantitySamplePredicate: predicate) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        self.healthStore.execute(query)
    }
    
    // TODO: - Change date to int value
    func fillWeeklySteps() {
        var endDate = Date()
        var beginDay = endDate.getStartOfDay()
        
        for _ in 0...6 {
            if let yesterday = beginDay {
                getStepByDate(yesterday, endDate) { step in
                    DispatchQueue.main.async {
                        if let newIndex = self.weeklySteps.firstIndex(where: {$0.date == yesterday}) {
                            self.weeklySteps[newIndex].steps = step
                        }
                    }
                }
                endDate = yesterday
                beginDay = endDate.getYesterday()
            }
        }
    }
    
    func fillMonthlySteps() {
        var endDate = Calendar.current.startOfDay(for: Date())
        var beginDate = Date()
        let numberOfMonths = Calendar.current.component(.month, from: endDate)
        
        for _ in 1...numberOfMonths {
            if let beginning = beginDate.getStartOfMonth() {
                let numDays = Calendar.current.dateComponents([.day], from: beginning, to: endDate).day
                getStepByDate(beginning, endDate) { step in
                    if step != 0.0, let numb = numDays {
                        DispatchQueue.main.async {
                            if let index = self.monthlySteps.firstIndex(where: {$0.date == beginning}) {
                                self.monthlySteps[index].steps = step / Double(numb)
                            }
                        }
                    }
                }
                endDate = beginning
                beginDate = beginning.getPreviousMonth()!
            }
        }
    }
    
    func fillDailySteps() {
        var endDate = Date()
        var beginDate = endDate.getStartOfHour()
        let numberOfHours = Calendar.current.component(.hour, from: endDate)
        
        print("Re: hours: \(numberOfHours)")
        for _ in 0...numberOfHours {
            if let beginning = beginDate {
                getStepByDate(beginning, endDate) { step in
                    DispatchQueue.main.async {
                        if let index = self.dailySteps.firstIndex(where: {$0.date == beginning}) {
                            print("Re: debut: \(beginning.printDate()) ::: steps : \(step)")
                            self.dailySteps[index].steps = step
                        }
                    }
                }
                endDate = beginning
                beginDate = endDate.getPreviousHour()
            }
        }
    }
    
    func changeAuthorizationStatus() {
        guard let stepsType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
        let status = healthStore.authorizationStatus(for: stepsType)
        
        switch status {
        case .notDetermined:
            isAuthorized = false
        case .sharingDenied:
            isAuthorized = false
        case .sharingAuthorized:
            isAuthorized = true
        default:
            isAuthorized = false
        }
    }
    
    private func populateSteps() {
        populateDailySteps()
        populateWeeklySteps()
        populateMonthlySteps()
    }
    
    private func populateDailySteps() {
        guard let date = Date().getStartOfDay() else { return }
        
        for index in  0...23 {
            if let nextHour = date.getNextHour(index) {
                self.dailySteps.append(.init(date: nextHour, steps: 0))
            }
        }
    }
    
    private func populateWeeklySteps() {
        guard let date = Date().getStartOfDay() else { return }
        
        for index in 0...6 {
            if let previousDay = date.getPreviousDay(index) {
                self.weeklySteps.append(.init(date: previousDay, steps: 0))
            }
        }
    }
    
    private func populateMonthlySteps() {
        guard let date = Date().getStartOfYear() else { return }
        
        for index in 0...11 {
            if let nextMonth = date.getNextMonth(index) {
                self.monthlySteps.append(.init(date: nextMonth, steps: 0))
            }
        }
    }
}

struct StepsData {
    let date: Date
    var steps: Double
}
