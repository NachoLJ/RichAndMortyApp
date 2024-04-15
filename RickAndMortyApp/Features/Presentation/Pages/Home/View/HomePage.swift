//
//  HomePage.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 13/4/24.
//

import SwiftUI
import Observation

struct HomePage: View {
    @EnvironmentObject var router: Router
    @Bindable var viewModel: HomePageViewModel
    
    /// Propiedades que haran que cuando cambie su valor, la pantalla se refresque
    @State var showSatusBar = true
    @State var contentHasScrolled = false
    @State var showNav = false
    @State var showDetail: Bool = false
    @State var selectedCharacter: CharacterBusinessModel?
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            scrollView
        }
        .onChange(of: showDetail) {
            withAnimation {
                showNav.toggle()
                showSatusBar.toggle()
            }
        }
        .overlay(NavigationBarView(title: "Characters", contentHasScrolled: $contentHasScrolled))
        .statusBar(hidden: !showSatusBar)
        .onAppear {
            Task {
                await viewModel.loadCharacterList()
            }
        }
        .alert(isPresented: $viewModel.hasError, content: {
            
            Alert(title: Text("Important message"),
                  message: Text(viewModel.viewError?.localizedDescription ?? "Unextected error is happen"),
                  dismissButton: .default(Text("Got it!")))
        })
        .sheet(isPresented: $showDetail, content: {
            CharacterDetailPage(character: selectedCharacter)
        })
    }
    
    var scrollView: some View {
        ScrollView() {
            scrollDetectionView
            characterListView
                .padding(.vertical, 70)
                .padding(.bottom, 50)
        }.coordinateSpace(.named("scroll"))
    }
    
    var scrollDetectionView: some View {
        GeometryReader { proxy in
            let offset = proxy.frame(in: .named("scroll")).minY
            Color.clear.preference(key: ScrollPreferenceKey.self, value: offset)
        }
        .onPreferenceChange(ScrollPreferenceKey.self) { value in
            withAnimation(.easeInOut) {
                let estimatedContentHeight = CGFloat(viewModel.characterList.count * 100)
                let threshold = 0.8 * estimatedContentHeight
                if value <= -threshold {
                    Task {
                        await viewModel.loadCharacterList()
                    }
                }
                if value < 0 {
                    contentHasScrolled = true
                } else {
                    contentHasScrolled = false
                }
            }
        }
    }
    
    var characterListView: some View {
        VStack(spacing: 16) {
            ForEach(Array(viewModel.characterList.enumerated()), id: \.offset) { index, businessModel in
                SectionRowView(section: SectionRowModel(businessModel: businessModel))
                    .onTapGesture {
                        selectedCharacter = businessModel
                        showDetail = true
                    }
                if index == viewModel.characterList.count - 1 {
                    Divider()
                    if viewModel.isLoading {
                        ProgressView("Loading more characters...")
                            .accentColor(.white)
                    }
                } else {
                    Divider()
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .backgroundStyle(cornerRadius: 30)
        .padding(.horizontal, 20)
    }
}



//#Preview {
//    HomePage()
//}
