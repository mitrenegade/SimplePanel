//
//  PanelViewModel.swift
//  PanelTester
//
//  Created by Ren, Bobby on 12/8/17.
//  Copyright © 2017 Ren, Bobby. All rights reserved.
//

import UIKit

class PanelViewModel: NSObject {
    weak var panel: Panel!
    
    init(panel: Panel) {
        self.panel = panel
    }
    
    var iconColor: UIColor {
        switch panel.status {
        case .disarmed:
            return UIColor.green
        default:
            return UIColor.red
        }
    }
}
