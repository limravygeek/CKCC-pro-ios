//
//  DetailViewController.swift
//  PelprekNews
//
//  Created by lim ravy on 20/6/2560 BE.
//  Copyright © 2560 BE lim ravy. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailDate: UILabel!
    @IBOutlet weak var detailDesc: UILabel!
     var myID:Int!
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        let ID = String(myID)
        loadData(id:ID)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true,completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
                //let id = article["id"] as! Int
                let title = article["title"] as! String
                let content = article["description"] as! String
                let publishDate = article["publishDate"] as! String
                let image = article["image"] as! String
                let mainImage = "http://hrdams.herokuapp.com/"
                
                
                DispatchQueue.main.async {
                self.detailTitle.text = title
                self.detailDate.text = publishDate
                self.detailDesc.text = content
                

                    
                self.detailImage.sd_setImage(with: URL(string:mainImage+image), placeholderImage: UIImage(named: "images.png"))
                    self.detailImage.sd_setShowActivityIndicatorView(true)
                    self.detailImage.sd_setIndicatorStyle(.gray)
                    
                    print(image)
                    print(mainImage+image)
                    
                }
            } catch {
                print("error:", error)
            }
        }
        
        task.resume()
        
        
    }

    

    

}
