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

    private var modelContext: ModelContext
    private var expenses: [Expense] = [] {
        didSet {
            filteredExpenses = filterExpenses(expenses)
        }
    }

    // TODO: Move to a ChartViewModel file ??
    var filteredExpenses: [Expense] = [] {
        didSet {
            chunkedExpenses = chunkExpenses(filteredExpenses)
        }
    }

    var chunkedExpenses: [[Expense]] = []

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    /// Retrieves all the expenses
    ///
    func fetchAll() throws {
        do {
            let descriptor = FetchDescriptor<Expense>(sortBy: [SortDescriptor(\.date)])
            expenses = try modelContext.fetch(descriptor)
        } catch {
            print("fatal error: \(error.localizedDescription)")
        }
    }

    /// Removes an expense
    ///
    /// - Parameters:
    ///   - sectionIndex: Table section location
    ///   - indexSet: Table items location
    ///  
    /// > Tip: https://stackoverflow.com/questions/77120576/how-do-i-delete-child-items-from-list-with-swiftdata
    func deleteAt(sectionIndex: Int, indexSet: IndexSet) throws {
        for index in indexSet {
            do {
                let expenseToDeleteId = chunkedExpenses[sectionIndex][index].persistentModelID
                let expenseToDelete = modelContext.model(for: expenseToDeleteId)
                modelContext.delete(expenseToDelete)

                expenses.removeAll()

                do {
                    try modelContext.save()
                    try fetchAll()
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
    ///
    /// > Warning: It is used just when expenses array is flat array, not a chunked one.
    func deleteExpenseAt(indexSet: IndexSet) throws {
        for index in indexSet {
            modelContext.delete(expenses[index])

            do {
                try modelContext.save()

                /// List is refreshed however if fetchAll() is not here, chart is never refreshed.
                try fetchAll()
            } catch {
                print("Fatal error deleting expense: \(error.localizedDescription)")
            }
        }
    }

    /// Add a new expense
    /// 
    /// - Parameter expense: The expense model to be added
    func new(expense: Expense) throws {
        modelContext.insert(expense)
        do {
            try modelContext.save()
        } catch {
            print("Error saving the context: \(error.localizedDescription)")
        }
    }

    // MARK: - Private

    /// Filters an array of expenses by the current year
    ///
    /// - Parameter expenses: An array of expenses
    /// - Returns: A filtered by year array of expenses
    private func filterExpenses(_ expenses: [Expense]) -> [Expense] {
        let currentYear = Calendar.current.component(.year, from: .now)
        return expenses.filter { Calendar.current.component(.year, from: $0.date) == currentYear }
    }

    /// Chunks an array of expenses
    ///
    /// - Parameter expenses: An array of expenses
    /// - Returns: An array of arrays
    ///
    /// > Important: It implements 'chunked' from Swift Algorithms
    private func chunkExpenses(_ expenses: [Expense]) -> [[Expense]] {
        let chunkedExpenses = expenses.chunked { Calendar.current.isDate($0.date, equalTo: $1.date, toGranularity: .month) }
        let chunkedExpensesToReturn = chunkedExpenses.map { Array($0) }
        return chunkedExpensesToReturn
    }

}
