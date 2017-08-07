//
//  NewsTableViewController.swift
//  PelprekNews
//
//  Created by lim ravy on 8/6/2560 BE.
//  Copyright © 2560 BE lim ravy. All rights reserved.
//

import UIKit
import SDWebImage

struct cellData{
    let id    : Int!
    let title : String!
    let desc  : String!
    let publishDate : String!
    let image : String!
}

class NewsTableViewController: UITableViewController , UIGestureRecognizerDelegate {

     var arrayofCellData  = [cellData]()
     var mid:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl?.beginRefreshing()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        loadDatafromServer()
    
    }
    
    
    @IBAction func pullRefresh(_ sender: Any) {
        
        arrayofCellData = []
        loadDatafromServer()
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        arrayofCellData = []
        loadDatafromServer()
        tableView.reloadData()
    }
    
    @IBAction func onClickbtnAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Acton", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "segue_editnews", sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in
            
            let refreshAlert = UIAlertController(title: "DELETE", message: "Are you sure wanna delete this news?", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                
                  let id = ("\(self.loadActionTagFromUserDefaults())")
                 self.deleteNews(id: id)
                //----------------------
                self.arrayofCellData = []
                self.loadDatafromServer()
                self.tableView.reloadData()
                //----------------------
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            
            self.present(refreshAlert, animated: true, completion: nil)
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func loadActionTagFromUserDefaults()->Int{
        let actiontag = UserDefaults.standard.value(forKey: "actiontag") as! Int
        return actiontag
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_news") as! NewsTableViewCell
        
        DispatchQueue.main.async {
            
        cell.title_label.text = self.arrayofCellData[indexPath.row].title
        cell.date_label.text = self.arrayofCellData[indexPath.row].publishDate
        let imageURLS = self.arrayofCellData[indexPath.row].image
        cell.news_image.sd_setImage(with: URL(string:imageURLS!), placeholderImage: UIImage(named: "images.png"))
        cell.news_image.sd_setShowActivityIndicatorView(true)
        cell.news_image.sd_setIndicatorStyle(.gray)
            
        }
        cell.btnAction.tag = arrayofCellData[indexPath.row].id
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return arrayofCellData.count
    }
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
      self.performSegue(withIdentifier: "cell_detail", sender: arrayofCellData[indexPath.row].id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "cell_detail" {
            let nav = segue.destination as! UINavigationController
            let svc = nav.topViewController as! DetailViewController
            svc.myID = sender as! Int
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
 
    
    func loadDatafromServer(){
        
        let url = URL(string: "http://hrdams.herokuapp.com/api/article/hrd_r001")!
        let jsonDict = ["row": "10", "pageCount": "1"]
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
                
                    for result in json["RES_DATA"] as! [Any] {
                        let article = result as! [String:Any]
                        let id  = article["id"] as! Int
                        let title = article["title"] as! String
                        let content = article["description"] as! String
                        let publishDate = article["publishDate"] as! String
                        let image = article["image"] as! String
                        let mainImage = "http://hrdams.herokuapp.com/"
                        let article1 = cellData(id:id,title:title,desc:content,publishDate:publishDate,image:mainImage+image)
                        self.arrayofCellData.append(article1)
                        //print(mainImage+image)
                       
                    }
                DispatchQueue.main.async {
                  self.refreshControl?.endRefreshing()
                  self.tableView.reloadData()
            }
                
            } catch {
                print("error:", error)
            }
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
    
    
    func deleteNews(id: String){
        let url = URL(string: "http://hrdams.herokuapp.com/api/article/hrd_d001")!
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
                let status  =  json["STATUS"] as! Bool
                
                print("this is status \(status)")
                
                self.tableView.reloadData()
                
            } catch {
                print("error:", error)
            }
        }
        
        task.resume()
    }
    
    
    
    

    
}
