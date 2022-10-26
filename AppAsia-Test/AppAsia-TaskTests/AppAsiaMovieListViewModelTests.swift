//
//  AppAsia_TaskTests.swift
//  AppAsia-TaskTests
//
//  Created by Mohamed Fawzy on 26/10/2022.
//

import XCTest
import Combine

@testable import AppAsia_Task

final class AppAsiaMovieListViewModelTests: XCTestCase {
    
    var sut: MovieListViewModel!
    var cancellables = Set<AnyCancellable>()

    override func tearDown() {
        sut = nil
        cancellables = []
        super.tearDown()
    }

    func test_when_not_calling_service_state_should_be_idle() {
        // Given
        sut = viewModel()
        // When -> not calling any services yet
        // then
        XCTAssertEqual(sut.state, .idle)
    }
    
    func test_when_service_responds_With_error() {
        // Given
        sut = viewModel(.error(.network))
        let expected = [ViewState.idle, .loading, .error(.network)]
        var actual = [ViewState]()
        let expectation = expectation(description: "fetch recipes")
        // When
        sut.$state
            .sink {
                actual.append($0)
                if actual.count == 3 {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        sut.loadMovies()
        // then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(actual, expected) // state follows idle -> laoding -> error
        XCTAssertEqual(sut.movies.count, .zero) // no data added yet
    }
    
    func test_when_service_responds_With_one_recipe_model() {
        // Given
        let dto1 = MovieDTO(id: 123, title: "title 1", posterPath: "poster1.png", releaseDate: Date())
        let dto2 = MovieDTO(id: 456, title: "title 2", posterPath: "poster2.png", releaseDate: Date().advanced(by: 60*60*24*7))

        sut = viewModel(.data([dto1, dto2]))
        
        let expectedStates = [ViewState.loading, .finishedLoading]
        var actualStates = [ViewState]()
        
        let expectedBO = [MovieBO(dto: dto1), MovieBO(dto: dto2)]
        
        let expectation = expectation(description: "fetch recipes")
        
        // When
        sut.$state
            .dropFirst()
            .sink {
                actualStates.append($0)
                if $0 == .finishedLoading {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        sut.loadMovies()
        
        // then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(actualStates, expectedStates)
        XCTAssertEqual(sut.movies.count, 2)
        XCTAssertEqual(sut.movies, expectedBO)
        XCTAssertEqual(expectedBO.first?.posterUrl, Endpoints.Movies.posterURL(path: "poster1.png"))
    }
    
    // MARK: Helper methods
    
    func viewModel(_ type: MockMoviesService.MockServiceResult = .data([])) -> MovieListViewModel {
        MovieListViewModel(service: MockMoviesService(type: type))
    }

}
