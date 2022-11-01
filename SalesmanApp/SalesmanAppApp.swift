//
//  SalesmanAppApp.swift
//  SalesmanApp
//
//  Created by marc on 31.10.22.
//

import SwiftUI

@main
struct SalesmanAppApp: App {
    var body: some Scene {
        WindowGroup {
            // Apps main viewModel
            let contentViewViewModel = ContentView.ViewModel()
            
            ContentView(viewModel: contentViewViewModel)
        }
    }
}
