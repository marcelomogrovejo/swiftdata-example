//
//  ContentView.swift
//  SwiftDataExmpl
//
//  Created by Marcelo Mogrovejo on 25/07/2024.
//

import SwiftUI
import SwiftData

struct ExpenseView: View {

    @State private var viewModel: ExpenseViewModel

    // TODO: move to viewModel ??
    @State private var isShowingItemSheet = false
    // Editing
    @State private var expenseToEdit: Expense?

    init(modelContext: ModelContext) {
        #if DEBUG
        print(modelContext.sqliteCommand)
        #endif

        let expenseViewModel = ExpenseViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: expenseViewModel)
    }

    var body: some View {
        NavigationStack {
            List {
                /// Chart section
                if !viewModel.filteredExpenses.isEmpty {
                    Section {
                        CharView(expenses: viewModel.filteredExpenses)
                    }
                }

                /// Expenses section
                Section {
                    ForEach(viewModel.chunkedExpenses.indices, id: \.self) { sectionIndex in
                        DisclosureGroup {
                            ForEach(viewModel.chunkedExpenses[sectionIndex], id: \.id) { expense in
                                ExpenseCell(expense: expense)
                                    .onTapGesture {
                                        expenseToEdit = expense
                                    }
                            }
                            .onDelete { indexSet in
                                viewModel.deleteAt(sectionIndex: sectionIndex, indexSet: indexSet)
                            }
                        } label: {
                            Text(viewModel.chunkedExpenses[sectionIndex][0].date.formatted(.dateTime.month(.wide)))
                        }
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
                if !viewModel.filteredExpenses.isEmpty {
                    Button("Add Expense", systemImage: "plus") {
                        isShowingItemSheet = true
                    }
                }
            }
            .overlay {
                if viewModel.filteredExpenses.isEmpty {
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
            .onAppear() {
                viewModel.fetchAll()
            }
            .padding(.top, 20)
            .padding(.bottom, 20)
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
    return ExpenseView(modelContext: container.mainContext)
        .modelContainer(container)
}
