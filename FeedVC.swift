//
//  FeedVC.swift
//  PokeYou
//
//  Created by Lalit on 2016-01-28.
//  Copyright © 2016 Bagga. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var post = [Post]()
    static var imageCache = NSCache()
    @IBOutlet weak var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.estimatedRowHeight = 379
        DataServices.ds.REF_POSTS.observeEventType(.Value, withBlock: {
            snapshot in
            //print(snapshot.value)
            self.post = []// To clear data
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
                for snap in snapshots {
                    print(snap)
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
        //print(posts.postDesc)
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
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        let posts = post[indexPath.row]
//        if posts.imageUrl == nil{
//            return 200
//        }
//        else{
//            return tableView.estimatedRowHeight
//        }
//    }
}
