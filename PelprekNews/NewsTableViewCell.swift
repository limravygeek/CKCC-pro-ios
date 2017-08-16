//
//  NewsTableViewCell.swift
//  PelprekNews
//
//  Created by lim ravy on 8/6/2560 BE.
//  Copyright © 2560 BE lim ravy. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cardSetup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBOutlet weak var news_image: UIImageView!
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var btnAction: UIButton!
    
    @IBAction func onClickButtonAction(_ sender: Any) {
      let tag = btnAction.tag
      saveTagActionToUserDefaults(tag: tag)
    }
    
    func saveTagActionToUserDefaults(tag:Int){
        UserDefaults.standard.set(tag, forKey:"actiontag")
        UserDefaults.standard.synchronize()
    }
    
    func cardSetup(){
            self.news_image.layer.cornerRadius = 20
            self.news_image.layer.masksToBounds = false
            self.cardView.layer.masksToBounds = false
            self.cardView.layer.cornerRadius = 5
            self.cardView.layer.shadowOffset = CGSize.zero
            self.cardView.layer.shadowRadius = 1
            self.cardView.layer.shadowOpacity = 0.2
        //cardView.layer.shadowPath = UIBezierPath(rect:cardView.bounds).cgPath
    }
}
