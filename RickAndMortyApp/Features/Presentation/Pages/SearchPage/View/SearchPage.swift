//
//  SearchPage.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 15/4/24.
//

import SwiftUI

struct SearchPage: View {
    
    @Bindable var viewModel: SearchPageViewModel
    @State var text = ""
    @State var showCharacterDetail = false
    @State var selectedCharacter: CharacterBusinessModel?
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.characterList.isEmpty {
                    emptyView
                } else {
                    searchView
                }
                Spacer()
            }
        }
        .searchable(text: $text)
        .onChange(of: text) { _, newValue in
            searchCharacter(by: newValue)
        }
    }
    
    var emptyView: some View {
        Text("No result found")
            .searchViewStyle()
    }
    
    var searchView: some View {
        ScrollView {
            scrollDetectionView
            characterListView
        }
        .searchViewStyle()
        .coordinateSpace(.named("scrollview"))
        .sheet(isPresented: $showCharacterDetail, content: {
            CharacterDetailPage(character: selectedCharacter)
        })
    }
    
    var scrollDetectionView: some View {
        GeometryReader { proxy in
            let offset = proxy.frame(in: .named("scrollview")).minY
            Color.clear.preference(key: ScrollPreferenceKey.self, value: offset)
        }
        .onPreferenceChange(ScrollPreferenceKey.self) { value in
            withAnimation(.easeInOut) {
                let estimatedContentHeight = CGFloat(viewModel.characterList.count * 50)
                let threshold = 0.4 * estimatedContentHeight
                if value <= -threshold {
                    Task {
                        await viewModel.searchCharacter(by: text, isFirstLoad: false)
                    }
                }
            }
        }
    }
    
    var characterListView: some View {
        ForEach(Array(viewModel.characterList.enumerated()), id: \.offset) { index, character in
            if index != 0 {
                Divider()
            }
            
            Button {
                showCharacterDetail = true
                selectedCharacter = character
            } label: {
                ListRowView(title: character.name, image: character.image)
                if viewModel.isLoading {
                    ProgressView()
                        .accentColor(.white)
                }
            }
            .buttonStyle(.plain)
        }
    }
}

extension SearchPage {
    private func searchCharacter(by text: String) {
        viewModel.workItem?.cancel()
        let task = DispatchWorkItem { [weak viewModel] in
            guard let viewModel else { return }
            Task {
                await viewModel.searchCharacter(by: text, isFirstLoad: true)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
        viewModel.workItem = task
    }
}

