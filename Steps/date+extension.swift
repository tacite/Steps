//
//  date+extension.swift
//  Steps
//
//  Created by David Tacite on 05/08/2023.
//

import Foundation

extension Date {
    func getYesterday() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
    
    func getPreviousDay(_ byNumberOfDays: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: -byNumberOfDays, to: self)
    }
    
    func getPreviousMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
    
    func getPreviousHour() -> Date? {
        return Calendar.current.date(byAdding: .hour, value: -1, to: self)
    }
    
    func getNextMonth(_ byNumberOfMonth: Int) -> Date? {
        return Calendar.current.date(byAdding: .month, value: byNumberOfMonth, to: self)
    }
    
    func getNextMinutes(_ byNumberOfMinutes: Int) -> Date? {
        return Calendar.current.date(byAdding: .minute, value: byNumberOfMinutes, to: self)
    }
    
    func getNextDays(_ byNumberOfDays: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: byNumberOfDays, to: self)
    }
    
    func getNextHour(_ index : Int) -> Date? {
        return Calendar.current.date(byAdding: .hour, value: index, to: self)
    }
    
    func getStartOfMonth() -> Date? {
        let componnent = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: componnent)
    }
    
    func getStartOfYear() -> Date? {
        let componnent = Calendar.current.dateComponents([.year], from: self)
        return Calendar.current.date(from: componnent)
    }
    
    func getStartOfHour() -> Date? {
        let componnent = Calendar.current.dateComponents([.year, .month, .day, .hour], from: self)
        return Calendar.current.date(from: componnent)
    }
    
    func getStartOfDay() -> Date? {
        let componnent = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: componnent)
    }
    
    func isDateInLegend() -> Bool {
        let valuesAccepted = [0, 6, 12, 18]
        let hour = Calendar.current.component(.hour, from: self)
        if valuesAccepted.contains(hour) {
            return true
        }
        return false
    }
    
    func printDayLetter() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return(dateFormatter.string(from: self))
    }
    
    func printDayNumber() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return(dateFormatter.string(from: self))
    }
    
    func printHourNumber() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return(dateFormatter.string(from: self))
    }
    
    func printDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        return(dateFormatter.string(from: self))
    }
}
