//
//  CharacterRepository.swift
//  RickAndMortyApp
//
//  Created by Ignacio Lopez Jimenez on 13/4/24.
//

import Foundation

protocol CharacterRepository {
    func getCharacterList(pageNumber: String?) async throws -> CharacterListResponse
    func searchCharacter(by name: String, and pageNumber: String?) async throws -> CharacterListResponse
}

class DefaultCharacterRepository: CharacterRepository {
    // ApiService instance used to make API request
    private let apiService: ApiService
    
    /// Initiates a new repository with an ApiService
    init(apiService: ApiService = DefaultApiService()) {
        self.apiService = apiService
    }
    
    
    func getCharacterList(pageNumber: String?) async throws -> CharacterListResponse {
        // Attemp to retrieve from cache
        if let cachedResponse = retrieve(by: pageNumber ?? "1") {
            return cachedResponse
        }
        
        do {
            // Construct endpoint URL
            let endpoint = RemoteURL.baseUrl + RemoteURL.characterUrl + "\(RemoteURL.pagination)\(pageNumber ?? "1")"
            // Fetch data from API
            let response: CharacterListResponse = try await apiService.getDataFromGetRequest(from: endpoint)
            // Cache the response
            self.save(with: pageNumber ?? "1", response: response)
            return response
        } catch {
          throw error
        }
    }
    
    func searchCharacter(by name: String, and pageNumber: String?) async throws -> CharacterListResponse {
        do {
            return try await apiService.getDataFromGetRequest(from: getEndpointForPagination(by: name, and: pageNumber))
        } catch {
          throw error
        }
    }
}

// MARK: - Cache Handling
extension DefaultCharacterRepository {
    /// Retrieves chached data for a given page number.
    private func retrieve(by pageNumber: String) -> CharacterListResponse? {
        let cache = DefaultNSCacheStoreDataSource<String, CharacterListResponse>()
        return cache[pageNumber]
    }
    
    /// Saves the data to cache for a given page number
    private func save(with pageNumber: String, response: CharacterListResponse) {
        let cache = DefaultNSCacheStoreDataSource<String, CharacterListResponse>()
        cache[pageNumber] = response
    }
}


// MARK: - Endpoint Construction
extension DefaultCharacterRepository {
    private func getEndpointForPagination(by name: String, and pageNumber: String?) -> String {
        if let pageNumber = pageNumber {
            return RemoteURL.baseUrl + RemoteURL.characterUrl + "\(RemoteURL.name)\(name)" + "\(RemoteURL.searchPagination)\(pageNumber)"
        } else {
            return RemoteURL.baseUrl + RemoteURL.characterUrl + "\(RemoteURL.name)\(name)"
        }
    }
}
