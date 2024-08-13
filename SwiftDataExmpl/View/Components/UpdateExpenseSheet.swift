//
//  UpdateExpenseSheet.swift
//  SwiftDataExmpl
//
//  Created by Marcelo Mogrovejo on 06/08/2024.
//

import SwiftUI

struct UpdateExpenseSheet: View {
    @Environment(\.dismiss) private var dismiss

    @Bindable var expense: Expense

    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense name", text: $expense.title)
                    .disableAutocorrection(true)
                TextField("0,00", value: $expense.value, formatter: NumberFormatter().aussieCurrencyFormatter)
                    .keyboardType(.decimalPad)
                DatePicker("Date", selection: $expense.date, displayedComponents: .date)
            }
            .navigationTitle("Update Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    // TODO: validations here
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    let expense = Expense(title: "Expense A", date: .now, value: 45.0)
    return UpdateExpenseSheet(expense: expense)
}
