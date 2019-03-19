//
//  LoginViewController.swift
//  Kay RealEstate
//
//  Created by MacBook Pro on 25/06/2016.
//  Copyright © 2016 AJE AJE. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginViewController: UIViewController {

 //   @IBOutlet weak var tvEmail: UITextField!
  //  @IBOutlet weak var tvPassword: UITextField!
    @IBOutlet weak var loginFormView: UIStackView!
    
    let connector: DBConnector = DBConnector()
    
    var txtEmail: SkyFloatingLabelTextField!
    var txtPassword: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.

        let logDefaults = UserDefaults.standard
        logDefaults.set(false, forKey: "logged")
        logDefaults.synchronize()
        
        let tintColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        
        let blackColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        
        let darkGreyColor = UIColor(red: 31/255, green: 33/255, blue: 34/255, alpha: 1.0)
        
        
        txtEmail = SkyFloatingLabelTextField(frame: CGRect.init(x: 0, y: 0, width: 290, height: 45))
        
        txtEmail.placeholder = "Email"
        txtEmail.title = "Email Address"
        txtEmail.keyboardType = UIKeyboardType.emailAddress
        txtEmail.tintColor = tintColor
        txtEmail.textColor = blackColor
        txtEmail.lineColor = darkGreyColor
        txtEmail.selectedTitleColor = tintColor
        txtEmail.selectedLineColor = tintColor
        
        txtEmail.lineHeight = 1.0
        txtEmail.selectedLineHeight = 1.5
        
        self.loginFormView.addSubview(txtEmail)
        
        txtPassword = SkyFloatingLabelTextField(frame: CGRect.init(x: 0, y: 52, width: 290, height: 45))
        txtPassword.isSecureTextEntry = true
        txtPassword.placeholder = "Password"
        txtPassword.title = "Password"
        txtPassword.tintColor = tintColor
        txtPassword.textColor = blackColor
        txtPassword.lineColor = darkGreyColor
        txtPassword.selectedTitleColor = tintColor
        txtPassword.selectedLineColor = tintColor
        
        txtPassword.lineHeight = 1.0
        txtPassword.selectedLineHeight = 1.5
        
        self.loginFormView.addSubview(txtPassword)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func btnLogin(_ sender: AnyObject) {
        
        let useremail = txtEmail.text;
        let userpass = txtPassword.text;
        
        let params = ["email": useremail!, "password": userpass!]
        
        if(useremail!.isEmpty || userpass!.isEmpty) {
            let regAlert = UIAlertController(title: "Empty Fields", message: "All fields are required", preferredStyle: UIAlertControllerStyle.alert);
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
            
            regAlert.addAction(okAction);
            
            self.present(regAlert, animated: true, completion: nil);

        }
        
        else {
            
            let UserInfo: userInfo = userInfo()
            UserInfo.passWord = userpass!
            UserInfo.email = useremail!
            
            
            connector.validateUser(params) { responseObj, error in
                
                let response = responseObj?.object(forKey: "status") as? Int
                let sessionID = responseObj?.object(forKey: "sessionID")
                
                //let logDefaults = UserDefaults.standard
                //UserDefaults.standard.setValue(sessionID, forKey: "sessionId")
                //logDefaults.set(sessionID, forKey: "sessionUser")
                //logDefaults.synchronize()

                
                if (response == 1) {
                    
                    let logDefaults = UserDefaults.standard
                    logDefaults.set(sessionID, forKey: "sessionId")
                    logDefaults.synchronize()
                    
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeController") as! UITabBarController
                    self.present(next, animated: true, completion: nil)
                    
                }
                    
                else if(response == 0) {
                    let errAlert = UIAlertController(title: "Invalid Login", message: "Invalid username/password", preferredStyle: UIAlertControllerStyle.alert);
                    
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                    
                    errAlert.addAction(okAction);
                    
                    self.present(errAlert, animated: true, completion: nil);
                }
                    
                else {
                    let errAlert = UIAlertController(title: "Error", message: "Network Connection Problem. Check your internet connection and try again!", preferredStyle: UIAlertControllerStyle.alert);
                    
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                    
                    errAlert.addAction(okAction);
                    
                    self.present(errAlert, animated: true, completion: nil);
                    
                }

                
                
            }

            
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
