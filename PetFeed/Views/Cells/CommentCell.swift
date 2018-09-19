//
//  CommentCell.swift
//  PetFeed
//
//  Created by 이창현 on 2018. 9. 17..
//  Copyright © 2018년 이창현. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var profileImageView: profileImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initialize(profile: UIImage, name: String, content: String, date:String) {
        profileImageView.image = profile
        nameLabel.text = name
        contentLabel.text = content
        dateLabel.text = date
    }
}