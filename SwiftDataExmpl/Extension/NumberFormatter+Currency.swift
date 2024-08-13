//
//  NumberFormatter+Currency.swift
//  SwiftDataExmpl
//
//  Created by Marcelo Mogrovejo on 13/08/2024.
//

import Foundation

/// Source: https://stackoverflow.com/questions/63447662/missing-placeholder-for-ios-swiftui-textfield-that-inputs-an-int
///
extension NumberFormatter {

    var aussieCurrencyFormatter: NumberFormatter {
        getAussieCurrencyFormatter()
    }
    private func getAussieCurrencyFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        /// .currency doesn't work
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.zeroSymbol = ""
        formatter.currencyCode = "AUD"
        return formatter
    }
}
