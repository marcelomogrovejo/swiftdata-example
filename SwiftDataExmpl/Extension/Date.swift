//
//  Date.swift
//  SwiftDataExmpl
//
//  Created by Marcelo Mogrovejo on 06/08/2024.
//

import Foundation

extension Date {

    /// <#Description#>
    /// - Parameters:
    ///   - year: <#year description#>
    ///   - month: <#month description#>
    ///   - day: <#day description#>
    /// - Returns: <#description#>
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
}
