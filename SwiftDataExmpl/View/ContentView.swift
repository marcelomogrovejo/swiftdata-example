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

    @State private var viewModel: ExpenseViewModel

    // TODO: figure out how to move to the viewModel as well
    // or to a ChartViewModel file
    var filteredExpenses: [Expense] {
        let currentYear = calendar.component(.year, from: .now)
        return viewModel.expenses.filter { calendar.component(.year, from: $0.date) == currentYear }
    }
    // TODO: figure out how to move to the viewModel as well
    // Algorithms - 'chinked'
    var chunkedExpenses: [[Expense]] {
        let chunkedExpenses = filteredExpenses.chunked { calendar.isDate($0.date, equalTo: $1.date, toGranularity: .month) }
        return chunkedExpenses.map { Array($0) }
    }
    
    @State private var isShowingItemSheet = false
    // Editing
    @State private var expenseToEdit: Expense?

    init(modelContext: ModelContext) {
        let expenseViewModel = ExpenseViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: expenseViewModel)
    }

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
                        viewModel.deleteAt(indexSet: indexSet)
                    }
                }
            }
            .navigationTitle("Expenses")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingItemSheet, onDismiss: { viewModel.fetchAll() }) { AddExpenseSheet().environment(viewModel) }
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
            .onAppear {
                viewModel.fetchAll()
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
    return ContentView(modelContext: container.mainContext)
        .modelContainer(container)
}
