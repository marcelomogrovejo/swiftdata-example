//
//  ContentView.swift
//  SwiftDataExmpl
//
//  Created by Marcelo Mogrovejo on 25/07/2024.
//

import SwiftUI
import SwiftData
import Algorithms

struct ContentView: View {

    let calendar = Calendar.current

    // To delete we need access to the context
    @Environment(\.modelContext) var context
    @State private var isShowingItemSheet = false
    // Option 1 Fetch
//    @Query
    // Option 2 Fetch sorting
    @Query(sort: \Expense.date)
    // Option 3 Fetch filtering
//    @Query(filter: #Predicate<Expense> { $0.value > 100 }, sort: \Expense.date)
//    var expenses: [Expense] // not needed anymore = []
    var expenses: [Expense]

    var filteredExpenses: [Expense] {
        let currentYear = calendar.component(.year, from: .now)
        return expenses.filter { calendar.component(.year, from: $0.date) == currentYear }
    }
    //
    var chunkedExpenses: [[Expense]] {
        let chunkedExpenses = filteredExpenses.chunked { calendar.isDate($0.date, equalTo: $1.date, toGranularity: .month) }
        return chunkedExpenses.map { Array($0) }
    }
    // Editing
    @State private var expenseToEdit: Expense?

    var body: some View {
        NavigationStack {
            List {
                if !filteredExpenses.isEmpty {
                    Section {
                        CharView(expenses: filteredExpenses)
                    }
                }

                Section {
                    ForEach(chunkedExpenses, id: \.self) { expenses in
                        DisclosureGroup {
                            ForEach(expenses) { expense in
                                ExpenseCell(expense: expense)
                                    .onTapGesture {
                                        expenseToEdit = expense
                                    }
                            }
                        } label: {
                            Text(expenses.first!.date.formatted(.dateTime.month(.wide)))
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            context.delete(expenses[index])
                            // We can manualy save the context or just use the built-in auto-save
                        }
                    }
                }
            }
            .navigationTitle("Expenses")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingItemSheet) { AddExpenseSheet() }
            .sheet(item: $expenseToEdit) { expense in
                UpdateExpenseSheet(expense: expense)
            }
            .toolbar {
                if !filteredExpenses.isEmpty {
                    Button("Add Expense", systemImage: "plus") {
                        isShowingItemSheet = true
                    }
                }
            }
            .overlay {
                if filteredExpenses.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No Expenses", systemImage: "list.bullet.rectangle.portrait")
                    }, description: {
                        Text("Start adding expenses to see your list.")
                    }, actions: {
                        Button("Add Expense") { isShowingItemSheet = true }
                    })
                    .offset(y: -60)
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Expense.self, configurations: config)
    for i in 1...12 {
        let randomDouble = Double.random(in: 10...100)
        let expnese = Expense(title: "Expense \(i)", date: Date.from(year: 2024, month: i, day: 1), value: randomDouble)
        container.mainContext.insert(expnese)
    }
    return ContentView().modelContainer(container)
}
