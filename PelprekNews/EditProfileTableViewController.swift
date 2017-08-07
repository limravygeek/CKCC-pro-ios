//
//  EditProfileTableViewController.swift
//  PelprekNews
//
//  Created by lim ravy on 9/6/2560 BE.
//  Copyright © 2560 BE lim ravy. All rights reserved.
//

import UIKit

class EditProfileTableViewController: UITableViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.tableView.separatorColor = UIColor.clear
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true,completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_editprofile") as! EditprofileTableViewCell
        
        
        return cell
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return 1
    }
    
   
    
    
    

}
