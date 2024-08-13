//
//  ExpenseViewModel.swift
//  SwiftDataExmpl
//
//  Created by Marcelo Mogrovejo on 10/08/2024.
//

import SwiftUI
import SwiftData
import Algorithms
import Observation

@Observable
class ExpenseViewModel {
    
    /// Important: The @Query macro works only when it can access the SwiftUI environment,
    /// which makes it incompatible with MVVM.
    ///
    //    @Environment(\.modelContext) var context
    /// Option 1 Fetch
    //    @Query
    /// Option 2 Fetch sorting
    //    @Query(sort: \Expense.date)
    /// Option 3 Fetch filtering
    //    @Query(filter: #Predicate<Expense> { $0.value > 100 }, sort: \Expense.date)
    //    var expenses: [Expense] // not needed anymore = []
    //    var expenses: [Expense]
    /// //
    
    private let calendar = Calendar.current
    private var modelContext: ModelContext
    /*private*/ var expenses: [Expense] = []

    // or to a ChartViewModel file
    var filteredExpenses: [Expense] {
        let currentYear = calendar.component(.year, from: .now)
        return expenses.filter { calendar.component(.year, from: $0.date) == currentYear }
    }

    // Algorithms - 'chunked'
    var chunkedExpenses: [[Expense]] {
        let chunkedExpenses = filteredExpenses.chunked { calendar.isDate($0.date, equalTo: $1.date, toGranularity: .month) }
        return chunkedExpenses.map { Array($0) }
    }

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    /// Retrieves all the expenses
    ///
    func fetchAll() {
        do {
            let descriptor = FetchDescriptor<Expense>(sortBy: [SortDescriptor(\.date)])
            expenses = try modelContext.fetch(descriptor)
            for expense in expenses {
                print(expense.title)
            }
        } catch {
            print("fatal error: \(error.localizedDescription)")
        }
    }

    /// Removes an expense
    ///
    /// - Parameters:
    ///   - sectionIndex: <#sectionIndex description#>
    ///   - indexSet: <#indexSet description#>
    func deleteAt(sectionIndex: Int, indexSet: IndexSet) {
        print("sectionIndex: \(sectionIndex)")
        for index in indexSet {
            print("idx: \(index)")

            do {
                let expenseToDelete = chunkedExpenses[sectionIndex][index]
                print(expenseToDelete.title)
                modelContext.delete(expenseToDelete)
                do {
                    try modelContext.save()

                    
                    // TODO: it is updating the expenses array but some way it is not refreshing filteredExpenses and chunkedExpenses
                    // Option 1: remove filtered and chunked and try to make it work just to expenses. Then, when it is working as
                    // expected, implement filtered and chunked.
                    
                    // TODO: figure out if it is needed to fetchAll() here. Confirm if there is another way to refresh the context.
                    
                    fetchAll()
                } catch {
                    print("Error deleting expense model: \(error.localizedDescription)")
                    // Handle error
                }
            }
        }
    }

    /// Removes an expense on the given location
    ///
    /// - Parameter indexSet: Table items location
    func deleteExpenseAt(indexSet: IndexSet) {
        for index in indexSet {
            print("idx: \(index)")
            print("expense: \(expenses[index].title)")
            modelContext.delete(expenses[index])

            do {
                try modelContext.save()

                /// List is refreshed however if fetchAll() is not here, chart is never refreshed.
                fetchAll()
            } catch {
                print("Fatal error deleting expense: \(error.localizedDescription)")
            }
        }
    }

    /// Add a new expense
    /// 
    /// - Parameter expense: The expense model to be added
    func new(expense: Expense) {
        modelContext.insert(expense)
        do {
            try modelContext.save()
        } catch {
            print("Error saving the context: \(error.localizedDescription)")
        }
    }

}
