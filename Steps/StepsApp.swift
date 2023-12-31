//
//  StepsApp.swift
//  Steps
//
//  Created by David Tacite on 15/07/2023.
//

import SwiftUI

@main
struct StepsApp: App {
    @State private var vm = StepsViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(vm)
        }
    }
}
