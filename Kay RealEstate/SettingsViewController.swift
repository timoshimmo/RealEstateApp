//
//  SettingsViewController.swift
//  Kay RealEstate
//
//  Created by MacBook Pro on 21/08/2016.
//  Copyright © 2016 AJE AJE. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var ProfileSettingsView: UIView!
    @IBOutlet weak var FullNameView: UIView!
    @IBOutlet weak var EmailView: UIView!
    @IBOutlet weak var MobileView: UIView!
    @IBOutlet weak var PasswordView: UIView!
    
    var txtName: UITextField?
    var txtPhone: UITextField?
    var txtEmail: UITextField?
    
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    var userID: Int = 0
    
    let connector: DBConnector = DBConnector()
    
    var getUserDetails:AnyObject!
    var getFirstName:String!
    var getLastName:String!
    var getEmail:String!
    var getMobile:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shadowPath = UIBezierPath(rect: ProfileSettingsView.bounds)
        
        
      //  let prefShadowPath = UIBezierPath(rect: PreferenceSettingsView.bounds)
        
        ProfileSettingsView.layer.masksToBounds = false
        ProfileSettingsView.layer.shadowColor = UIColor.darkGray.cgColor
        ProfileSettingsView.layer.shadowOffset = CGSize(width: 0, height: 0.3)
        ProfileSettingsView.layer.shadowOpacity = 0.2
        ProfileSettingsView.layer.shadowRadius = 1.0
        ProfileSettingsView.layer.shadowPath = shadowPath.cgPath
        
       /* PreferenceSettingsView.layer.masksToBounds = false
        PreferenceSettingsView.layer.shadowColor = UIColor.black.cgColor
        PreferenceSettingsView.layer.shadowOffset = CGSize(width: 0, height: 0.7)
        PreferenceSettingsView.layer.shadowOpacity = 0.7
        PreferenceSettingsView.layer.shadowRadius = 1.0
        PreferenceSettingsView.layer.shadowPath = prefShadowPath.cgPath */
        
        
        let sessionID: AnyObject
        sessionID = UserDefaults.standard.value(forKey: "sessionId")! as AnyObject

       // loggedUser = UserDefaults.standard.object(forKey: "sessionUser")! as AnyObject
       userID = Int(sessionID as! String)!
        
        
        //let params = ["userId":userID]
        
        let fullNameTap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.nameViewTapped(_:)))
        let emailTap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.emailViewTapped(_:)))
        let mobileTap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.mobileViewTapped(_:)))
        let passwordTap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.passwordViewTapped(_:)))

        
        FullNameView.addGestureRecognizer(fullNameTap)
        EmailView.addGestureRecognizer(emailTap)
        MobileView.addGestureRecognizer(mobileTap)
        PasswordView.addGestureRecognizer(passwordTap)
    
        
        let params = ["userId":self.userID as Int]
        
       // + " " +
        
        self.connector.getUserData(params) { responseObj, error in
            
            self.getUserDetails = responseObj as AnyObject!
            
            self.getFirstName = (self.getUserDetails.object(at: 0) as AnyObject).object(forKey: "firstName") as? String!
            self.getLastName = (self.getUserDetails.object(at: 0) as AnyObject).object(forKey: "lastName") as? String!
            self.getEmail = (self.getUserDetails.object(at: 0) as AnyObject).object(forKey: "email") as? String!
            self.getMobile = (self.getUserDetails.object(at: 0) as AnyObject).object(forKey: "mobile") as? String!
            
            if(self.getFirstName != nil || self.getLastName != nil) {
                self.lblFullName.text = self.getFirstName + " " + self.getLastName
            }
            
            else {
                self.lblFullName.text = "--"
            }
            
            if(self.getEmail != nil) {
               self.lblEmail.text = self.getEmail
            }
            
            else {
                self.lblEmail.text = "--"
            }
            
            if(self.getMobile != nil) {
                self.lblMobile.text = self.getMobile
            }
            
            else {
                self.lblMobile.text = "--"
            }
            
            
        }


        // Do any additional setup after loading the view.
    }
    
    func nameViewTapped(_ Sender: UITapGestureRecognizer) {
        
        let alertController = UIAlertController(title: "Edit Name", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            
            alert -> Void in
            
            let fNameTextField = alertController.textFields![0] as UITextField
            let lNameTextField = alertController.textFields![1] as UITextField
            
            let fname = fNameTextField.text
            let lname = lNameTextField.text
            
            let UserInfo: userInfo = userInfo()
            UserInfo.firstName = fname!
            UserInfo.lastName = lname!

            //self.userID as Int
            
            let params = ["firstName":UserInfo.firstName as String, "lastName": UserInfo.lastName as String, "userId":self.userID as Int] as [String : Any]
            
            self.connector.editUsersNames(params as [String : AnyObject])  { responseObj, error in
                
                
                if let statusCode = responseObj?["status"]! as? Int {
                    
                    if (statusCode == 1) {
                        
                        self.lblFullName.text = UserInfo.firstName + " " + UserInfo.lastName
                        
                        let regAlert = UIAlertController(title: "Success", message: "Profile successfully updated!", preferredStyle: UIAlertControllerStyle.alert);
                        
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                        
                        regAlert.addAction(okAction);
                        
                        self.present(regAlert, animated: true, completion: nil);
                    }
                        
                    else {
                        let errAlert = UIAlertController(title: "Error", message: "Error updating profile", preferredStyle: UIAlertControllerStyle.alert);
                        
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                        
                        errAlert.addAction(okAction);
                        
                        self.present(errAlert, animated: true, completion: nil);
                        
                    }
                    
                    
                }
                
            }
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            
            textField.placeholder = "First Name"
            self.txtName = textField
            
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            
            textField.placeholder = "Last Name"
            self.txtName = textField
            
        }
        
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    func emailViewTapped(_ Sender: UITapGestureRecognizer) {
        
        let alertController = UIAlertController(title: "Edit Email", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            
            alert -> Void in
            
            let emailTextField = alertController.textFields![0] as UITextField
            let emailAdd = emailTextField.text
            
            let UserInfo: userInfo = userInfo()
            UserInfo.email = emailAdd!
        
            
            let params = ["email":UserInfo.email as String, "userId":self.userID as Int] as [String : Any]
            
            self.connector.editUsersEmail(params as [String : AnyObject]) { responseObj, error in
                
                if let statusCode = responseObj?["status"]! as? Int {
                    
                    if (statusCode == 1) {
                        
                        self.lblEmail.text = UserInfo.email
                        
                        let regAlert = UIAlertController(title: "Success", message: "Profile successfully updated!", preferredStyle: UIAlertControllerStyle.alert);
                        
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                        
                        regAlert.addAction(okAction);
                        
                        self.present(regAlert, animated: true, completion: nil);
                        
                    }
                        
                    else {
                        let errAlert = UIAlertController(title: "Error", message: "Error updating profile", preferredStyle: UIAlertControllerStyle.alert);
                        
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                        
                        errAlert.addAction(okAction);
                        
                        self.present(errAlert, animated: true, completion: nil);
                        
                    }
                    
                    
                }

                
            }
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            
            textField.placeholder = "Email"
            textField.keyboardType = UIKeyboardType.emailAddress
            self.txtEmail = textField

        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    func mobileViewTapped(_ Sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "Edit Mobile No.", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            
            alert -> Void in
            
            let mobileTextField = alertController.textFields![0] as UITextField
            let mobileNo = mobileTextField.text
            
            let UserInfo: userInfo = userInfo()
            UserInfo.mobileNo = mobileNo!
            
            let params = ["mobile":UserInfo.mobileNo as String, "userId":self.userID as Int] as [String : Any]
            
            self.connector.editUsersMobile(params as [String : AnyObject]) { responseObj, error in
                
                if let statusCode = responseObj?["status"]! as? Int {
                    
                    if (statusCode == 1) {
                        
                        self.lblMobile.text = UserInfo.mobileNo
                        
                        let regAlert = UIAlertController(title: "Success", message: "Profile successfully updated!", preferredStyle: UIAlertControllerStyle.alert);
                        
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                        
                        regAlert.addAction(okAction);
                        
                        self.present(regAlert, animated: true, completion: nil);
                    }
                        
                    else {
                        let errAlert = UIAlertController(title: "Error", message: "Error updating profile", preferredStyle: UIAlertControllerStyle.alert);
                        
                        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                        
                        errAlert.addAction(okAction);
                        
                        self.present(errAlert, animated: true, completion: nil);
                        
                    }
                    
                    
                }
                
            }

            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            
            textField.placeholder = "Mobile No."
            textField.keyboardType = UIKeyboardType.phonePad
            self.txtPhone = textField
            
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func passwordViewTapped(_ Sender: UITapGestureRecognizer) {
        
        let alertController = UIAlertController(title: "Edit Password", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            
            alert -> Void in
            
            let newPasswordTextField = alertController.textFields![0] as UITextField
            let confirmPasswordTextField = alertController.textFields![1] as UITextField
            
            let newPass = newPasswordTextField.text
            let cfrmPass = confirmPasswordTextField.text
            
            if((newPass?.characters.count)! < 6) {
                let regAlert = UIAlertController(title: "Incorrect Entry", message: "Your password must be more than 6 characters", preferredStyle: UIAlertControllerStyle.alert);
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                
                regAlert.addAction(okAction);
                
                self.present(regAlert, animated: true, completion: nil);
            }
                
            else {
                
                if(newPass != cfrmPass) {
                    let regAlert = UIAlertController(title: "Incorrect Entry", message: "Your new passwords are not the same. Try again!", preferredStyle: UIAlertControllerStyle.alert);
                    
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                    
                    regAlert.addAction(okAction);
                    
                    self.present(regAlert, animated: true, completion: nil);
                }
                    
                else {
                    
                    let UserInfo: userInfo = userInfo()
                    UserInfo.passWord = newPass!
                    
                    let params = ["userpass":UserInfo.passWord as String, "userId":self.userID as Int] as [String : Any]
                    
                    self.connector.editUsersPassword(params as [String : AnyObject]) { responseObj, error in
                        
                        if let statusCode = responseObj?["status"]! as? Int {
                            
                            if (statusCode == 1) {
                                
                                
                                let regAlert = UIAlertController(title: "Success", message: "Profile successfully updated!", preferredStyle: UIAlertControllerStyle.alert);
                                
                                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                                
                                regAlert.addAction(okAction);
                                
                                self.present(regAlert, animated: true, completion: nil);
                            }
                                
                            else {
                                let errAlert = UIAlertController(title: "Error", message: "Error updating profile", preferredStyle: UIAlertControllerStyle.alert);
                                
                                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                                
                                errAlert.addAction(okAction);
                                
                                self.present(errAlert, animated: true, completion: nil);
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            
            textField.placeholder = "New Password"
            self.txtName = textField
            
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            
            textField.placeholder = "Confirm Password"
            self.txtName = textField
            
        }
        
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }

    
    @IBAction func btnLogout(_ sender: AnyObject) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "LoginController") as! LoginViewController
        self.present(next, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
