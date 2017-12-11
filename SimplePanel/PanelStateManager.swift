//
//  PanelStateManager.swift
//  SimplePanel
//
//  Created by Ren, Bobby on 12/11/17.
//  Copyright © 2017 Ren, Bobby. All rights reserved.
//

import UIKit

enum Delta {
    case systemStateChange(status: PanelStatus)
}

protocol DeltaProvider {
    func handleDelta(_ delta: Delta)
}

class PanelStateManager: NSObject, DeltaProvider {
    var panel: Panel?
    func handleDelta(_ delta: Delta) {
        guard let panel = panel else { return }
        switch delta {
        case .systemStateChange(status: let status):
            panel.status = status
        }
    }
}
