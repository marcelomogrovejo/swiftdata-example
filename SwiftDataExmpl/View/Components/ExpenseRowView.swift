//
//  ExpenseRowView.swift
//  SwiftDataExmpl
//
//  Created by Marcelo Mogrovejo on 06/08/2024.
//

import SwiftUI

struct ExpenseRowView: View {

    let expense: Expense

    var body: some View {
        HStack {
            Text(expense.date, format: .dateTime.month(.abbreviated).day())
                .frame(width: 70, alignment: .leading)
            Text(expense.title)
            Spacer()
            Text(expense.value, format: .currency(code: "AUD"))
        }
    }
}

#Preview {
    // Mock
    let expense = Expense(title: "Expense A", date: .now, value: 45.0)
    return ExpenseRowView(expense: expense)
}
