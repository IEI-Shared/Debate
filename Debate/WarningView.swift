//
//  WarningView.swift
//  Debate
//
//  Created by Fumiya Takaki on 2019/11/11.
//  Copyright © 2019 Fumiya Takaki. All rights reserved.
//

import UIKit

class WarningViewController: UIViewController {
    
    @IBOutlet weak var contentViewOutlet: UIView!
    @IBOutlet weak var warningLabelOutlet: UILabel!
    @IBOutlet var buttonOutletCollection: [UIButton]!
    
    let notificationCenter = NotificationCenter.default
    
    @IBAction func buttonAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            self.bouncingView(caseNumber: 1)
        case 2:
            self.bouncingView(caseNumber: 2)
        default:
            break
        }
    }
    
    func bouncingView(caseNumber number: Int) {
        switch number {
        case 0:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .curveLinear, animations: {() -> Void in
                self.contentViewOutlet.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        case 1:
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.contentViewOutlet.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }, completion: {(bool) -> Void in
                self.dismiss(animated: false, completion: nil)
            })
        case 2:
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.contentViewOutlet.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }, completion: {(bool) -> Void in
                self.dismiss(animated: false, completion: {() -> Void in
                    self.notificationCenter.post(name: .myNotificationName, object: nil)
                })
            })
        default:
            break
        }
    }
    
    func viewPreparation() {
        
        contentViewOutlet.layer.cornerRadius = 20.0
        warningLabelOutlet.layer.cornerRadius = 10.0
        
        for n in 0...1 {
            buttonOutletCollection[n].layer.cornerRadius = 10.0
        }
        
        contentViewOutlet.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        viewPreparation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        self.bouncingView(caseNumber: 0)
    }
    
    
}

extension Notification.Name {
    static let myNotificationName = Notification.Name("myNotificationName")
}
