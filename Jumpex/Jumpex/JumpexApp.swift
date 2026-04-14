//
//  JumpexApp.swift
//  Jumpex
//
//  Created by alumne on 23/03/2026.
//

import SwiftUI

@main
struct JumpexApp: App {
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
