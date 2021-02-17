//
//  VotingDetailsCell.swift
//  Debate
//
//  Created by Fumiya Takaki on 2019/11/07.
//  Copyright © 2019 Fumiya Takaki. All rights reserved.
//

import UIKit

class VotingDetailsCell: UITableViewCell {

    @IBOutlet weak var nameOfListenersLabelOutlet: UILabel!
    @IBOutlet var nameOfTalkersLabelOutletCollection: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
