//
//  CharacterRepositoryTest.swift
//  RickAndMortyAppTests
//
//  Created by Ignacio Lopez Jimenez on 12/4/24.
//

import XCTest
@testable import RickAndMortyApp

class CharacterRepositoryTest: XCTestCase {

    // GIVEN
    var sut: CharacterRepository?
    var sutFailure: CharacterRepository?
    
    override func setUp() {
        super.setUp()
        sut = DefaultCharacterRepository(apiService: CharacterListFakeApiServiceSuccess())
        sutFailure = DefaultCharacterRepository(apiService: CharacterListFakeApiServiceFailure())
    }
    
    override func tearDown() {
        sut = nil
        sutFailure = nil
        super.tearDown()
    }
}

// MARK: - Success Test
extension CharacterRepositoryTest {
    func testSuccessCase_getCharacterList() async {
        do {
            let response = try await sut?.getCharacterList(pageNumber: nil)
            XCTAssertTrue(response?.results.first?.id == 21)
        } catch {
            XCTFail("Always receive a response and not throw an error")
        }
    }
    
    func testSuccessCase_SearchCharacter() async {
        do {
            let response = try await sut?.searchCharacter(by: "Rick", and: nil)
            XCTAssertTrue(response?.results.first?.id == 21)
        } catch {
            XCTFail("Always receive a response and not throw an error")
        }
    }
}

// MARK: - Failure Test
extension CharacterRepositoryTest {
    func testFailureCase_getCharacterList() async {
        do {
            let _ = try await sutFailure?.getCharacterList(pageNumber: nil)
            XCTFail("This test should throw an error")
        } catch {
            // Test passed
        }
    }
    
    func testFaulureCase_getCharacterListParseError() async {
        let sut: CharacterRepository = DefaultCharacterRepository(apiService: CharacterListFakeApiServiceParseErrorFailure())
        do {
            let _ = try await sut.getCharacterList(pageNumber: nil)
            XCTFail("This test should throw an error")
        } catch {
            // Test passed
            if error is AppError {
                XCTAssertEqual(error.localizedDescription, AppError.parseError.localizedDescription)
            } else {
                XCTFail("This test should throw a parse error")
            }
        }
    }
    
    func testFaulureCase_searchCharacter() async {
        do {
            let _ = try await sutFailure?.searchCharacter(by: "Rick", and: nil)
            XCTFail("This test should throw an error")
        } catch {
            // Test passed
        }
    }
}
