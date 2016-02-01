//
//  ProfileVC.swift
//  PokeYou
//
//  Created by Lalit on 2016-02-01.
//  Copyright © 2016 Bagga. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class ProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextFieldDelegate{
    
    
    @IBOutlet weak var addPic: UIButton!
    @IBOutlet weak var profileImage :UIImageView!
    var imageSelected = false
    
    @IBOutlet weak var userName: TextFieldsView!
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        userName.delegate = self
    }
    
    @IBAction func onAddPic(sender: AnyObject) {
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        userName.resignFirstResponder()
        return true
    }
    @IBAction func onSaveButtonPressed(sender: AnyObject)
    {
        
        if let text = userName.text where text != ""{
            if let img = profileImage.image where imageSelected == true{
                let urlString = "https://post.imageshack.us/upload_api.php"
                let nsUrl = NSURL(string: urlString)!
                let imgData = UIImageJPEGRepresentation(img, 0.2)!
                let keyData = IMAGE_SHACK_KEY.dataUsingEncoding(NSUTF8StringEncoding)!
                let keyJson = "json".dataUsingEncoding(NSUTF8StringEncoding)!
                Alamofire.upload(.POST, nsUrl, multipartFormData: { multipartFormData in
                    
                    multipartFormData.appendBodyPart(data:imgData,name:"fileupload",fileName:"image",mimeType:"image/jpg")
                    multipartFormData.appendBodyPart(data:keyData , name:"key")
                    multipartFormData.appendBodyPart(data: keyJson, name: "format")
                    
                    
                    }) { encodingResult in
                        
                        switch encodingResult {
                        case .Success(let upload, _, _):
                            upload.responseJSON(completionHandler: { response in
                                let result = response.result
                                if let info = result.value as? Dictionary<String, AnyObject> {
                                    
                                    if let links = info["links"] as? Dictionary<String, AnyObject> {
                                        if let imageLink = links["image_link"] as? String{
                                            // print(imageLink)
                                            self.postToFirebase(imageLink)
                                        }
                                        
                                    }
                                }
                                                            })
                            
                        case .Failure(let error):
                            print(error)
                            //Maybe show alert to user and let them try again
                        }
                }
                
                
                
            }
        }
        
    }
    func postToFirebase(imageUrl:String?){
        var post :Dictionary<String,AnyObject> = [
        "username":userName.text!
        ]
        if imageUrl != nil {
            post["imageUrl"] = imageUrl!
        }
        print(DataServices.ds.REF_USERS_CURRENT)
        let fireBasePost = DataServices.ds.REF_USERS_CURRENT.childByAppendingPath("User")
        fireBasePost.setValue(post)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        profileImage.image = image
        addPic.hidden = true
        imageSelected = true
        
        
    }
   

   

}
