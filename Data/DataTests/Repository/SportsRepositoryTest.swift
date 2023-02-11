//
//  SportDaoTests.swift
//  DataTests
//
//  Created by thanos kottaridis on 4/2/23.
//

import XCTest
import RealmSwift
import Alamofire
import Domain
@testable import Data
import Mocker

// MARK: - Mock Data
fileprivate let mockSportsRemoteResponse: [SportDto] = [
    SportDto(
        id: "FOOT",
        description: "SOCCER",
        events: [
            EventDto(
                id: "1",
                sportId: "FOOT",
                description: "player1 - player2",
                timestamp: 1667447160
            ),
            EventDto(
                id: "2",
                sportId: "FOOT",
                description: "player3 - player4",
                timestamp: 1667447160
            ),
            EventDto(
                id: "3",
                sportId: "FOOT",
                description: "player5 - player6",
                timestamp: 1667447160
            ),
            EventDto(
                id: "4",
                sportId: "FOOT",
                description: "player7 - player8",
                timestamp: 1667447160
            ),
            EventDto(
                id: "5",
                sportId: "FOOT",
                description: "player9 - player10",
                timestamp: 1667447160
            ),
        ]
        
    ),
    SportDto(
        id: "BASK",
        description: "BASKETBALL",
        events: [
            EventDto(
                id: "1",
                sportId: "BASK",
                description: "player1 - player2",
                timestamp: 1667447160
            ),
            EventDto(
                id: "2",
                sportId: "BASK",
                description: "player3 - player4",
                timestamp: 1667447160
            ),
            EventDto(
                id: "2",
                sportId: "BASK",
                description: "player5 - player6",
                timestamp: 1667447160
            ),
        ]
        
    ),
    SportDto(
        id: "TENN",
        description: "TENNIS",
        events: [
            EventDto(
                id: "1",
                sportId: "TENN",
                description: "player1 - player2",
                timestamp: 1667447160
            ),
            EventDto(
                id: "2",
                sportId: "TENN",
                description: "player3 - player4",
                timestamp: 1667447160
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
                isFavorite: true
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

// MARK: - Mock App Config.
fileprivate class MockDataAppConfig: DataAppConfig {
    
    public init() {}
    
    public var appApiBaseUrl: String {
        return "https://618d3aa7fe09aa001744060a.mockapi.io/"
    }
}


//MARK: - Mock Realm Manager
fileprivate class MockRealmManager: RealmManager {
    func provideRealm() -> RealmSwift.Realm {
        /**
         Use in-memory Realm indentified by the name of current test
         This ensures that each test can't accidentally access or modify the data from other tests or the application itself, and also does not need any clean up after tests.
         */
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "SportsRepositoryTest"
        return try! Realm()
    }
}

// MARK: - Mock NetworiProvider
fileprivate class MockNetworkProvider: NetworkProvider {
    lazy var manager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        return Alamofire.Session(configuration: configuration)
    }()
    
}

/**
 # Integration Test
 This integration Test is used to check comunication of **Sports Repository** with
 realm Database using Spot DAO and Server Using Alamofire.
 
 it also Test `Entity`  and `Domain `Mappers in order to that conversion of data succed upon network request and realm operations.
 */
final class SportsRepositoryTest: XCTestCase {
    
    /**
     # Set up mock dependencys for Injection.
     
     Before each test excecution:
     
     - Creates a New Mock DataAppConfig to provide base URL.
     - Create mock networkProvider that uses Moker `MockingURLProtocol` for mockeing requests.
     - Create Mock Realm manager to Use in-memory Realm for test.
     */
    override class func setUp() {
        super.setUp()
        
        InjectedValues[\.dataAppConfig] = MockDataAppConfig()
        InjectedValues[\.networkProvider] = MockNetworkProvider()
        InjectedValues[\.realmManager] = MockRealmManager()
        // recreate Daos in order to take Mock Realm manager dependency
        InjectedValues[\.sportDao] = SportDaoImpl()
        InjectedValues[\.eventDao] = EventDaoImpl()
    }
    
    /**
     ### Test case fetchData from API with force update True
     **Use Case**
     - set Up mocker to Provide `mockSportsRemoteResponse` Data
     - Set up Mocker to Provide Succesfull response `200`
     - Use repository function `getSpotsWithEvents` with `forceUpdate = true`
     - Validate tha response result is success full.
     - Validate that Domain mapper worked correctly and response data are as expected based on `mockSportsRemoteResponse` Data
     */
    func testFetchDataFromServer() throws {
        
        let mockRepo = SportsRepositoryImpl()
        
        let expectedData = mockSportsRemoteResponse
        let apiEndpoint = try! SportsApi.sportsApi.asURLRequest().url!
        let requestExpectation = expectation(description: "Request should finish")
        let mockedData = try! JSONEncoder().encode(mockSportsRemoteResponse)
        
        let mock = Mock(
            url: apiEndpoint,
            dataType: .json,
            statusCode: 200,
            data: [.get: mockedData]
        )
        mock.register()
        
        mockRepo.getSpotsWithEvents(true) { result in
            switch result {
                
            case .Success(let data):
                if let data = data {
                    
                    // test response and mappers.
                    for (i,sport) in data.enumerated() {
                        XCTAssertEqual(sport.id, expectedData[i].id)
                        XCTAssertEqual(sport.events?.count, expectedData[i].events?.count)
                        let eventIds = sport.events?.map({ $0.id })
                        let eventDtoIds = expectedData[i].events?.map({ $0.id })
                        XCTAssertEqual(eventIds, eventDtoIds)
                    }
                }
                
                requestExpectation.fulfill()
            case .Failure(_):
                XCTAssertTrue(false)
            }
        }
        self.wait(for: [requestExpectation], timeout: 10.0)
    }
    
    /**
     ### Test case fetchData from LocalDB with force update False
     **Use Case**
     - set Up Mock data to DB using `mockSportsLocakResponse`.
     - Use repository function `getSpotsWithEvents` with `forceUpdate = FALSE`
     - Validate tha response result is success full.
     - Validate that Repository returned expected Data
     - Validate that Entity mapper worked correctly and response data are as expected based on `mockSportsLocakResponse` Data
     */
    func testFetchDataFromDB() throws {
        
        // add data to mongo
        // clear sports and events
        addMockDataToMongo()
        
        let expectedData = mockSportsLocakResponse
        let mockRepo = SportsRepositoryImpl()
        let requestExpectation = expectation(description: "Request should finish")
        
        mockRepo.getSpotsWithEvents(false) { result in
            switch result {
                
            case .Success(let data):
                if let data = data {
                    
                    // test response and mappers.
                    for (i,sport) in data.enumerated() {
                        XCTAssertEqual(sport.id, expectedData[i].id)
                        XCTAssertEqual(sport.events?.count, expectedData[i].events?.count)
                        let eventIds = sport.events?.map({ $0.id })
                        let eventDtoIds = expectedData[i].events?.map({ $0.id })
                        XCTAssertEqual(eventIds, eventDtoIds)
                    }
                }
                
                requestExpectation.fulfill()
            case .Failure(_):
                XCTAssertTrue(false)
            }
        }
        self.wait(for: [requestExpectation], timeout: 10.0)
    }
    
    /**
     ### Test case fetchData force update false and Both network and DB Sources provided
     **Use Case**
     - set Up mocker to Provide `mockSportsRemoteResponse` Data
     - Set up Mocker to Provide Succesfull response `200`
     - Insert Mock data to DB using `mockSportsLocakResponse`.
     - Use repository function `getSpotsWithEvents` with `forceUpdate = false`
     - Validate tha response result is success full.
     - Validate that Repository returned Data from local storage as expected
     - Validate that Entity mapper worked correctly and response data are as expected based on `mockSportsLocakResponse` Data
     */
    func testFetchDataForceUpdateFalse() throws {
        
        // Set up mock Local DB
        addMockDataToMongo()
        
        // Set Up Mock API
        let apiEndpoint = try! SportsApi.sportsApi.asURLRequest().url!
        let mockedData = try! JSONEncoder().encode(mockSportsRemoteResponse)
        
        let mock = Mock(
            url: apiEndpoint,
            dataType: .json,
            statusCode: 200,
            data: [.get: mockedData]
        )
        mock.register()
        
        // Set up expected Data => LocalMockResponse
        let expectedData = mockSportsLocakResponse
        let mockRepo = SportsRepositoryImpl()
        let requestExpectation = expectation(description: "Request should finish")
        
        mockRepo.getSpotsWithEvents(false) { result in
            switch result {
                
            case .Success(let data):
                if let data = data {
                    
                    // test response and mappers.
                    for (i,sport) in data.enumerated() {
                        XCTAssertEqual(sport.id, expectedData[i].id)
                        XCTAssertEqual(sport.events?.count, expectedData[i].events?.count)
                        let eventIds = sport.events?.map({ $0.id })
                        let eventDtoIds = expectedData[i].events?.map({ $0.id })
                        XCTAssertEqual(eventIds, eventDtoIds)
                    }
                }
                
                requestExpectation.fulfill()
            case .Failure(_):
                XCTAssertTrue(false)
            }
        }
        self.wait(for: [requestExpectation], timeout: 10.0)
    }
    
    /**
     ### Test case Add Favorite Event.
     **Use Case**
     - Insert Mock data to DB using `mockSportsLocakResponse`.
     - Use repository function `updateFavoriteEvent` to update event By Id.
     - Validate that Event updated success full using `EventsDao`
     */
    func testAddFavoriteEvent() throws {
        
        // Set up mock Local DB
        addMockDataToMongo()
        
        // Set up target event Id
        let targetEventId = "6"
        let mockRepo = SportsRepositoryImpl()
        
        // Update selected Event By Id
        mockRepo.updateFavoriteEvent(byId: "6", isFavorite: true)
        
        // validate that event updated
        
        @Injected(\.eventDao)
        var eventDao: EventDao
        let targetEvent = eventDao.getEvent(byId: targetEventId)
        XCTAssertTrue(targetEvent!.isFavorite)
    }
    
    /**
     ### Test case Remove Favorite Event.
     **Use Case**
     - Insert Mock data to DB using `mockSportsLocakResponse`.
     - Use repository function `updateFavoriteEvent` to update event By Id.
     - Validate that Event updated success full using `EventsDao`
     */
    func testRemoveFavoriteEvent() throws {
        
        // Set up mock Local DB
        addMockDataToMongo()
        
        // Set up target event Id
        let targetEventId = "1"
        let mockRepo = SportsRepositoryImpl()
        
        // Update selected Event By Id
        mockRepo.updateFavoriteEvent(byId: targetEventId, isFavorite: false)
        
        // validate that event updated
        
        @Injected(\.eventDao)
        var eventDao: EventDao
        let targetEvent = eventDao.getEvent(byId: targetEventId)
        XCTAssertTrue(!targetEvent!.isFavorite)
    }
    
    /**
     ### Test case fetchData from API with Intenal Server error 500
     */
    func testFetchDataFromServer500() throws {
        
        let mockRepo = SportsRepositoryImpl()
        
        let apiEndpoint = try! SportsApi.sportsApi.asURLRequest().url!
        let requestExpectation = expectation(description: "Request should finish")
        let mockedData = try! JSONEncoder().encode(mockSportsRemoteResponse)
        
        let mock = Mock(
            url: apiEndpoint,
            dataType: .json,
            statusCode: 500,
            data: [.get: mockedData]
        )
        mock.register()
        
        mockRepo.getSpotsWithEvents(true) { result in
            switch result {
                
            case .Success(_):
                XCTAssertTrue(false)
                
                
            case .Failure(let error):
                XCTAssertEqual(error.errorCode, 500)
                requestExpectation.fulfill()
                
            }
        }
        self.wait(for: [requestExpectation], timeout: 10.0)
    }
    
    /**
     ### Test case fetchData from API with Intenal Server error 400
     */
    func testFetchDataFromServer400() throws {
        
        let mockRepo = SportsRepositoryImpl()
        
        let apiEndpoint = try! SportsApi.sportsApi.asURLRequest().url!
        let requestExpectation = expectation(description: "Request should finish")
        let mockedData = try! JSONEncoder().encode(mockSportsRemoteResponse)
        
        let mock = Mock(
            url: apiEndpoint,
            dataType: .json,
            statusCode: 400,
            data: [.get: mockedData]
        )
        mock.register()
        
        mockRepo.getSpotsWithEvents(true) { result in
            switch result {
                
            case .Success(_):
                XCTAssertTrue(false)
                
                
            case .Failure(let error):
                XCTAssertEqual(error.errorCode, 400)
                requestExpectation.fulfill()
                
            }
        }
        self.wait(for: [requestExpectation], timeout: 10.0)
    }
}

// MARK: - Extension: Helper Func
extension SportsRepositoryTest {
    
    private func addMockDataToMongo() {
        // add mock data to mongo
        // clear sports and events
        let dao = SportDaoImpl()
        dao.deleteAllDocuments()
        dao.storeSports(
            sports: SportEntityMapper().mapModelLists(domainList: mockSportsLocakResponse)
        )
    }
}
