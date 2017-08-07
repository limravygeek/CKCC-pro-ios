//
//  InsertNewsTableViewCell.swift
//  PelprekNews
//
//  Created by lim ravy on 13/6/2560 BE.
//  Copyright © 2560 BE lim ravy. All rights reserved.
//

import UIKit

class InsertNewsTableViewCell: UITableViewCell,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var ContentTextView: UITextView!
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ContentTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        ContentTextView.layer.cornerRadius = 5
        ContentTextView.layer.borderWidth = 1.0
        ContentTextView.backgroundColor = UIColor.white
        
        btnImage.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        btnImage.layer.cornerRadius = 5
        btnImage.layer.borderWidth = 1.0
        
        btnSave.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        btnSave.layer.cornerRadius = 5
       
       
           }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func clickBrowseImage(_ sender: Any) {
        
    
    }
    

    @IBAction func onClickbtnSave(_ sender: Any) {
        
        let title = titleTextField.text!
        let desc  = ContentTextView.text!
        let userId = "000"
        let image  = "resources/image/article-image/448403d3-e30b-4df7-9f6b-9279cfa36739.jpg"
        
        sendNewsToServer(title: title, description: desc, userID: userId, image: image)
    }
    //----upload article
    func sendNewsToServer(title:String,description:String,userID:String,image:String){
        //        let url = URL(string: serverAddress)!
        //        var request = URLRequest(url: url)
        //        request.httpMethod = "POST"
        //        request.httpBody = data
        //        let task = URLSession.shared.dataTask(with: request){(data,session,error) in
        //            let content = String(data:data!,encoding:.utf8)
        //            print("Content :", content!)
        //        }
        //        task.resume()
        
        let url = URL(string: "http://hrdams.herokuapp.com/api/article/hrd_c001")!
        let jsonDict = ["title": title, "description": description,"userId": userID, "image": image]
        
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
