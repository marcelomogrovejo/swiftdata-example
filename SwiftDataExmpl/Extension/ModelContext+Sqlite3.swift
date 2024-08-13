//
//  ModelContext+Sqlite3.swift
//  SwiftDataExmpl
//
//  Created by Marcelo Mogrovejo on 11/08/2024.
//

import SwiftData

extension ModelContext {

    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}
