//
//  InsertNewsViewController.swift
//  PelprekNews
//
//  Created by lim ravy on 20/6/2560 BE.
//  Copyright © 2560 BE lim ravy. All rights reserved.
//

import UIKit
import Alamofire

class InsertNewsViewController: UIViewController , UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var TitleTextView: UITextField!
    
    @IBOutlet weak var ContentTextView: UITextView!

    @IBOutlet weak var btnImage: UIButton!
    
    @IBOutlet weak var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ContentTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        ContentTextView.layer.cornerRadius = 5
        ContentTextView.layer.borderWidth = 1.0
        ContentTextView.backgroundColor = UIColor.white
        
        btnImage.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        btnImage.layer.cornerRadius = 5
        btnImage.layer.borderWidth = 1.0
        
        btnSave.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        btnSave.layer.cornerRadius = 5
    }
    
    @IBAction func clickBrowseImage(_ sender: Any) {
        
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
    
    @IBAction func btnBack(_ sender: Any) {
       back()
    }
    
    @IBAction func btnSave(_ sender: Any) {
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
                        
                        let title = self.TitleTextView.text!
                        let desc  = self.ContentTextView.text!
                        let userId = "000"
                        let image  = imageURL
                        
                        self.sendNewsToServer(title: title, description: desc, userID: userId, image: image)
                        
                        //-------end insert data-------
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
        
    }
    
    //----upload article
    func sendNewsToServer(title:String,description:String,userID:String,image:String){
    
        let url = URL(string: "http://hrdams.herokuapp.com/api/article/hrd_c001")!
        let jsonDict = ["title": title, "description": description,"userId": userID, "image": image]
        
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
    
    func back(){
        navigationController?.popViewController(animated: true)
        dismiss(animated: true,completion: nil)
        
    }

    
    

}
