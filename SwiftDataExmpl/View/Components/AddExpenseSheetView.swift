//
//  AddExpenseSheetView.swift
//  SwiftDataExmpl
//
//  Created by Marcelo Mogrovejo on 06/08/2024.
//

import SwiftUI
import SwiftData

struct AddExpenseSheetView: View {
    // Add access to the context throught the viewModel
    @Environment(ExpenseViewModel.self) var viewModel
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var value: Double = 0
    @State private var date: Date = .now

    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense name", text: $title)
                    .disableAutocorrection(true)
                TextField("0,00", value: $value, formatter: NumberFormatter().aussieCurrencyFormatter)
                    .keyboardType(.decimalPad)
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            .navigationTitle("New Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        // TODO: field validatations here
                        // TODO: enabled the button just when validation passes
                        
                        let expense = Expense(title: title, date: date, value: value)
                        do {
                            try viewModel.new(expense: expense)
                        } catch {
                            fatalError("Failed to fetch expenses")
                        }

                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    return AddExpenseSheetView()
}
