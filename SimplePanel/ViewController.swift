//
//  ViewController.swift
//  SimplePanel
//
//  Created by Ren, Bobby on 12/11/17.
//  Copyright © 2017 Ren, Bobby. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var panel: Panel?
    @IBOutlet var alarm: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Normally the master code is input through the keyboard the first time the user uses the system
        panel = Panel(code: "1234")
    }


}

