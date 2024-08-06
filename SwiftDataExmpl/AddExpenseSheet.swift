//
//  AddExpenseSheet.swift
//  SwiftDataExmpl
//
//  Created by Marcelo Mogrovejo on 06/08/2024.
//

import SwiftUI

struct AddExpenseSheet: View {
    // Add access to the context
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var date: Date = .now
    @State private var value: Double = 0
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense name", text: $title)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Value", value: $value, format: .currency(code: "AUD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("New Expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        // TODO: field validatations here
                        let expense = Expense(title: title, date: date, value: value)
                        // Add the model to the context
                        context.insert(expense)

                        // One way to save: manualy
//                        do {
//                            try context.save()
//                        } catch {
//                            print("Error saving the context")
//                        }
                        // Other way to save: just using the built-in auto-save

                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddExpenseSheet()
}