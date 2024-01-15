import XCTest

final class videoPlayerStoryboardTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let VideoPlayerViewController = VideoPlayerViewController()
        let apiManager = VideoPlayerViewController.apiManager
        XCTAssertTrue(apiManager.urlString == "http://localhost:4000/videos","apiCall points to a wrong URL")
        XCTAssertTrue(constant.backendURL == "http://localhost:4000/videos" , "Check Backend URL")
        XCTAssertNil(VideoPlayerViewController.videoModel,"You should start with a nil video list")
       
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
