//
//  SportDaoTests.swift
//  DataTests
//
//  Created by thanos kottaridis on 4/2/23.
//

import XCTest
import RealmSwift
import Alamofire

/**
 # Integration Test
 This integration Test is used to check comunication of **Sports Repository** with
 realm Database using Spot DAO and Server Using Alamofire.
 
 it also Test `Entity`  and `Domain `Mappers in order to that conversion of data succed upon network request and realm operations.
 */
final class SportsRepositoryTest: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        
        /**
         Use in-memory Realm indentified by the name of current test
         This ensures that each test can't accidentally access or modify the data from other tests or the application itself, and also does not need any clean up after tests.
         */
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "SportsRepositoryTest"
    }
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func insertSportsAndUpdateEvent() {
        let realm = try! Realm()
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
