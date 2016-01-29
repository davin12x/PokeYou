//
//  ViewController.swift
//  PokeYou
//
//  Created by Lalit on 2016-01-27.
//  Copyright © 2016 Bagga. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {
    
    @IBOutlet weak var email:UITextField!
    @IBOutlet weak var password:UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if NSUserDefaults.standardUserDefaults().valueForKey(key) != nil{
            performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
        
        
    }
    @IBAction func attemptLogin(sender:UIButton!){
        if let email = email.text where email != "" , let pass = password.text where pass != "" {
            DataServices.ds.REF_BASE.authUser(email,password: pass, withCompletionBlock: { error , authData in
                if error != nil{
                    print(error)
                    if error.code == STATUS_ACCOUNT_NONEXIST{
                        //Creating Account
                        DataServices.ds.REF_BASE.createUser(email, password: pass, withValueCompletionBlock: { error, result in
                            
                            if error != nil{
                                self.showErrorAlert("Could not create Accound", msg: "problem create account")
                            }
                            else{
                                NSUserDefaults.standardUserDefaults().setValue(result[key], forKey: key)
                                DataServices.ds.REF_BASE.authUser(email, password: pass, withCompletionBlock: nil)
                                
                                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                            }
                        })
                    }
                    else{
                        self.showErrorAlert("Could not login", msg: "Please check your Username and password")
                    }
                }
            })
            
        }
        else
        {
             showErrorAlert("Email & Password Required", msg: "You must check Your Fields")
        }
    }
    func showErrorAlert(title:String,msg:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style:.Default, handler:nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    @IBAction func onFacebookButtonPressed(sender:AnyObject){
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions(
            ["email"]) { (facebookResult:FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
                if error != nil{
                    print("facebook login failed\(error)")
                }
                else{
                    let accesstoken = FBSDKAccessToken.currentAccessToken().tokenString
                    print("Success logged in \(accesstoken)")
                    DataServices.ds.REF_BASE.authWithOAuthProvider("facebook", token: accesstoken, withCompletionBlock: { error, authData in
                        
                        if error != nil{
                            print("Login failed\(error)")
                        }
                        else{
                            print("Logged in \(authData)")
                            NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: key)
                            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                            
                        }
                    })
                    
                }
                
        }
        
    }

}

