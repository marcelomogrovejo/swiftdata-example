//
//  Expense.swift
//  SwiftDataExmpl
//
//  Created by Marcelo Mogrovejo on 25/07/2024.
//

import Foundation
import SwiftData

@Model
class Expense: Hashable, Identifiable {    
    @Attribute(.unique)
    var id: UUID
    var title: String
    var date: Date
    var value: Double

    init(title: String, date: Date, value: Double) {
        self.id = UUID()
        self.title = title
        self.date = date
        self.value = value
    }
}
