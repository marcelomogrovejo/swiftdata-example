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
    // Fetch
    @Query(sort: \Expense.date)
    // Fetch filtering
//    @Query(filter: #Predicate<Expense> { $0.value > 100 }, sort: \Expense.date)
//    var expenses: [Expense] // not needed anymore = []
    var expenses: [Expense]
    
    var chunkedExpenses: [[Expense]] {
        let chunkedExpenses = expenses.chunked { calendar.isDate($0.date, equalTo: $1.date, toGranularity: .month) }
        return chunkedExpenses.map { Array($0) }
    }
    // Editing
    @State private var expenseToEdit: Expense?

    var body: some View {
        NavigationStack {
            List {
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
            .navigationTitle("Expenses")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingItemSheet) { AddExpenseSheet() }
            .sheet(item: $expenseToEdit) { expense in
                UpdateExpenseSheet(expense: expense)
            }
            .toolbar {
                if !expenses.isEmpty {
                    Button("Add Expense", systemImage: "plus") {
                        isShowingItemSheet = true
                    }
                }
            }
            .overlay {
                if expenses.isEmpty {
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
    ContentView()
}
