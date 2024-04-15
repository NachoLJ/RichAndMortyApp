//
//  RickAndMortyAppApp.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 12/4/24.
//

import SwiftUI

@main
struct RickAndMortyAppApp: App {
    @StateObject var router = Router()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navStack) {
                ContentView()
            }.environmentObject(router)
        }
    }
}
