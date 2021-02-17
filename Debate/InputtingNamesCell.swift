//
//  InputtingNamesCell.swift
//  Debate
//
//  Created by Fumiya Takaki on 2019/11/04.
//  Copyright © 2019 Fumiya Takaki. All rights reserved.
//

import UIKit

class InputtingNamesCell: UITableViewCell {

    @IBOutlet weak var contentViewOutlet: UIView!
    @IBOutlet weak var nameOfPlayersField: UITextField!
    @IBOutlet weak var clearButtonOutlet: UIButton!
    
    @IBAction func touchDownAction(_ sender: UIButton) {
        bounching(buttonState: 0, UIbutton: sender)
    }
    
    @IBAction func touchDragExitAction(_ sender: UIButton) {
        bounching(buttonState: 1, UIbutton: sender)
    }
    
    @IBAction func clearButtonAction(_ sender: UIButton) {
        bounching(buttonState: 2, UIbutton: sender)
        nameOfPlayersField.text = ""
        
        switch nameOfPlayersField.tag/10 {
        case 0:
            defaults.removeObject(forKey: players[0][nameOfPlayersField.tag])
        case 1:
            defaults.removeObject(forKey: players[1][nameOfPlayersField.tag - 10])
        default:
            break
        }
    }
    
    func bounching(buttonState state: Int, UIbutton sender: UIButton) {
        switch state {
        case 0: // pushed
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {() -> Void in
                sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: nil)
        case 1: // dragExit
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {() -> Void in
                sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        case 2: // released
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveLinear, animations: {() -> Void in
                sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        default:
            break
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
