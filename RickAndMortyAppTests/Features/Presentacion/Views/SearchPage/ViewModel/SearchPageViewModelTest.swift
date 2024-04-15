//
//  SearchPageViewModelTest.swift
//  RickAndMortyAppTests
//
//  Created by Ignacio Lopez Jimenez on 15/4/24.
//

import XCTest
@testable import RickAndMortyApp

// MARK: - Test
class SearchPageViewModelTest: XCTestCase {
    
    // GIVEN
    var sut: SearchPageViewModel?
    var sutFailure: SearchPageViewModel?
    
    override func setUp() {
        super.setUp()
        sut = SearchPageViewModel(useCase: DefaultCharacterUseCase(repository: DefaultCharacterRepository(apiService: CharacterListFakeApiServiceSuccess())))
        sutFailure = SearchPageViewModel(useCase: DefaultCharacterUseCase(repository: DefaultCharacterRepository(apiService: CharacterListFakeApiServiceFailure())))
    }
    
    override func tearDown() {
        sut = nil
        sutFailure = nil
        super.tearDown()
    }
}

// MARK: - Success Tests
extension SearchPageViewModelTest {
    func testSuccessCase_SearchCharacterByName() async {
        // WHEN
        await sut?.searchCharacter(by: "Rich", isFirstLoad: true)
        // THEN
        XCTAssertTrue(sut?.characterList.first?.id == 21)
    }
    
    func testSuccessCase_SearchCharacterBEmptyName() async {
        // WHEN
        await sut?.searchCharacter(by: "", isFirstLoad: true)
        // THEN
        XCTAssertTrue(sut?.characterList.isEmpty ?? false)
    }
}

// MARK: - Failure Tests
extension SearchPageViewModelTest {
    func testFailureCase_earchCharacterByName() async {
        // GIVEN
        guard let sutFailure else { return }
        // WHEN
        await sutFailure.searchCharacter(by: "Rick", isFirstLoad: true)
        // THEN
        XCTAssertTrue(sutFailure.characterList.isEmpty)
    }    
}
