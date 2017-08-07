//
//  SearchTableViewController.swift
//  PelprekNews
//
//  Created by lim ravy on 21/6/2560 BE.
//  Copyright © 2560 BE lim ravy. All rights reserved.
//

import UIKit

struct cellDataSearch{
    let id    : Int!
    let title : String!
    let desc  : String!
    let publishDate : String!
    let image : String!
}

class SearchTableViewController: UITableViewController ,UISearchResultsUpdating{
    
    var arrayofCellData  = [cellData]()
    var arrayOfCellDatafilter = [cellData]()
    var searchActive : Bool = false
    var searchString  = "hello"

    
    var array = ["One","Two","Three","Four","Five"]
    var filteredArray = [String]()
    var searchController = UISearchController()
    var resultsController = UITableViewController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDatafromServer()
       
        
        searchController = UISearchController(searchResultsController: resultsController)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        
        resultsController.tableView.delegate = self
        resultsController.tableView.dataSource = self
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    
        // searchString = searchController.searchBar.text!
        
        //print(searchString)
        //arrayOfCellDatafilter = []
        searchDatafromServer(text: searchString)
        
        filteredArray = array.filter({ (array:String) -> Bool in
            if array.contains(searchController.searchBar.text!){
                
                searchActive = true
                return true
            }else{
                
                 searchActive = false
                return false
            }
        
            return false

    
    
        })
        resultsController.tableView.reloadData()
       tableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == resultsController.tableView{
            
            return filteredArray.count
            //return arrayofCellData.count
            
        } else {
            //return array.count
            return arrayofCellData.count
        }
       
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_news") as? NewsTableViewCell
        
        DispatchQueue.main.async {
            
            cell?.title_label.text = self.arrayofCellData[indexPath.row].title
            cell?.date_label.text = self.arrayofCellData[indexPath.row].publishDate
            let imageURLS = self.arrayofCellData[indexPath.row].image
            cell?.news_image.sd_setImage(with: URL(string:imageURLS!), placeholderImage: UIImage(named: "images.png"))
            cell?.news_image.sd_setShowActivityIndicatorView(true)
            cell?.news_image.sd_setIndicatorStyle(.gray)
            
        }
      
        return cell!
    
    }

    
    
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
                    self.refreshControl?.endRefreshing()
                }
                self.tableView.reloadData()
                
            } catch {
                print("error:", error)
            }
        }
        
        task.resume()
        
    }

    
    
    
    func searchDatafromServer(text:String){
        
        let url = URL(string: "http://hrdams.herokuapp.com/api/article/search/\(text)")!
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
                
                if json["STATUS"] as! Bool {
                    
                    for result in json["RES_DATA"] as! [Any] {
                        let article = result as! [String:Any]
                        let id  = article["id"] as! Int
                        let title = article["title"] as! String
                        let content = article["description"] as! String
                        let publishDate = article["publishDate"] as! String
                        let image = article["image"] as! String
                        let mainImage = "http://hrdams.herokuapp.com/"
                        let article1 = cellData(id:id,title:title,desc:content,publishDate:publishDate,image:mainImage+image)
                        self.arrayOfCellDatafilter.append(article1)
                        //print(mainImage+image)
                    }
                }else{
                   print("Not found")
                }
                
               // self.refreshControl?.endRefreshing()
               // self.tableView.reloadData()
                
            } catch {
                print("error:", error)
            }
        }
        
        task.resume()
        
    }
    

    
    
    
    
    
    
}
