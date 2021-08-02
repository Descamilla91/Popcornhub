//
//  UpcomingMoviesPresenterTests.swift
//  PopcornHub
//
//  Created by Diego Escamilla on 02/08/21.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import PopcornHub
import XCTest

class UpcomingMoviesPresenterTests: XCTestCase {
    
    // MARK: Subject under test
    
    var sut: UpcomingMoviesPresenter!
	var viewControllerSpy: UpcomingMoviesViewControllerSpy!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupUpcomingMoviesPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupUpcomingMoviesPresenter() {
        sut = UpcomingMoviesPresenter()
		viewControllerSpy = UpcomingMoviesViewControllerSpy()
		sut.viewController = viewControllerSpy
    }
    
    // MARK: Tests
	
    func testPresentUpcomingMovies() {
        // Given
		let response = UpcomingMoviesModels.FetchUpcomingMovies.Response(mediaList: Dummies.Common.getMediaList())
        
        // When
		sut.presentUpcomingMovies(response: response)
        
        // Then
		XCTAssert(viewControllerSpy.displayUpcomingMoviesCalled)
		XCTAssertEqual(viewControllerSpy.displayUpcomingMoviesViewModel?.displayableMediaList.count, response.mediaList.count)
    }
	
	func testPresentMovieDetail() {
		// When
		sut.presentMovieDetail()
		
		// Then
		XCTAssert(viewControllerSpy.displayMovieDetailCalled)
	}
}

// MARK: Test doubles

class UpcomingMoviesViewControllerSpy: UpcomingMoviesDisplayInterface {
	var displayUpcomingMoviesCalled = false
	var displayUpcomingMoviesViewModel: UpcomingMoviesModels.FetchUpcomingMovies.ViewModel?
	func displayUpcomingMovies(upcomingMoviesViewModel: UpcomingMoviesModels.FetchUpcomingMovies.ViewModel) {
		displayUpcomingMoviesCalled = true
		displayUpcomingMoviesViewModel = upcomingMoviesViewModel
	}
	
	var displayMovieDetailCalled = false
	func displayMovieDetail() {
		displayMovieDetailCalled = true
	}
}