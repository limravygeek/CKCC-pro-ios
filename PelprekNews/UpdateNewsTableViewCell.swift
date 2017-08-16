//
//  UpdateNewsTableViewCell.swift
//  PelprekNews
//
//  Created by lim ravy on 15/6/2560 BE.
//  Copyright © 2560 BE lim ravy. All rights reserved.
//

import UIKit

class UpdateNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var TitleTextField: UITextField!
    @IBOutlet weak var CotentTextView: UITextView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var btnUpdate: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CotentTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        CotentTextView.layer.cornerRadius = 5
        CotentTextView.layer.borderWidth = 1.0
        CotentTextView.backgroundColor = UIColor.white
        
        myImage.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        myImage.layer.cornerRadius = 5
        myImage.layer.borderWidth = 1.0
        
        btnUpdate.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        btnUpdate.layer.cornerRadius = 5
       
        
        
          }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func loadActionTagFromUserDefaults()->Int{
        let actiontag = UserDefaults.standard.value(forKey: "actiontag") as! Int
        return actiontag
    }
    
    @IBAction func onClickbtnSave(_ sender: Any) {

        let actiontag = loadActionTagFromUserDefaults()
        let id = ("\(actiontag)")
        let title = self.TitleTextField.text!
        let description = self.CotentTextView.text!
        let myID = "000"
        let image = "resources/image/article-image/85fe5110-6213-466e-b346-b0b67109a3d1.jpg"
        updateNewsToServer(id: id, title: title, description:  description, enabled: true, userID:myID, image:image )
    
    }
    
    //----update article
    func updateNewsToServer(id:String,title:String,description:String,enabled:Bool,userID:String,image:String){
        
        let url = URL(string: "http://hrdams.herokuapp.com/api/article/hrd_u001")!
        let jsonDict = ["id":id,"title": title, "description": description,"enabled":enabled,"userId": userID, "image": image] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error:", error)
                return
            }
            do{
                print("ok now it work")
                let content = String(data:data!,encoding:.utf8)
                print("Content :", content!)
            }catch {
                print("error:", error)
            }
        }
        
        task.resume()
    }

    
}
