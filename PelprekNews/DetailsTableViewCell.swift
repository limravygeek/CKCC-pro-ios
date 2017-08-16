//
//  DetailsTableViewCell.swift
//  PelprekNews
//
//  Created by lim ravy on 9/6/2560 BE.
//  Copyright © 2560 BE lim ravy. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageDetail: UIImageView!
    
    @IBOutlet weak var titleDetail: UILabel!
    
    @IBOutlet weak var Datelabel: UILabel!
    
    @IBOutlet weak var descDetail: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
      //  let label:UILabel = UILabel(frame: CGRectMake(x, y, width, height))
        titleDetail.numberOfLines = 4
        titleDetail.lineBreakMode = NSLineBreakMode.byWordWrapping
        let font = UIFont(name: "Helvetica", size: 20.0)
        titleDetail.font = font
        titleDetail.text = "Whatever you want the text enter here"
        titleDetail.sizeToFit()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
