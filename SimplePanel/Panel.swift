//
//  PanelModel.swift
//  PanelTester
//
//  Created by Ren, Bobby on 12/8/17.
//  Copyright © 2017 Ren, Bobby. All rights reserved.
//

import UIKit

enum PanelStatus {
    case disarmed
    case arming
    case armed
    case alarm
}

class Panel: NSObject {

    var status: PanelStatus
    
    fileprivate var exitDelayInterval: TimeInterval
    fileprivate var masterCode: String
    fileprivate var timer: Timer?
    
    init(code: String, exitDelay: TimeInterval = 0.0, initialState: PanelStatus = .disarmed) {
        masterCode = code
        exitDelayInterval = exitDelay
        status = initialState
    }
    
    // app side changes
    func arm(code: String) {
    }
    
    func disarm(code: String) {
    }
}

