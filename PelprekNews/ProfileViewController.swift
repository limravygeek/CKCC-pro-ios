//
//  ProfileViewController.swift
//  PelprekNews
//
//  Created by lim ravy on 30/7/2560 BE.
//  Copyright © 2560 BE lim ravy. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var border_info: UIView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cover_imageview: UIImageView!
    
    @IBOutlet weak var profile_imageview: UIImageView!

    @IBOutlet weak var username_textfield: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profile_imageview.layer.cornerRadius = self.profile_imageview.frame.size.width/2
        self.profile_imageview.clipsToBounds = true
        self.profile_imageview.layer.borderWidth = 1.0
        self.profile_imageview.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor

        self.border_info.layer.cornerRadius = 6
        self.border_info.clipsToBounds = true
        self.border_info.layer.borderWidth = 1.0
        self.border_info.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        

        
        loadData(id: "130")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
       
       loadData(id: "130")
       
    }
    
    func loadData(id: String){
        let url = URL(string: "http://hrdams.herokuapp.com/api/user/hrd_det001")!
        let jsonDict = ["id": id]
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
            do {
                guard let data = data else { return }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }
                let user  =  json["RES_DATA"] as! [String:Any]
                //      let id = user["id"] as! Int
                let username = user["username"] as! String
                let photo = user["photo"] as! String
                let mainImage = "http://hrdams.herokuapp.com/"
                
                
                print(json)
                print("user name : \(username)")
                
                DispatchQueue.main.async {
                    self.username_textfield.text = username
                    self.name.text = username
                    let url = URL(string: mainImage+photo)!
                    self.profile_imageview.sd_setImage(with: url)
                    self.profile_imageview.sd_setShowActivityIndicatorView(true)
                    self.profile_imageview.sd_setIndicatorStyle(.gray)
                }
                print(mainImage+photo)
                
                
            } catch {
                print("error:", error)
                
            }
        }
        task.resume()
    }
    

    

}
