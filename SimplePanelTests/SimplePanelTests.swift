//
//  SimplePanelTests.swift
//  SimplePanelTests
//
//  Created by Ren, Bobby on 12/11/17.
//  Copyright © 2017 Ren, Bobby. All rights reserved.
//

import XCTest
@testable import SimplePanel

let KNOWN_VALID_ARM_CODE = "1234"
let KNOWN_INVALID_ARM_CODE = "1235"
let EXIT_DELAY_INTERVAL: TimeInterval = 5.0

class PanelTesterTests: XCTestCase {
    
    var panel: Panel!
    var panelViewModel: PanelViewModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        panel = Panel(code: KNOWN_VALID_ARM_CODE, exitDelay: EXIT_DELAY_INTERVAL)
        panelViewModel = PanelViewModel(panel: panel)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // ARM tests
    func testValidArming() {
        XCTAssert(panel.status == .disarmed)
        panel.arm(code: KNOWN_VALID_ARM_CODE)
        XCTAssert(panel.status == .arming)
    }
    
    func testInvalidArming() {
        XCTAssert(panel.status == .disarmed)
        panel.arm(code: KNOWN_INVALID_ARM_CODE)
        XCTAssert(panel.status == .disarmed)
    }
    
    // ARMING state tests
    func testArmStateAfterExitDelayEnds() {
        XCTAssert(panel.status == .disarmed)
        panel.arm(code: KNOWN_VALID_ARM_CODE)
        XCTAssert(panel.status == .arming)
        let exp = expectation(description: "panel should be armed after exit delay")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + EXIT_DELAY_INTERVAL) {
            if self.panel.status == .armed {
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: EXIT_DELAY_INTERVAL*2)
    }
    
    func testArmStateBeforeExitDelayEnds() {
        XCTAssert(panel.status == .disarmed)
        panel.arm(code: KNOWN_VALID_ARM_CODE)
        XCTAssert(panel.status == .arming)
        let exp = expectation(description: "panel will still be arming before exit delay")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+EXIT_DELAY_INTERVAL-1.0) {
            if self.panel.status == .arming {
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: EXIT_DELAY_INTERVAL*2)
    }
    
    func testInvalidCode() {
        XCTAssert(panel.status == .disarmed)
        panel.arm(code: "5678")
        XCTAssert(panel.status == .disarmed)
    }
    
    func testViewModel() {
        XCTAssert(panelViewModel.iconColor == UIColor.green)
        panel.arm(code: "1234")
        XCTAssert(panelViewModel.iconColor == UIColor.red)
    }
    
}
