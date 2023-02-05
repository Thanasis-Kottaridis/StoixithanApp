//
//  SportsLandingTest.swift
//  SportsTests
//
//  Created by thanos kottaridis on 5/2/23.
//

import XCTest
import Domain
import Presentation
import RxTest
import RxBlocking
@testable import Sports

// MARK: - Mock repository error
enum MockRecipeRepositoryError: Error {
    case faildFetching
}

// MARK: - Mock Server response
///# mock sports response to use in test
fileprivate let mockSportsRemoteResponse: [Sport] = [
    Sport(
        id: "FOOT",
        description: "SOCCER",
        events: [
            Event(
                id: "1",
                sportId: "FOOT",
                description: "player1 - player2",
                timestamp: 1667447160,
                isFavorite: false
            ),
            Event(
                id: "2",
                sportId: "FOOT",
                description: "player3 - player4",
                timestamp: 1667447160,
                isFavorite: false
            ),
            Event(
                id: "3",
                sportId: "FOOT",
                description: "player5 - player6",
                timestamp: 1667447160,
                isFavorite: false
            ),
            Event(
                id: "4",
                sportId: "FOOT",
                description: "player7 - player8",
                timestamp: 1667447160,
                isFavorite: false
            ),
            Event(
                id: "5",
                sportId: "FOOT",
                description: "player9 - player10",
                timestamp: 1667447160,
                isFavorite: false
            ),
        ]
        
    ),
    Sport(
        id: "BASK",
        description: "BASKETBALL",
        events: [
            Event(
                id: "1",
                sportId: "BASK",
                description: "player1 - player2",
                timestamp: 1667447160,
                isFavorite: false
            ),
            Event(
                id: "2",
                sportId: "BASK",
                description: "player3 - player4",
                timestamp: 1667447160,
                isFavorite: false
            ),
            Event(
                id: "2",
                sportId: "BASK",
                description: "player5 - player6",
                timestamp: 1667447160,
                isFavorite: false
            ),
        ]
        
    ),
    Sport(
        id: "TENN",
        description: "TENNIS",
        events: [
            Event(
                id: "1",
                sportId: "TENN",
                description: "player1 - player2",
                timestamp: 1667447160,
                isFavorite: false
            ),
            Event(
                id: "2",
                sportId: "TENN",
                description: "player3 - player4",
                timestamp: 1667447160,
                isFavorite: false
            ),
        ]
        
    )
]
fileprivate let mockSportsLocakResponse: [Sport] = [
    Sport(
        id: "FOOT",
        description: "SOCCER",
        events: [
            Event(
                id: "1",
                sportId: "FOOT",
                description: "player1 - player2",
                timestamp: 1667447160,
                isFavorite: false
            ),
            Event(
                id: "2",
                sportId: "FOOT",
                description: "player3 - player4",
                timestamp: 1667447160,
                isFavorite: false
            ),
            Event(
                id: "3",
                sportId: "FOOT",
                description: "player5 - player6",
                timestamp: 1667447160,
                isFavorite: false
            ),
            Event(
                id: "4",
                sportId: "FOOT",
                description: "player7 - player8",
                timestamp: 1667447160,
                isFavorite: false
            ),
            Event(
                id: "5",
                sportId: "FOOT",
                description: "player9 - player10",
                timestamp: 1667447160,
                isFavorite: false
            ),
        ]
        
    ),
    Sport(
        id: "TENN",
        description: "TENNIS",
        events: [
            Event(
                id: "6",
                sportId: "TENN",
                description: "player1 - player2",
                timestamp: 1667447160,
                isFavorite: false
            ),
            Event(
                id: "7",
                sportId: "TENN",
                description: "player3 - player4",
                timestamp: 1667447160,
                isFavorite: false
            ),
        ]
        
    )
]

// MARK: - Mock sports repository IMPL
fileprivate class MockSportsRepository: SportsRepository {
    var expectation: XCTestExpectation?
    
    var mockRemoteSports: [Sport]?
    var mockLocalSports: [Sport]?
    
    init(
        expectation: XCTestExpectation? = nil,
        mockRemoteSports: [Sport]? = nil,
        mockLocalSports: [Sport]? = nil
    ) {
        self.expectation = expectation
        self.mockRemoteSports = mockRemoteSports
        self.mockLocalSports = mockLocalSports
    }
    
    func updateFavoriteEvent(byId id: String, isFavorite: Bool) {
        for (i, sport)in mockSportsLocakResponse.enumerated() {
            for var (j,event) in (sport.events ?? []).enumerated() {
                if event.id == id {
                    self.mockLocalSports?[i].events?[j].isFavorite = true
                    break
                }
            }
        }
    }
    
    public func getSpotsWithEvents(
        _ forceUpdate: Bool,
        completion: @escaping (Domain.Result<[Domain.Sport]?, Domain.BaseException>) -> Void
    ) {
        if !forceUpdate,
           let mockLocalSports = mockLocalSports {
            completion(Result.Success(mockLocalSports))
        } else if let mockRemoteSports = mockRemoteSports {
            completion(Result.Success(mockRemoteSports))
        }
        else {
            completion(Result.Failure(
                BaseException(throwable: MockRecipeRepositoryError.faildFetching)
            ))
        }
    }
}

// MARK: - Mock Action Handler
fileprivate class MockActionHandler: BaseActionHandler {
    var actionsCalled: [Action] = []
    
    func handleBaseAction(action: Presentation.Action) {
        actionsCalled.append(action)
    }
    
    func handleAction(action: Presentation.Action) {
        actionsCalled.append(action)
    }
}

final class SportsLandingTest: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    /**
     ### Test case fetchData event without local SportsWithEvents Data
     **Use Case**
     - Creates a New mockRepository **without local data**.
     - triggers viewModel `.fetchData`
     - View Model enters loading state.
     - BaseAction Handler Shows Loader.
     - Repository Fails to get local data and perform Network request
     - View Model **Quite** loading state.
     - BaseAction Handler **Hides** Loader.
     - view Model update state with new sports.
     - observes state using RXSwift
     */
    func testFetchDataWithoutLocal() throws {
        // set mock repository as Dependency Injection.
        InjectedValues[\.sportsRepository] = MockSportsRepository(mockRemoteSports: mockSportsRemoteResponse)
        // set up mock ActionHandler
        let mockActionHandler = MockActionHandler()
        let viewModel = SportsLandingViewModel(actionHandler: mockActionHandler)
        
        viewModel.onTriggeredEvent(event: .fetchData)
        
        //        waitForExpectations(timeout: 5, handler: nil)
        // observe state
        let state = try viewModel.stateObserver.toBlocking().first()
        // evaluate actionsCalled
        let actions = mockActionHandler.actionsCalled.dropFirst()
        XCTAssertTrue(actions[1] is Presentation.ShowLoaderAction && actions[2] is Presentation.HideLoaderAction && actions.count == 2)
        XCTAssertTrue(state?.spotrsList.count == 3 && state?.spotrsList[1].id == "BASK")
    }
    
    /**
     ### Test case fetchData event with local SportsWithEvents Data
     **Use Case**
     - Creates a New mockRepository **with local data**.
     - triggers viewModel `.fetchData`
     - View Model enters loading state.
     - BaseAction Handler Shows Loader.
     - Repository gets local data and **does not** perform Network request
     - View Model **Quite** loading state.
     - BaseAction Handler **Hides** Loader.
     - view Model update state with new sports.
     - observes state using RXSwift
     - `spotrsList` Expexts to contains 2 elements and the second id should be **TENN**

     */
    func testFetchDataWithLocal() throws {
        // set mock repository as Dependency Injection.
        InjectedValues[\.sportsRepository] = MockSportsRepository(
            mockRemoteSports: mockSportsRemoteResponse,
            mockLocalSports: mockSportsLocakResponse
        )
        // set up mock ActionHandler
        let mockActionHandler = MockActionHandler()
        let viewModel = SportsLandingViewModel(actionHandler: mockActionHandler)
        
        viewModel.onTriggeredEvent(event: .fetchData)
        
        //        waitForExpectations(timeout: 5, handler: nil)
        // observe state
        let state = try viewModel.stateObserver.toBlocking().first()
        // evaluate actionsCalled
        let actions = mockActionHandler.actionsCalled.dropFirst()
        XCTAssertTrue(actions[1] is Presentation.ShowLoaderAction && actions[2] is Presentation.HideLoaderAction && actions.count == 2)
        XCTAssertTrue(state?.spotrsList.count == 2 && state?.spotrsList.last?.id == "TENN")
    }
    
    /**
     ### Test case refresh data Event
     **Use Case**
     - Creates a New mockRepository **with local data** and **Remote Data**.
     - triggers viewModel `.refreshData`
     - View Model enters loading state.
     - BaseAction Handler Shows Loader.
     - Repository perform Network request and gets data
     - View Model **Quite** loading state.
     - BaseAction Handler **Hides** Loader.
     - view Model update state with new sports.
     - observes state using RXSwift
     - `spotrsList` Expexts to contains 3 elements and the second id should be **BASK**

     */
    func testRefreshDataEvent() throws {
        // set mock repository as Dependency Injection.
        InjectedValues[\.sportsRepository] = MockSportsRepository(
            mockRemoteSports: mockSportsRemoteResponse,
            mockLocalSports: mockSportsLocakResponse
        )
        // set up mock ActionHandler
        let mockActionHandler = MockActionHandler()
        let viewModel = SportsLandingViewModel(actionHandler: mockActionHandler)
        
        viewModel.onTriggeredEvent(event: .refreshData)
        
        //        waitForExpectations(timeout: 5, handler: nil)
        // observe state
        let state = try viewModel.stateObserver.toBlocking().first()
        // evaluate actionsCalled
        let actions = mockActionHandler.actionsCalled.dropFirst()
        XCTAssertTrue(actions[1] is Presentation.ShowLoaderAction && actions[2] is Presentation.HideLoaderAction && actions.count == 2)
        XCTAssertTrue(state?.spotrsList.count == 3 && state?.spotrsList[1].id == "BASK")
    }
    
    /**
     ### Test case selectFavoriteEvent Event
     **Use Case**
     - Creates a New mockRepository **with local data** and **Remote Data**.
     - triggers viewModel `.selectFavoriteEvent`
     - view model calls repository and updates selected event by ID
     - after that viewModel performs request to get Sports from Local storage.
     - View Model enters loading state.
     - BaseAction Handler Shows Loader.
     - Repository perform Network request and gets data
     - View Model **Quite** loading state.
     - BaseAction Handler **Hides** Loader.
     - view Model update state with new sports.
     - observes state using RXSwift
     - `spotrsList` Expexts to contains 2 elements and the target event should be updated.

     */
    func testSelectFavoriteEvent() throws {
        // set mock repository as Dependency Injection.
        InjectedValues[\.sportsRepository] = MockSportsRepository(
            mockRemoteSports: mockSportsRemoteResponse,
            mockLocalSports: mockSportsLocakResponse
        )
        // set up mock ActionHandler
        let mockActionHandler = MockActionHandler()
        let viewModel = SportsLandingViewModel(actionHandler: mockActionHandler)
        
        XCTAssertTrue(mockSportsLocakResponse.count == 2 && mockSportsLocakResponse[1].events?[1].isFavorite == false)
        viewModel.onTriggeredEvent(event: .selectFavoriteEvent(eventId: "1", isFavorite: true))
        
        //        waitForExpectations(timeout: 5, handler: nil)
        // observe state
        let state = try viewModel.stateObserver.toBlocking().first()
        // evaluate actionsCalled
        let actions = mockActionHandler.actionsCalled.dropFirst()
        XCTAssertTrue(actions[1] is Presentation.ShowLoaderAction && actions[2] is Presentation.HideLoaderAction && actions.count == 2)
        XCTAssertTrue(state?.spotrsList.count == 2 && state?.spotrsList[0].events?[0].isFavorite == true)
    }
    
    /**
     ### Test case collapseSport Event
     **Use Case**
     - triggers viewModel `.collapseSport` given a sprot obj and an expand/colapse state.
     - initiali state was expanded and toggles to collaped
     - viewModel updates collapsedSports
     - state update triggers computed propery `sportsListDisplayable` to change value
     - now the sectionModel of this sport **has an empty list or Row.**
     - we toggle expand collapsed state again
     - and expect sectionModel of this sport restore **previous list of rows**.
     */
    func testCollapseSportEvent() throws {
        // set mock repository as Dependency Injection.
        InjectedValues[\.sportsRepository] = MockSportsRepository(
            mockRemoteSports: mockSportsRemoteResponse,
            mockLocalSports: mockSportsLocakResponse
        )
        // set up mock ActionHandler
        let mockActionHandler = MockActionHandler()
        let viewModel = SportsLandingViewModel(actionHandler: mockActionHandler)
        
        // fetch initial data
        viewModel.onTriggeredEvent(event: .fetchData)
        
        // observe state
        var state = try viewModel.stateObserver.toBlocking().first()
        XCTAssertTrue(!(state?.collapsedSports.contains(key: "FOOT") ?? false))
        
        // trigger collapse event
        viewModel.onTriggeredEvent(event: .collapseSport(sport: mockSportsLocakResponse[0], isExpand: false))
    
        state = try viewModel.stateObserver.toBlocking().first()
        XCTAssertTrue(state?.collapsedSports.contains(key: "FOOT") ?? false)
        
        // expand sport again
        viewModel.onTriggeredEvent(event: .collapseSport(sport: mockSportsLocakResponse[0], isExpand: true))
    
        state = try viewModel.stateObserver.toBlocking().first()
        XCTAssertTrue(!(state?.collapsedSports.contains(key: "FOOT") ?? false))
    }
    
    /**
     ### Test case fetch remote FetchDataEvent With Error
     **Use Case**
     - Creates a New mockRepository **without local data** nor **Remote Data**.
     - triggers viewModel `.fetchData`
     - View Model enters loading state.
     - BaseAction Handler Shows Loader.
     - Repository Fails to get local data and perform Network request
     - Network response Also Fails.
     - View Model **Quite** loading state.
     - BaseAction Handler **Hides** Loader.
     - validate ActionHandler actionsCalled: expexted: -> [ Presentation.ShowLoaderAction(), Presentation.HideLoaderAction(), PresentFeedbackAction]
     - and the FeedBack.message should be "Δεν ήταν δυνατή η ολοκλήρωση της λειτουργίας. (σφάλμα SportsTests.MockRecipeRepositoryError 0.)"
     - observes state using RXSwift
     */
    func testFetchDataEventWithError() throws {
        // set mock repository as Dependency Injection.
        InjectedValues[\.sportsRepository] = MockSportsRepository()
        // set up mock ActionHandler
        let mockActionHandler = MockActionHandler()
        let viewModel = SportsLandingViewModel(actionHandler: mockActionHandler)
        
        viewModel.onTriggeredEvent(event: .fetchData)
        
        //        waitForExpectations(timeout: 5, handler: nil)
        // observe state
        let state = try viewModel.stateObserver.toBlocking().first()
        // evaluate actionsCalled
        let actions = mockActionHandler.actionsCalled.dropFirst()
        XCTAssertTrue(actions[1] is Presentation.ShowLoaderAction )
        XCTAssertTrue(actions[2] is Presentation.HideLoaderAction )
        XCTAssertTrue((actions[3] as? Presentation.PresentFeedbackAction)?.feedbackMessage.message == "Δεν ήταν δυνατή η ολοκλήρωση της λειτουργίας. (σφάλμα SportsTests.MockRecipeRepositoryError 0.)" )
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
