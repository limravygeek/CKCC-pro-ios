//
//  UpdateNewsViewController.swift
//  PelprekNews
//
//  Created by lim ravy on 15/6/2560 BE.
//  Copyright © 2560 BE lim ravy. All rights reserved.
//

import UIKit

struct cellDataUpdate{
    let id    : Int!
    let title : String!
    let desc  : String!
    let publishDate : String!
    let image : String!
}

class UpdateNewsViewController: UITableViewController {
    
      var arrayofCellData  = [cellDataUpdate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mID = loadActionTagFromUserDefaults()
        let newID:String = ("\(mID)")
        loadData(id: newID)
        tableView.reloadData()
        print("this is my is \(loadActionTagFromUserDefaults())")
    }
    
    func loadActionTagFromUserDefaults()->Int{
      let actiontag = UserDefaults.standard.value(forKey: "actiontag") as! Int
      return actiontag
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true,completion: nil)
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayofCellData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell_updatenews") as! UpdateNewsTableViewCell
        
        cell.TitleTextField.text = arrayofCellData[indexPath.row].title
        cell.CotentTextView.text = arrayofCellData[indexPath.row].desc
        let url = URL(string: arrayofCellData[indexPath.row].image)!
        let task = URLSession.shared.dataTask(with:url){ (data,response,error) in
            let image = UIImage(data: data!)
            cell.myImage.image = image
        }
        task.resume()
        return cell
        
    }
    
    func loadData(id: String){
        let url = URL(string: "http://hrdams.herokuapp.com/api/article/hrd_det001")!
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
                let article  =  json["RES_DATA"] as! [String:Any]
                let id = article["id"] as! Int
                let title = article["title"] as! String
                let content = article["description"] as! String
                let publishDate = article["publishDate"] as! String
                let image = article["image"] as! String
                let mainImage = "http://hrdams.herokuapp.com/"
                let article1 = cellDataUpdate(id:id,title:title,desc:content,publishDate:publishDate,image:mainImage+image)
                self.arrayofCellData.append(article1)
                print(mainImage+image)
                self.tableView.reloadData()
            } catch {
                print("error:", error)
            }
        }
        task.resume()
    }

}
