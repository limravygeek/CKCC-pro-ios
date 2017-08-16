//
//  DetailsTableViewController.swift
//  PelprekNews
//
//  Created by lim ravy on 9/6/2560 BE.
//  Copyright © 2560 BE lim ravy. All rights reserved.
//

import UIKit


struct cellDataDetail{
    let id    : Int!
    let title : String!
    let desc  : String!
    let publishDate : String!
    let image : String!
}

class DetailsTableViewController: UITableViewController {
    
    var arrayofCellData  = [cellDataDetail]()
    var myID:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.tableView.separatorColor = UIColor.clear
        
        let ID = String(myID)
        loadData(id:ID)
        tableView.reloadData()
    
    }

    @IBAction func onClickBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true,completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        tableView.reloadData()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_details") as! DetailsTableViewCell
        
        cell.titleDetail.text = arrayofCellData[indexPath.row].title
        cell.Datelabel.text = arrayofCellData[indexPath.row].publishDate
        cell.descDetail.text = arrayofCellData[indexPath.row].desc
//        
//                let imgurl = NSData(contentsOf: URL(string: arrayofCellData[indexPath.row].image!)!)
//                if imgurl != nil {
//                    cell.imageDetail.image = UIImage(data: imgurl! as Data)
//                }
        
        let url = URL(string: arrayofCellData[indexPath.row].image)!
        let task = URLSession.shared.dataTask(with:url){ (data,response,error) in
            let image = UIImage(data: data!)
            cell.imageDetail.image = image
        }
        task.resume()
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayofCellData.count
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    
//    }
    
//    func loadData(){
//        arrayofCellData = [
//            cellDataDetail(title:"សម្រង់គតិបែបចិត្តសាស្រ្តទាង៨ឃ្លា​ពីអ្នកប្រាជ្ញនិង បុគ្គលល្បីៗក្នុងលោក",
//                           desc:" សម្រង់គតិបែបចិត្តសាស្រ្តទាង៨ឃ្លា​ពីអ្នកប្រាអ្នកប្រាជ្ញនិង បុគ្គលល្បីៗក្នុងលោកសម្រង់គតិបគតិបែបចិត្តសាស្រ្តទាង៨ឃ្លា​ពីអ្នកប្រាជ្ញនិង លា​គលល្បីៗក្នុងលោកសម្រង់គតិបែបចិត្តតទាង៨ឃ្លា​ពីអ្នកប្រាជ្ញនិង បុគ្គលល្បីៗក្នុងលោកសម្រង់គតិបែបចិត្តនករ",
//                     image:"https://amazingslder.com/wp-content/uploads/2012/12/dandelion.jpg")
//          ]
//}

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
                let article1 = cellDataDetail(id:id,title:title,desc:content,publishDate:publishDate,image:mainImage+image)
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
