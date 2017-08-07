//
//  SettingTableViewController.swift
//  PelprekNews
//
//  Created by lim ravy on 9/6/2560 BE.
//  Copyright © 2560 BE lim ravy. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
           }

  
    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.row == 0 {
            print("this is profile")
        }else if indexPath.row == 1{
            print("this is edit profile")
                self.performSegue(withIdentifier: "seque_editprofile", sender: nil)
        }else if indexPath.row == 2{
            print("this is share profile")
        }else{
           print("this is logout")
        }
    
    }

   
}
