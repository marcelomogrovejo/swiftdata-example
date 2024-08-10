//
//  ExpenseViewModel.swift
//  SwiftDataExmpl
//
//  Created by Marcelo Mogrovejo on 10/08/2024.
//

import SwiftUI
import SwiftData

@Observable
class ExpenseViewModel {

     /// Important: The @Query macro works only when it can access the SwiftUI environment,
     /// which makes it incompatible with MVVM.
//    @Environment(\.modelContext) var context
    // Option 1 Fetch
//    @Query
    // Option 2 Fetch sorting
//    @Query(sort: \Expense.date)
    // Option 3 Fetch filtering
//    @Query(filter: #Predicate<Expense> { $0.value > 100 }, sort: \Expense.date)
//    var expenses: [Expense] // not needed anymore = []
//    var expenses: [Expense]
    /// //

    var modelContext: ModelContext
    var expenses: [Expense] = []

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchAll() {
        do {
            let descriptor = FetchDescriptor<Expense>(sortBy: [SortDescriptor(\.date)])
            expenses = try modelContext.fetch(descriptor)
        } catch {
            print("fatal error: \(error.localizedDescription)")
        }
    }

    func deleteAt(indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(expenses[index])
        }
    }

    func new(expense: Expense) {
        modelContext.insert(expense)

        do {
            try modelContext.save()
        } catch {
            print("Error saving the context: \(error.localizedDescription)")
        }
    }
}
