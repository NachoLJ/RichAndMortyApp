//
//  ContentView.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 12/4/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = NavigationBarModel()
    var body: some View {
        HomePage(viewModel: HomePageViewModel())
            .environmentObject(model)
    }
}

#Preview {
    ContentView()
}
