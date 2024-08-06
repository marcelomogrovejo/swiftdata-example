//
//  SwiftUIView.swift
//  SwiftDataExmpl
//
//  Created by Marcelo Mogrovejo on 06/08/2024.
//

import SwiftUI

struct SwiftUIView: View {
    var kk: [Expense] = [
        .init(title: "Expense 1", date: Date.from(year: 2024, month: 1, day: 1), value: 22),
        .init(title: "Expense 2", date: Date.from(year: 2024, month: 2, day: 1), value: 44),
        .init(title: "Expense 3", date: Date.from(year: 2024, month: 3, day: 1), value: 54),
        .init(title: "Expense 4", date: Date.from(year: 2024, month: 4, day: 1), value: 9),
        .init(title: "Expense 5", date: Date.from(year: 2024, month: 5, day: 1), value: 2),
        .init(title: "Expense 6", date: Date.from(year: 2024, month: 6, day: 1), value: 67),
        .init(title: "Expense 7", date: Date.from(year: 2024, month: 7, day: 1), value: 88),
        .init(title: "Expense 8", date: Date.from(year: 2024, month: 8, day: 1), value: 93),
        .init(title: "Expense 9", date: Date.from(year: 2024, month: 9, day: 1), value: 66),
        .init(title: "Expense 10", date: Date.from(year: 2024, month: 10, day: 1), value: 43),
        .init(title: "Expense 11", date: Date.from(year: 2024, month: 11, day: 1), value: 98),
        .init(title: "Expense 12", date: Date.from(year: 2024, month: 12, day: 1), value: 12)
    ]

    var body: some View {
        VStack {
            List {
                ForEach(kk) { expense in
                    Text(expense.title)
                }
            }
        }

    }
}

#Preview {
    SwiftUIView()
}
