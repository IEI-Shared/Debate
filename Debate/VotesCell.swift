//
//  VotesCell.swift
//  Debate
//
//  Created by Fumiya Takaki on 2019/11/07.
//  Copyright © 2019 Fumiya Takaki. All rights reserved.
//

import UIKit

class VotesCell: UITableViewCell {

    @IBOutlet weak var nameOfTalkersLabelOutlet: UILabel!
    @IBOutlet weak var votesLabelOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
