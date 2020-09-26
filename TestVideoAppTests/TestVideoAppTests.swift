//
//  TestVideoAppTests.swift
//  TestVideoAppTests
//
//  Created by Станислав Климов on 26.09.2020.
//

import XCTest
@testable import TestVideoApp

class TestVideoAppTests: XCTestCase {
    
    var sut: ViewController!
    var sutNetworkManager: NetworkManager!
    var sutCacheManager: CacheManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ViewController()
        sutNetworkManager = NetworkManager()
        sutCacheManager = CacheManager()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        sutNetworkManager = nil
        sutCacheManager = nil
        try super.tearDownWithError()
    }
    
    func testFetchVideoData() {
        let urlString = "https://mmvs.ru/GoBoards/test/playlist.json"
        var videoUrls: [String]? = nil
        sutNetworkManager.fetchVideoData(from: urlString) { (urlsOfVideosString) in
            videoUrls?.append(contentsOf: urlsOfVideosString)
            XCTAssertNotNil(videoUrls)
        }
    }
    
    func testFetchVideoDataFromWrongUrl() {
        let urlString = "https://mmvs.ru/GoBoards/test/plaf"
        var videoUrls: [String]? = nil
        sutNetworkManager.fetchVideoData(from: urlString) { (urlsOfVideosString) in
            videoUrls?.append(contentsOf: urlsOfVideosString)
            XCTAssertNil(videoUrls)
        }
    }
    
    
    func testCachingVideoWithRightUrl() {
        let rightUrl = "https://office1.videoticket.ru:8123/media/1_42f3fc36feb29a62dca75ee03d7cf322.mp4"
        sutCacheManager.getFileWith(stringUrl: rightUrl) { (resultUrl) in
            switch resultUrl {
            case .success(let url) :
                XCTAssertNotNil(url)
            case .failure(let error) :
                print(error)
            }
        }
    }
    
    
    func testCachingVideoWithWrongUrl() {
        let rightUrl = "https://office1.videoticket.ru:8123/media/1_42f3fc36feb29a62dca75"
        sutCacheManager.getFileWith(stringUrl: rightUrl) { (resultUrl) in
            switch resultUrl {
            case .success(let url) :
                print(url)
            case .failure(let error) :
                XCTAssertNotNil(error)
            }
        }
    }
    
}
