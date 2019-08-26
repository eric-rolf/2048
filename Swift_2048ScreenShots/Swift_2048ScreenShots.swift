//
//  Swift_2048ScreenShots.swift
//  Swift_2048ScreenShots
//
//  Created by Eric Rolf on 8/26/19.
//  Copyright © 2019 Fifth Third Bank. All rights reserved.
//

import XCTest

class Swift_2048ScreenShots: XCTestCase {

    override func setUp() {
        continueAfterFailure = false

        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testPortraitScreenshots() {
        //let app = XCUIApplication()
        XCUIDevice.shared.orientation = .portrait
        
        // Screen number onene
        snapshot("0-First-screen-portrait")
    }
    
    func testLandscapeScreenshots() {
        //let app = XCUIApplication()
        XCUIDevice.shared.orientation = .landscapeLeft
        
        // Screen number onene
        snapshot("0-First-screen-lanscape")
    }
}
