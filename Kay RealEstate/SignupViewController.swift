//
//  SignupViewController.swift
//  Kay RealEstate
//
//  Created by MacBook Pro on 25/06/2016.
//  Copyright © 2016 AJE AJE. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SignupViewController: UIViewController {

  //  @IBOutlet weak var txtEmail: UITextField!
  //  @IBOutlet weak var txtPassword: UITextField!
  //  @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var signupInputForm: UIStackView!
    
    var textEmail: SkyFloatingLabelTextField!
    var textPassword: SkyFloatingLabelTextField!
    var textMobile: SkyFloatingLabelTextField!
    
    let connector: DBConnector = DBConnector()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignupViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let tintColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        
        let blackColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        
        let darkGreyColor = UIColor(red: 31/255, green: 33/255, blue: 34/255, alpha: 1.0)
        
        textEmail = SkyFloatingLabelTextField(frame: CGRect.init(x: 0, y: 0, width: 290, height: 45))
        
        textEmail.placeholder = "Email"
        textEmail.title = "Email Address"
        textEmail.keyboardType = UIKeyboardType.emailAddress
        textEmail.tintColor = tintColor
        textEmail.textColor = blackColor
        textEmail.lineColor = darkGreyColor
        textEmail.selectedTitleColor = tintColor
        textEmail.selectedLineColor = tintColor
        
        textEmail.lineHeight = 1.0
        textEmail.selectedLineHeight = 1.5
        
        self.signupInputForm.addSubview(textEmail)
        
        textPassword = SkyFloatingLabelTextField(frame: CGRect.init(x: 0, y: 52, width: 290, height: 45))
        textPassword.isSecureTextEntry = true
        textPassword.placeholder = "Password"
        textPassword.title = "Password"
        textPassword.tintColor = tintColor
        textPassword.textColor = blackColor
        textPassword.lineColor = darkGreyColor
        textPassword.selectedTitleColor = tintColor
        textPassword.selectedLineColor = tintColor
        
        textPassword.lineHeight = 1.0
        textPassword.selectedLineHeight = 1.5
        
        self.signupInputForm.addSubview(textPassword)
        
        
        
        textMobile = SkyFloatingLabelTextField(frame: CGRect.init(x: 0, y: 107, width: 290, height: 45))
        textMobile.keyboardType = UIKeyboardType.phonePad
        textMobile.placeholder = "Mobile"
        textMobile.title = "Mobile No."
        textMobile.tintColor = tintColor
        textMobile.textColor = blackColor
        textMobile.lineColor = darkGreyColor
        textMobile.selectedTitleColor = tintColor
        textMobile.selectedLineColor = tintColor
        
        textMobile.lineHeight = 1.0
        textMobile.selectedLineHeight = 1.5
        
        self.signupInputForm.addSubview(textMobile)
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnCreate(_ sender: AnyObject) {
        
        let emailAdd = textEmail.text;
        let password = textPassword.text;
        let mobileNum = textMobile.text;
        
        textMobile.keyboardType = UIKeyboardType.phonePad
        
        if(emailAdd!.isEmpty || password!.isEmpty || mobileNum!.isEmpty) {
            
            let regAlert = UIAlertController(title: "Error", message: "All fields are required", preferredStyle: UIAlertControllerStyle.alert);
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
            
            regAlert.addAction(okAction);
            
            self.present(regAlert, animated: true, completion: nil);
            
        }
            
        else {
            
            let UserInfo: userInfo = userInfo()
            UserInfo.passWord = password!
            UserInfo.email = emailAdd!
            UserInfo.mobileNo = mobileNum!
            
            
            let data = ["email": UserInfo.email,"password": UserInfo.passWord,"mobile": UserInfo.mobileNo]
            
            print("Email: \(UserInfo.email), Password: \(UserInfo.passWord), Mobile: \(UserInfo.mobileNo)")
            
            connector.addNewUser(data) { responseObj, error in
                
                let response = responseObj?.object(forKey: "status") as? Int
                
                print("Add User Result: \(String(describing: responseObj))")
                
                if (response == 1) {
                    
                    print(response!)
                    print("Signup Clicked!")
                    
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginViewController
                    self.present(next, animated: true, completion: nil)
                    
                } else if(response == 0) {
                    let errAlert = UIAlertController(title: "Error", message: "Error inserting data", preferredStyle: UIAlertControllerStyle.alert);
                    
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
