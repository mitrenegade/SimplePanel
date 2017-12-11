//
//  PanelStateManagerTests.swift
//  SimplePanelTests
//
//  Created by Ren, Bobby on 12/11/17.
//  Copyright © 2017 Ren, Bobby. All rights reserved.
//

import XCTest
@testable import SimplePanel

class PanelStateManagerTests: XCTestCase {
    
    var panel: Panel!
    var manager: PanelStateManager!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        panel = Panel(code: KNOWN_VALID_ARM_CODE, exitDelay: EXIT_DELAY_INTERVAL)
        manager = PanelStateManager()
        manager.panel = panel
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        panel = nil
        manager = nil
    }
    
    func testReceiveDeltasToChangeState() {
        XCTAssert(panel.status == .disarmed)
        
        manager.handleDelta(Delta.systemStateChange(status: PanelStatus.arming))
        XCTAssert(panel.status == .arming)

        manager.handleDelta(Delta.systemStateChange(status: PanelStatus.armed))
        XCTAssert(panel.status == .armed)

        manager.handleDelta(Delta.systemStateChange(status: PanelStatus.alarm))
        XCTAssert(panel.status == .alarm)

        manager.handleDelta(Delta.systemStateChange(status: PanelStatus.disarmed))
        XCTAssert(panel.status == .disarmed)
    }
}
