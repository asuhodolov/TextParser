//
//  ArtistAlbumsProviderTests.swift
//  Romeo-URLTests
//
//  Created by Alexander Suhodolov on 28/09/2023.
//

import XCTest

class ArtistAlbumsProviderTests: XCTestCase {
    var session: URLSession!
    var webManager: WebAPIManager!
    var albumsProvider: ArtistAlbumsProvider!
    
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolMock.self]
        session = URLSession(configuration: configuration)
        
        webManager = WebAPIManager(urlSession: session)
        albumsProvider = ArtistAlbumsProvider(webApiManager: webManager)
    }
    
    override func tearDown() {
        session = nil
        webManager = nil
        albumsProvider = nil
        
        super.tearDown()
    }
    
    func testAlbumsRequest() {
        let artistName = "Artist1"
        
        let jsonString =
             """
             {
                 "results": [
                     {
                         "collectionId": 1,
                         "collectionName": "Album1",
                         "artistId": 100,
                         "artistName": "\(artistName)"
                     }
                 ]
             }
             """
        let data = jsonString.data(using: .utf8)
        
        URLProtocolMock.requestHandler = { request in
            guard let url = request.url else { throw NetworkError.invalidURL }
            
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil)!
            return (response, data)
        }
        
        let expectation = XCTestExpectation()
        Task {
            do {
                let albums = try await albumsProvider.retrieveAlbums(of: artistName)
                XCTAssert(albums.count > 0, "testAlbumsRequest failed to retrieve Albums")
                await MainActor.run {
                    expectation.fulfill()
                }
            } catch (let error) {
                XCTFail("testAlbumsRequest failed with error: \(error.localizedDescription)")
            }
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testCorruptedResponse() {
        let jsonString =
             """
             {
                 "results": "WRONG RESULTS"
             }
             """
        let data = jsonString.data(using: .utf8)
        
        URLProtocolMock.requestHandler = { request in
            guard let url = request.url else { throw NetworkError.invalidURL }
            
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil)!
            return (response, data)
        }
        
        let failureExpectation = XCTestExpectation()
        Task {
            do {
                let _ = try await albumsProvider.retrieveAlbums(of: "Any")
            } catch {
                failureExpectation.fulfill()
            }
        }
        
        wait(for: [failureExpectation], timeout: 0.1)
    }
    
    func testFailureResponse() {
        let jsonString =
             """
             {
                 "results": "No Results"
             }
             """
        let data = jsonString.data(using: .utf8)
        
        URLProtocolMock.requestHandler = { request in
            guard let url = request.url else { throw NetworkError.invalidURL }
            
            let response = HTTPURLResponse(
                url: url,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil)!
            return (response, data)
        }
        
        let failureExpectation = XCTestExpectation()
        Task {
            do {
                let _ = try await albumsProvider.retrieveAlbums(of: "Any")
            } catch {
                failureExpectation.fulfill()
            }
        }
        
        wait(for: [failureExpectation], timeout: 0.1)
    }
}
