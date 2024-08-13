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
                DatePicker("Date", selection: $expense.date, displayedComponents: .date)
                TextField("Value", value: $expense.value, format: .currency(code: "AUD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Update Expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

//#Preview {
//    let expense = Expense(title: "Expense A", date: .now, value: 45.0)
//    UpdateExpenseSheet(expense: expense)
//}
