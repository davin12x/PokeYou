//
//  FeedVC.swift
//  PokeYou
//
//  Created by Lalit on 2016-01-28.
//  Copyright © 2016 Bagga. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var imageSelectorImage: UIImageView!
    
    @IBOutlet weak var postField: UITextField!
    var imagePicker :UIImagePickerController!
    var post = [Post]()
    var imageSelected = false
    static var imageCache = NSCache()
    @IBOutlet weak var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        tableView.estimatedRowHeight = 380
        
        DataServices.ds.REF_POSTS.observeEventType(.Value, withBlock: {
            snapshot in
            //print(snapshot.value)
            self.post = []// To clear data
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
                for snap in snapshots {
                   // print(snap)
                    if let postDict = snap.value as? Dictionary<String,AnyObject>{
                         let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.post.append(post)
                    }
                }
            
            }
            self.tableView.reloadData()
        })
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let posts = post[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell{
            cell.request?.cancel()
            var img :UIImage?
            if let url = posts.imageUrl{
                img = FeedVC.imageCache.objectForKey(url) as? UIImage
            }
            
            cell.configureCell(posts,img: img)
            return cell

        }else{
            return PostCell()
        }
        
    }
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let posts = post[indexPath.row]
        if posts.imageUrl == nil{
            return 150
            
        }else{
            return tableView.estimatedRowHeight
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageSelectorImage.image = image
        imageSelected = true
    }
  
    @IBAction func selectimage(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func onPostPressed(sender: AnyObject) {
        
        if let text = postField.text where text != ""{
            if let img = imageSelectorImage.image where imageSelected == true{
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
        else{
            self.postToFirebase(nil)
        }
    }
    func postToFirebase(imageUrl:String?){
        var post: Dictionary<String,AnyObject> = [
            "description":postField.text!,
            "likes":0
        ]
        if imageUrl != nil{
            post["imageUrl"] = imageUrl!
        }
        let firebasePost = DataServices.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        postField.text = ""
        imageSelectorImage.image = UIImage(named: "camera-icon")
        imageSelected = false
        tableView.reloadData()
    }
}
