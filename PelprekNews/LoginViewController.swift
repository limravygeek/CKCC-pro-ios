//
//  LoginViewController.swift
//  PelprekNews
//
//  Created by lim ravy on 30/7/2560 BE.
//  Copyright © 2560 BE lim ravy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLogin.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        btnLogin.layer.cornerRadius = 5
        
        
        
    }
    
    @IBAction func btnLoginClick(_ sender: Any) {
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
