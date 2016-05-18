//
//  ViewController.swift
//  AppbookLogin
//
//  Created by User on 30/03/16.
//  Copyright © 2016 IN2 iOS team. All rights reserved.
//





import UIKit
import AFNetworking


class LoginViewController: UIViewController, NSURLSessionDelegate
{
    
    // MARK: Properties
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!

    @IBOutlet weak var signinButton: UIButton!
   
    @IBOutlet weak var appbookLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        appbookLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 45.0)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        signinButton.layer.cornerRadius = 10.0
        signinButton.layer.borderWidth = 2.0
        signinButton.layer.borderColor = UIColor.whiteColor().CGColor
        userName.layer.borderWidth = 2.0
        userName.layer.borderColor = UIColor.whiteColor().CGColor
        userName.layer.cornerRadius = 5.0
        password.layer.borderWidth = 2.0
        password.layer.borderColor = UIColor.whiteColor().CGColor
        password.layer.cornerRadius = 5.0
      
        
       
        if KeychainWrapper.hasValueForKey("appbookp") {
            password.text = KeychainWrapper.stringForKey("appbookp")
            userName.text = KeychainWrapper.stringForKey("appbookID")
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func shouldPerformSegueWithIdentifier(identifier: String,
                                            sender: AnyObject!) -> Bool {
        if testFields() == false {
            return false
        }
        
        request("https://appbooktest.in2.hr/ords/appbookrest/user/login")
        
        return false
    }
    
    
    
    func request(url : String) {
        let manager = AFHTTPRequestOperationManager()
        let header = NSSet(objects: "text/html")
        manager.responseSerializer.acceptableContentTypes = header as Set<NSObject>
        let sp = AFSecurityPolicy(pinningMode: AFSSLPinningMode.None)
        sp.allowInvalidCertificates = true
        sp.validatesDomainName = false
        manager.securityPolicy = sp
        var parameter = [String : String]()
        parameter["username"] = userName.text
        parameter["password"] = password.text
        manager.POST( "https://appbooktest.in2.hr/ords/appbookrest/user/login",
                      parameters: parameter,
                      success: {  (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                        if let jsonResult = responseObject as? Dictionary<String, AnyObject> {
                            if let test = jsonResult["success"] as! Int! {
                               if test == 1 {
                                 self.succesSegue()
                                } else {
                                 self.failureMessage("Krivo ste unijeli korisničko ime ili lozinku!")
                                }
                            }
                        }
            },
                      failure: {(operation, error) in
                   print(error)
                    self.failureMessage("Greška s mrežom!")
                    
        })
        
    }
    
    
    func failureMessage(message : String){
        let action = UIAlertAction(title: "U redu", style: .Default) {action -> Void in
        }
        let alert = AlertMaker(title: "", message: message, style:  UIAlertControllerStyle.ActionSheet, actions: action)
        self.presentViewController(alert.getAlert(), animated: true, completion: nil)
    }
    
    
    func testFields() -> Bool{
        if (userName!.text!.isEmpty || password!.text!.isEmpty) {
            let alert = AlertMaker(title: "", message: "Nisu popunjena sva potrebna polja!", style: UIAlertControllerStyle.ActionSheet)
            alert.addAction("U redu", style: .Default) {
                action -> Void in
            }
            if (userName!.text!.isEmpty && password!.text!.isEmpty){
                self.userName.shake(10, withDelta: 10)
                self.password.shake(10, withDelta: 10)
            }
            else if (userName!.text!.isEmpty) {
                self.userName.shake(10, withDelta: 10)
            }
            else {
                self.password.shake(10, withDelta: 10)
            }
            self.presentViewController(alert.getAlert(), animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }
    
    
    func succesSegue(){
        if (userName.text != KeychainWrapper.stringForKey("appbookID") || password.text != KeychainWrapper.stringForKey("appbookp")) {
    
            let yesAction: UIAlertAction = UIAlertAction(title: "Da", style: .Default) { [unowned self] action -> Void in
    
                //Spremanje keychaina
                KeychainWrapper.setString(self.password.text!, forKey: "appbookp")
                KeychainWrapper.setString(self.userName.text!, forKey: "appbookID")
                self.performSegueWithIdentifier("loginSeg", sender: self)
            }
            
    
            let noAction: UIAlertAction = UIAlertAction(title: "Ne", style: .Default) { action -> Void in
                self.performSegueWithIdentifier("loginSeg", sender: self)
            }
            let alert = AlertMaker(title: "", message: "Želite li spremiti podatke o prijavi?", style:  UIAlertControllerStyle.ActionSheet, actions:  yesAction, noAction)
            self.presentViewController(alert.getAlert(), animated: true, completion: nil)}
            self.performSegueWithIdentifier("loginSeg", sender: self)
   
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
    }
   
}

