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

            VStack(alignment: .center) {
                /// Chart section
                if !viewModel.filteredExpenses.isEmpty {
                    ChartView(expenses: viewModel.filteredExpenses)

                    /** WORKS with a flat expenses array! */
//                        ChartView(expenses: viewModel.expenses)
                }

                List {
                    /// Expenses section
                    Section {
                        ForEach(viewModel.chunkedExpenses.indices, id: \.self) { sectionIndex in
                            DisclosureGroup {
                                ForEach(viewModel.chunkedExpenses[sectionIndex], id: \.id) { expense in
                                    ExpenseRowView(expense: expense)
                                        .onTapGesture {
                                            expenseToEdit = expense
                                        }
                                }
                                .onDelete { indexSet in
                                    do {
                                        try viewModel.deleteAt(sectionIndex: sectionIndex, indexSet: indexSet)
                                    } catch {
                                        fatalError("Failed to delete expenses")
                                    }
                                }
                            } label: {
                                Text(viewModel.chunkedExpenses[sectionIndex][0].date.formatted(.dateTime.month(.wide)))
                            }
                        }

                        /** WORKS with a flat expenses array! */
                        /*
                        ForEach(viewModel.expenses, id: \.id) { expense in
                            ExpenseRowView(expense: expense)
                                .onTapGesture {
                                    expenseToEdit = expense
                                }
                        }
                        .onDelete { indexSet in
                            viewModel.deleteExpenseAt(indexSet: indexSet)
                        }
                         */
                    }
                }
                .navigationTitle("Expenses")
                .navigationBarTitleDisplayMode(.large)
                .sheet(isPresented: $isShowingItemSheet, onDismiss: {
                    do {
                        try viewModel.fetchAll()
                    } catch {
                        fatalError("Failed to fetch expenses")
                    }}) {
                        AddExpenseSheetView().environment(viewModel)
                    }
                .sheet(item: $expenseToEdit) { expense in
                    UpdateExpenseSheetView(expense: expense)
                }
                .toolbar {
                    if !viewModel.filteredExpenses.isEmpty {
                        Button("Add Expense", systemImage: "plus") {
                            isShowingItemSheet = true
                        }
                    }
                }
                .overlay {
                    if viewModel.chunkedExpenses.isEmpty {
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
                    do {
                        try viewModel.fetchAll()
                    } catch {
                        fatalError("Failed to fetch expenses")
                    }
                }
            }
            .background(Color(uiColor: .systemGroupedBackground))
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
