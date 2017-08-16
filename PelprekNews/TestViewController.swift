//
//  TestViewController.swift
//  PelprekNews
//
//  Created by lim ravy on 14/6/2560 BE.
//  Copyright © 2560 BE lim ravy. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profileLoadingIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    let url = URL(string: "http://test.js-cambodia.com/ckcc/profile.json")!
    let task = URLSession.shared.dataTask(with: url){(data,session,error) in
        
        let profile = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
        
        let name = profile["name"] as! String
        let gender = profile["gender"] as! String
        let phone = profile["phone"] as! String
        let email = profile["email"] as! String
        let image = profile["profile_image"] as! String
        print(name+gender+phone+email)
        DispatchQueue.main.async {
           self.profileLoadingIndicator.isHidden = true
        }
        //--load image
        self.loadImage(fromUrl: image , andDisplayIn: self.imageView)
    }
    task.resume()
 }
    
    func loadImage(fromUrl imageUrl:String, andDisplayIn imageView: UIImageView){
        let url = URL(string: imageUrl)!
        let task = URLSession.shared.dataTask(with:url){ (data,response,error) in
            let image = UIImage(data: data!)
            imageView.image = image
        }
        task.resume()
    }


    
}
