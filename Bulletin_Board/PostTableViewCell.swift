//
//  PostTableViewCell.swift
//  Bulletin_Board
//
//  Created by Tobias Classon on 2020-12-07.
//  Copyright © 2020 Tobias Classon. All rights reserved.
//

import UIKit
import CoreData

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func removePost(_ sender: Any) {
        
        
    }
    
    
    
}
