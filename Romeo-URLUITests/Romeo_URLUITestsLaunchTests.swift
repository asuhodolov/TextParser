//
//  Romeo_URLUITestsLaunchTests.swift
//  Romeo-URLUITests
//
//  Created by Alexander Suhodolov on 14/09/2023.
//

import XCTest

final class Romeo_URLUITestsLaunchTests: XCTestCase {
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
    }
}
