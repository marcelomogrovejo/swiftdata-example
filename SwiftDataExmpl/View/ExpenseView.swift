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

//            Spacer()

            VStack(alignment: .center) {
                /// Chart section
                if !viewModel.filteredExpenses.isEmpty {
                    //                        CharView(expenses: viewModel.filteredExpenses)

                    VStack {
                        CharView(expenses: viewModel.expenses)
                            .padding()
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8.0)
                                    .stroke(Color(uiColor: .systemGroupedBackground), lineWidth: 5)
                            )
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                }

                List {
                    /// Expenses section
                    Section {
                        
                        // TODO: Something interesting that can help here:
                        // https://stackoverflow.com/questions/77120576/how-do-i-delete-child-items-from-list-with-swiftdata
                        
                        //                    ForEach(viewModel.chunkedExpenses.indices, id: \.self) { sectionIndex in
                        //                        DisclosureGroup {
                        //                            ForEach(viewModel.chunkedExpenses[sectionIndex], id: \.id) { expense in
                        //                                ExpenseCell(expense: expense)
                        //                                    .onTapGesture {
                        //                                        expenseToEdit = expense
                        //                                    }
                        //                            }
                        //                            .onDelete { indexSet in
                        //                                viewModel.deleteAt(sectionIndex: sectionIndex, indexSet: indexSet)
                        //                            }
                        //                        } label: {
                        //                            Text(viewModel.chunkedExpenses[sectionIndex][0].date.formatted(.dateTime.month(.wide)))
                        //                        }
                        //                    }
                        ForEach(viewModel.expenses, id: \.id) { expense in
                            ExpenseCell(expense: expense)
                                .onTapGesture {
                                    expenseToEdit = expense
                                }
                        }
                        .onDelete { indexSet in
                            viewModel.deleteExpenseAt(indexSet: indexSet)
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
