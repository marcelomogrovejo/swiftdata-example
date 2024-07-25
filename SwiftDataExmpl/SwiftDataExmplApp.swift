//
//  SwiftDataExmplApp.swift
//  SwiftDataExmpl
//
//  Created by Marcelo Mogrovejo on 25/07/2024.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataExmplApp: App {

    let container: ModelContainer = {
        let schema = Schema([Expense.self])
        //let config = ModelConfiguration(<#T##String?#>, schema: <#T##Schema?#>, isStoredInMemoryOnly: <#T##Bool#>, allowsSave: <#T##Bool#>, groupContainer: <#T##ModelConfiguration.GroupContainer#>, cloudKitDatabase: <#T##ModelConfiguration.CloudKitDatabase#>)
        let container = try! ModelContainer(for: schema, configurations: [])
        return container
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // One way to use a container
//        .modelContainer(for: [Expense.self])
        // Another way to use a container
        .modelContainer(container)
    }
}
