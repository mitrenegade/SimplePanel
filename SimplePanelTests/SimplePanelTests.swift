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
    var panelArmed: Panel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        panel = Panel(code: KNOWN_VALID_ARM_CODE, exitDelay: EXIT_DELAY_INTERVAL)
        panelViewModel = PanelViewModel(panel: panel)
        
        panelArmed = Panel(code: KNOWN_VALID_ARM_CODE, initialState: .armed)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        panel = nil
        panelArmed = nil
    }
    
    func testInitialArmState() {
        let disarmed = Panel(code: KNOWN_VALID_ARM_CODE, exitDelay: EXIT_DELAY_INTERVAL, initialState: .disarmed)
        let arming = Panel(code: KNOWN_VALID_ARM_CODE, exitDelay: EXIT_DELAY_INTERVAL, initialState: .arming)
        let armed = Panel(code: KNOWN_VALID_ARM_CODE, exitDelay: EXIT_DELAY_INTERVAL, initialState: .armed)
        let alarm = Panel(code: KNOWN_VALID_ARM_CODE, exitDelay: EXIT_DELAY_INTERVAL, initialState: .alarm)

        XCTAssert(disarmed.status == .disarmed)
        XCTAssert(arming.status == .arming)
        XCTAssert(armed.status == .armed)
        XCTAssert(alarm.status == .alarm)
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
    
    // Disarm
    func testValidDisarm() {
        XCTAssert(panelArmed.status == .armed)
        panelArmed.disarm(code: KNOWN_VALID_ARM_CODE)
        XCTAssert(panelArmed.status == .disarmed)
    }

    func testInvalidDisarm() {
        XCTAssert(panelArmed.status == .armed)
        panelArmed.disarm(code: KNOWN_INVALID_ARM_CODE)
        XCTAssert(panelArmed.status == .armed)
    }
    
    // Disarm during arming/cancel arming
    func testValidDisarmDuringArming() {
        panel.arm(code: KNOWN_VALID_ARM_CODE)
        XCTAssert(panel.status == .arming)
        
        let exp = expectation(description: "panel should be disarmed if arming is cancelled")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + EXIT_DELAY_INTERVAL / 2.0) {
            self.panel.disarm(code: KNOWN_VALID_ARM_CODE)
            if self.panel.status == .disarmed {
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: EXIT_DELAY_INTERVAL)
    }
    
    func testValidDisarmingCancelsExitDelay() {
        panel.arm(code: KNOWN_VALID_ARM_CODE)
        XCTAssert(panel.status == .arming)
        
        let exp = expectation(description: "panel should still be disarmed after the exit delay if arming is cancelled")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + EXIT_DELAY_INTERVAL / 2.0) {
            self.panel.disarm(code: KNOWN_VALID_ARM_CODE)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + EXIT_DELAY_INTERVAL) {
            if self.panel.status == .disarmed {
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: EXIT_DELAY_INTERVAL)
    }

    func testInvalidDisarmDuringArming() {
        panel.arm(code: KNOWN_VALID_ARM_CODE)
        XCTAssert(panel.status == .arming)
        
        let exp1 = expectation(description: "panel should be arming if invalid code is used to cancel arming")
        let exp2 = expectation(description: "panel should be armed after exit delay if invalid code is used to cancel arming")

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + EXIT_DELAY_INTERVAL / 2.0) {
            self.panel.disarm(code: KNOWN_INVALID_ARM_CODE)
            if self.panel.status == .arming {
                exp1.fulfill()
            }
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + EXIT_DELAY_INTERVAL) {
            if self.panel.status == .armed {
                exp2.fulfill()
            }
        }
        wait(for: [exp1, exp2], timeout: EXIT_DELAY_INTERVAL)
    }
    

    // View model tests
    func testViewModel() {
        XCTAssert(panelViewModel.iconColor == UIColor.green)
        panel.arm(code: "1234")
        XCTAssert(panelViewModel.iconColor == UIColor.red)
    }
    
}
