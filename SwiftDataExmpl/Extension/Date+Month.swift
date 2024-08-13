//
//  Date+Month.swift
//  SwiftDataExmpl
//
//  Created by Marcelo Mogrovejo on 06/08/2024.
//

import Foundation

extension Date {

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - year: <#year description#>
    ///   - month: <#month description#>
    ///   - day: <#day description#>
    /// - Returns: <#description#>
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
    
    
    /// Add or subtract months to the currect date
    ///
    /// - Parameter month: Cant of months to be added or substracted
    /// - Returns: A new date
    func addOrSubtractMonth(_ month: Int, calendar: Calendar = Calendar.current) -> Date {
        calendar.date(byAdding: .month, value: month, to: Date())!
    }

//    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
//        return calendar.dateComponents(Set(components), from: self)
//    }

    
    /// Get the month from the current date
    ///
    /// https://stackoverflow.com/questions/53356392/how-to-get-day-and-month-from-date-type-swift-4
    ///
    /// - Parameters:
    ///   - component: Date component (ie: day, month, year)
    ///   - calendar: Calendar
    /// - Returns: The integer value corresponding to the current month
    func get(_ component: Calendar.Component = .month, calendar: Calendar = Calendar.current) -> Int {
        calendar.component(component, from: self)
    }
}
