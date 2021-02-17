//
//  SplashView.swift
//  Debate
//
//  Created by Fumiya Takaki on 2019/11/15.
//  Copyright © 2019 Fumiya Takaki. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var splashViewOutlet: UIView!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveLinear, animations: {() -> Void in
            self.splashViewOutlet.alpha = 0.0
        }, completion: {(bool) -> Void in
            self.performSegue(withIdentifier: "toTitle", sender: nil)
        })
    }
    
    
}
