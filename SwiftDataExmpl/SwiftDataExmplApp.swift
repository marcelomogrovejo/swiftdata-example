//
//  SwiftDataExmplApp.swift
//  SwiftDataExmpl
//
//  Created by Marcelo Mogrovejo on 25/07/2024.
//

import SwiftUI
import SwiftData

@main
@MainActor
struct SwiftDataExmplApp: App {

    let container: ModelContainer = {
        do {
            let schema = Schema([Expense.self])
//        let config = ModelConfiguration(<#T##String?#>, schema: <#T##Schema?#>, isStoredInMemoryOnly: <#T##Bool#>, allowsSave: <#T##Bool#>, groupContainer: <#T##ModelConfiguration.GroupContainer#>, cloudKitDatabase: <#T##ModelConfiguration.CloudKitDatabase#>)
            let container = try ModelContainer(for: schema, configurations: [])

            #if DEBUG
            try addInitilData(modelContainer: container, cant: 5)
            #endif

            return container
        } catch {
            fatalError("Failed to create container")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ExpenseView(modelContext: container.mainContext)
        }
        // One way to use a container
//        .modelContainer(for: [Expense.self])
        // Another way to use a container
        .modelContainer(container)
    }
}

extension SwiftDataExmplApp {

    // MARK: - Mock for testing

    /// Initial mock values
    ///
    /// Source: https://www.andrewcbancroft.com/blog/ios-development/data-persistence/pre-populate-swiftdata-persistent-store/
    ///
    /// - Parameters:
    ///   - modelContainer: The app ModelContainer
    ///   - cant: The number of expenses to be added
    static func addInitilData(modelContainer: ModelContainer, cant: Int = 10) throws {
        do {
            // Make sure the persistent store is empty. If it's not, return the non-empty container.
            var fetchDescriptor = FetchDescriptor<Expense>()
            fetchDescriptor.fetchLimit = 1

            guard try modelContainer.mainContext.fetch(fetchDescriptor).count == 0 else { return }

            let currentMonth = Date.now.get(.month)
            for i in 0...cant - 1 {
                let value = Double.random(in: 1..<100)
                let date = Date.now.addOrSubtractMonth(-Int.random(in: 0...currentMonth))
                let expense = Expense(title: "Test \(i + 1)", date: date, value: value)
                modelContainer.mainContext.insert(expense)
            }
        } catch {
            fatalError("Failed to populate model")
        }
    }

}
