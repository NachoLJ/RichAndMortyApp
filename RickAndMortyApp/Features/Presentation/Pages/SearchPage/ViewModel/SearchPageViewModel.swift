//
//  SearchPageViewModel.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 15/4/24.
//

import Foundation
import Observation

@Observable class SearchPageViewModel {
    /// The use case object for performing character-related operations
    private var useCase: CharacterUseCase
    
    /// The current page number for API pagination
    private var currentPage: Int = 1
    
    /// A flag indicating whether more characters can be fetched
    private var canFetchMoreCharacters: Bool = true
    
    /// A flag to indicate whether the API call is in progress.
    var isLoading: Bool = false
    
    /// A list to store the fetched character models.
    var characterList: [CharacterBusinessModel] = []
    
    /// A work item for debouncing. If needed.
    var workItem: DispatchWorkItem?
    
    init(useCase: CharacterUseCase = DefaultCharacterUseCase()) {
        self.useCase = useCase
    }
    
    /// Searches for characters based on the provided name.
    ///
    ///  - Parameter name: The name of the character to search for
    func searchCharacter(by name: String, isFirstLoad: Bool) async {
        if name.isEmpty {
            resetSearch()
            return
        }
        guard !isLoading, canFetchMoreCharacters else { return }
        isLoading = true
        if isFirstLoad {
            currentPage = 1
            characterList = []
        }
        await fetchSearchCharacter(by: name)
    }
}

// MARK: - Private Methods
extension SearchPageViewModel {
    /// Internal method to fetch characters based on a name.
    ///
    /// - Parameter name: The name of the character to search for.
    private func fetchSearchCharacter(by name: String) async {
        do {
            let response = try await useCase.searchCharacter(by: name, and: "\(currentPage)")
            await MainActor.run {
                characterList += response.results  // Append new characters to existing list
                currentPage += 1  // Increment page number for next fetch
                isLoading = false
                canFetchMoreCharacters = true
            }
        } catch {
            await handleError()
        }
    }
    
    /// Resets the search state to the initial settings.
    private func resetSearch() {
        canFetchMoreCharacters = true
        characterList = []
        currentPage = 1
    }
    
    /// Handles any errors during API calls.
    private func handleError() async {
        if characterList.isEmpty {
            await MainActor.run {
                isLoading = false
            }
        } else {
            await MainActor.run {
                isLoading = false
                canFetchMoreCharacters = false
            }
        }
    }
}

