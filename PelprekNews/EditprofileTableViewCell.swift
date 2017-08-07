//
//  EditprofileTableViewCell.swift
//  PelprekNews
//
//  Created by lim ravy on 9/6/2560 BE.
//  Copyright © 2560 BE lim ravy. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class EditprofileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cover_view: UIView!
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var ButtonBrowse: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var username_textfield: UITextField!
    
    @IBOutlet weak var password_textfield: UITextField!
    
    @IBOutlet weak var confirmpass_textfield: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        	self.cover_view.backgroundColor = UIColor(patternImage: UIImage(named: "blur.png")!)
        
       
        
        
        self.ProfileImage.layer.cornerRadius = self.ProfileImage.frame.size.width/2
        self.ProfileImage.clipsToBounds = true
        
        
        self.ProfileImage.layer.borderWidth = 1.0
        self.ButtonBrowse.layer.cornerRadius = 5
        self.btnUpdate.layer.cornerRadius = 5
        
        self.ProfileImage.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        
        // self.ProfileImage.layer.borderColor = UIColor.white
       // self.ProfileImage.layer.borderColor =  UIColor.white
        //self.ProfileImage.layer.cornerRadius = 10.0\
        
        loadData(id: "130")
    }
    
    @IBAction func btnUpdateClick(_ sender: Any) {
        
    
        let username: String = username_textfield.text!
        let password: String = password_textfield.text!
        let photo: String = "resources/image/user-image/a8f90dbe-f5e7-4907-88f7-b1df1c57c41e.jpg";
        
        
        
        
        updateUserToServer(id: "130", username: username,password: password, roles: "User", enabled: "true", photo: photo)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

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
                let password = user["password"] as! String
                let photo = user["photo"] as! String
                let mainImage = "http://hrdams.herokuapp.com/"
                
                
                print(json)
                print("user name : \(username)")
                
                DispatchQueue.main.async {
                    self.username_textfield.text = username
                    self.password_textfield.text = password
                    self.confirmpass_textfield.text = password
                    let url = URL(string: mainImage+photo)!
                    self.ProfileImage.sd_setImage(with: url)
                    self.ProfileImage.sd_setShowActivityIndicatorView(true)
                    self.ProfileImage.sd_setIndicatorStyle(.gray)
                }
                print(mainImage+photo)
                
                
            } catch {
                print("error:", error)
               
            }
        }
        task.resume()
    }
    
    
    
    
    //----update article
    func updateUserToServer(id:String,username:String,password:String,roles:String,
enabled:String,photo:String){
        
       // alertDialog()
        
        let url = URL(string: "http://hrdams.herokuapp.com/api/user/hrd_u001")!
        let jsonDict = ["id":id,"username": username, "password": password,"roles":roles,"enabled":enabled,"photo": photo] as [String : Any]
        
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
    
    
    
    func alertDialog(){
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        parentViewController?.present(alert, animated: true, completion: nil)

        
    }
    
   

    


}


extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController!
            }
        }
        return nil
    }
}
