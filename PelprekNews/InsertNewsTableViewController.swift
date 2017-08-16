//
//  InsertNewsTableViewController.swift
//  PelprekNews
//
//  Created by lim ravy on 13/6/2560 BE.
//  Copyright © 2560 BE lim ravy. All rights reserved.
//

import UIKit

class InsertNewsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         self.tableView.separatorColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true,completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_insertnews") as! InsertNewsTableViewCell
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
