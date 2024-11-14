//
//  swiftui_upgraded_eurekaApp.swift
//  swiftui_upgraded_eureka
//
//  Created by m1_air on 11/13/24.
//

import SwiftUI
import SwiftData

@main
struct swiftui_upgraded_eurekaApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            NewAccountView()
        }
        .modelContainer(sharedModelContainer)
    }
}
