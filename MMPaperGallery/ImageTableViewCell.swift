//
//  ImageTableViewCell.swift
//  MMPaperGallery
//
//  Created by Mukesh on 30/03/16.
//  Copyright © 2016 Mad Apps. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var photoView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
