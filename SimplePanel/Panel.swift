//
//  PanelModel.swift
//  PanelTester
//
//  Created by Ren, Bobby on 12/8/17.
//  Copyright © 2017 Ren, Bobby. All rights reserved.
//

import UIKit

class Panel: NSObject {
    enum PanelStatus {
        case disarmed
        case arming
        case armed
        case alarm
    }
    
    var status: PanelStatus {
        didSet {
            if status == .arming {
                self.timer = Timer.scheduledTimer(withTimeInterval: self.timeoutAmount, repeats: false) {_ in
                    self.status = .armed
                }
            }
        }
    }
    
    var timeoutAmount = 6.0
    var masterCode: String
    var timer: Timer?
    
    init(code: String) {
        masterCode = code
        status = .disarmed
    }
    
    // app side changes
    func arm(code: String) {
        if code == self.masterCode {
            self.status = .arming
        }
    }
    
    func disarm(code: String) {
        if code == self.masterCode {
            self.status = .disarmed
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
}
