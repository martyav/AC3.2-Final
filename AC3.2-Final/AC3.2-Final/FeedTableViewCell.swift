//
//  FeedTableViewCell.swift
//  
//
//  Created by Marty Avedon on 2/15/17.
//
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var descript: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
