//
//  AppAsiaMovieDetailsTests.swift
//  AppAsia-TaskTests
//
//  Created by Mohamed Fawzy on 27/10/2022.
//

import XCTest
import Combine
@testable import AppAsia_Task

final class AppAsiaMovieDetailsTests: XCTestCase {
    var sut: MovieDetailsViewModel!
    var cancellables = Set<AnyCancellable>()
    
    override func tearDown() {
        sut = nil
        cancellables = []
        super.tearDown()
    }
    
    func test_when_not_calling_service_state_should_be_idle() {
        // Given
        sut = viewModel(movieId: 0)
        // When -> not calling any services yet
        // then
        XCTAssertEqual(sut.state, .idle)
    }
    
    func test_when_service_responds_With_error() {
        // Given
        sut = viewModel(movieId: .random(in: 1...100), .error(.network))
        let expected = [ViewState.idle, .loading, .error(.network)]
        var actual = [ViewState]()
        let expectation = expectation(description: "fetch movie details")
        // When
        sut.$state
            .sink {
                actual.append($0)
                if actual.count == 3 {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        sut.loadMovie()
        // then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(actual, expected) // state follows idle -> laoding -> error
        XCTAssertEqual(sut.movieDetails.title, MovieDetails.default.title) // no data added yet
    }
    
    func test_when_service_responds_With_details__model() {
        // Given
        let ids = [123, 456]
        let dto1 = MovieDTO(id: ids[0], title: "title 1", posterPath: "poster1.png", releaseDate: Date())
        let dto2 = MovieDTO(id: ids[1], title: "title 2", posterPath: "poster2.png", releaseDate: Date().advanced(by: 60*60*24*7))
        let id =  ids[1]
        
        sut = viewModel(movieId: id, .data([dto1, dto2]))
        
        let expectedStates = [ViewState.loading, .finishedLoading]
        var actualStates = [ViewState]()
                
        let expectation = expectation(description: "fetch movie details")
        
        // When
        sut.$state
            .dropFirst()
            .sink {
                actualStates.append($0)
                if $0 == .finishedLoading {
                    expectation.fulfill()
                }
            }.store(in: &cancellables)
        
        sut.loadMovie()
        
        // then
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(actualStates, expectedStates)
        XCTAssertEqual(sut.movieDetails.title, dto2.title)
        XCTAssertEqual(sut.movieDetails.genresTitle, "Action | Drama")
    }
    
    // MARK: Helper methods
    
    func viewModel(movieId: Int, _ type: MockMoviesService.MockServiceResult = .data([])) -> MovieDetailsViewModel {
        MovieDetailsViewModel(id: movieId, service: MockMoviesService(type: type))
    }
}
