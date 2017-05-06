//
//  ViewController.swift
//  calculCool
//
//  Created by Apple on 27/04/2017.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var screen: UILabel!
    
    /*override var prefersStatusBarHidden: Bool{
        return true
    }*/

    var mind =  Mind()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        mind.delegate = self
    }

    @IBAction func digit(_ sender: UIButton) {
        mind.value = Double(sender.currentTitle!)!
    }


    @IBAction func operation(_ sender: UIButton) {
        mind.operation(operation: sender.currentTitle)
    }
    
    @IBAction func removeCalcul(_ sender: UIButton) {
        screen.text = String(0)
        mind = Mind()
        mind.delegate = self
    }
    
}


extension ViewController : canShowMyMind {
    func result(_ result: Double){
        screen.text = String(result)
    }
}

