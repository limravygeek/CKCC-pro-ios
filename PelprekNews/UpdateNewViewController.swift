//
//  UpdateNewViewController.swift
//  PelprekNews
//
//  Created by lim ravy on 20/6/2560 BE.
//  Copyright © 2560 BE lim ravy. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class UpdateNewViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var TitleTextField: UITextField!
    @IBOutlet weak var CotentTextView: UITextView!
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CotentTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        CotentTextView.layer.cornerRadius = 5
        CotentTextView.layer.borderWidth = 1.0
        CotentTextView.backgroundColor = UIColor.white
        
        btnImage.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        btnImage.layer.cornerRadius = 5
        btnImage.layer.borderWidth = 1.0
        
        btnUpdate.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        btnUpdate.layer.cornerRadius = 5
        
        let mID = loadActionTagFromUserDefaults()
        let newID:String = ("\(mID)")
        loadData(id: newID)
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        back()
    }
    
    @IBAction func clickButtonBrowseImage(_ sender: Any) {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image,animated:true)
        {
            //after it is complete
        }
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.btnImage.setBackgroundImage(image, for: .normal)
            self.btnImage.setImage(image, for: .normal)
        }else
        {
            //Error message
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func loadActionTagFromUserDefaults()->Int{
        let actiontag = UserDefaults.standard.value(forKey: "actiontag") as! Int
        return actiontag
    }

    
    
    @IBAction func clickBtnUpdate(_ sender: Any) {
        uploadImage()
    }
    
    
    //---func upload image
    
    func uploadImage(){
        
        alertDialog()
        
        let imgData = UIImageJPEGRepresentation((btnImage.backgroundImage(for: .normal))!, 0.2)!
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "ART_IMG",fileName: "file.jpg", mimeType: "image/jpeg")
        },
                         to:"https://hrdams.herokuapp.com/api/article/upload_image")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    DispatchQueue.main.async {
                        //                        self.progressLabel.text = ("\(Int(progress.fractionCompleted) * 100)%")
                    }
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        let imageURL = JSON["ART_IMG"] as! String
                        print(imageURL)
                        
                        //-------insert data----------
                
                        let actiontag = self.loadActionTagFromUserDefaults()
                        let id = ("\(actiontag)")
                        let title = self.TitleTextField.text!
                        let description = self.CotentTextView.text!
                        let myID = "000"
                        let image = imageURL
                        self.updateNewsToServer(id: id, title: title, description:  description, enabled: true, userID:myID, image:image )
                        
                        //-------end insert data-------
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
        
    }
    
    
    
    //----update article
    func updateNewsToServer(id:String,title:String,description:String,enabled:Bool,userID:String,image:String){
        
        let url = URL(string: "http://hrdams.herokuapp.com/api/article/hrd_u001")!
        let jsonDict = ["id":id,"title": title, "description": description,"enabled":enabled,"userId": userID, "image": image] as [String : Any]
        
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
            do{
                print("ok now it work")
                let content = String(data:data!,encoding:.utf8)
                print("Content :", content!)
                 self.dismiss(animated: false, completion: nil)
                self.back()
            }catch {
                print("error:", error)
            }
        }
        
        task.resume()
    }
    

    
    
    
    
    
    
    func alertDialog(){
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
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
               
            DispatchQueue.main.async {
                self.TitleTextField.text = title
                self.CotentTextView.text = content
                let url = URL(string: mainImage+image)!
                self.btnImage.sd_setImage(with: url, for: .normal)
                self.btnImage.sd_setShowActivityIndicatorView(true)
                self.btnImage.sd_setIndicatorStyle(.gray)
            }
            print(mainImage+image)
                
            } catch {
                print("error:", error)
            }
        }
        task.resume()
    }
    
    
    func back(){
        navigationController?.popViewController(animated: true)
        dismiss(animated: true,completion: nil)
    }

    

    
    

   

}
