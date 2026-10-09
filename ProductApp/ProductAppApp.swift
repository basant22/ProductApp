//
//  ProductAppApp.swift
//  ProductApp
//
//  Created by apple on 09/10/26.
//

import SwiftUI

@main
struct ProductAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
