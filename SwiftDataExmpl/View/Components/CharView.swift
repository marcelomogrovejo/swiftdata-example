//
//  CharView.swift
//  SwiftDataExmpl
//
//  Created by Marcelo Mogrovejo on 07/08/2024.
//

import SwiftUI
import Charts

struct CharView: View {
    var expenses: [Expense]

    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text("Total: \(String(format: "%.2f", expenses.reduce(0, { $0 + $1.value })))")
                .fontWeight(.bold)
                .font(.footnote)
                .foregroundStyle(Color.secondary)
                .padding(.bottom, 12)
            
            Chart {
                /// Dot line behind the bars
                RuleMark(y: .value("Goal", 80))
                    .foregroundStyle(Color.mint)
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
//                    .annotation(alignment: .leading) {
//                        Text("Goal")
//                            .font(.caption)
//                            .foregroundStyle(Color.mint)
//                    }
                ForEach(expenses) { expense in
                    BarMark(
                        x: .value("Month", expense.date, unit: .month),
                        y: .value("Amount", expense.value)
                    )
                    .foregroundStyle(Color.pink.gradient)
                    .cornerRadius(5)
                }
            }
            .frame(height: 130)
            /// Background of the chart
//            .chartPlotStyle { plotContent in
//                plotContent
//                    .background(Color.mint.gradient.opacity(0.3))
//                    .border(Color.brown, width: 3)
//            }
            /// Y axis domain scale
//            .chartYScale(domain: 0...150)
            /// X axis content. Bug on centered, Dicember "D" letter disappears.
            .chartXAxis {
                AxisMarks(values: expenses.map { $0.date }) { axisValue in
//                    AxisGridLine()
//                    AxisTick()
//                    AxisValueLabel(format: .dateTime.month(.narrow)/*, centered: true*/)
                    AxisValueLabel(format: .dateTime.month(.abbreviated))
                }
            }
            /// Y axis content
            .chartYAxis {
                AxisMarks(position: .leading) {
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
            
            HStack {
                Image(systemName: "line.diagonal")
                    .rotationEffect(Angle(degrees: 45))
                    .foregroundColor(.mint)
                Text("Montly goal")
                    .foregroundStyle(Color.secondary)
                    .font(.footnote)
            }
        }
    }
}

#Preview {
    var expenses: [Expense] = []
    for i in 1...12 {
        let randomDouble = Double.random(in: 10...100)
        let expenese = Expense(title: "Expense \(i)", date: Date.from(year: 2024, month: i, day: 1), value: randomDouble)
        expenses.append(expenese)
    }

    return CharView(expenses: expenses)
}
