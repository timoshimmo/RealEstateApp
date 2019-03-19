//
//  DetailsViewController.swift
//  Kay RealEstate
//
//  Created by MacBook Pro on 06/10/2016.
//  Copyright © 2016 AJE AJE. All rights reserved.
//

import UIKit
import Foundation
import MessageUI
import ImageSlideshow


class DetailsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    var allDataArray: AnyObject!

    @IBOutlet weak var scrollViewBody: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var slideImages: UIImageView!
    @IBOutlet weak var lblPurchaseType: UILabel!
    
    @IBOutlet weak var lblPropertyType: UILabel!
    @IBOutlet weak var lblFurnishStatus: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    

    
    var dttitles: String!
    var dtpurchaseType: String!
    var dtpropertyType: String!
    var dtfurnishStatus: String!
    var dtprice: String!
    var dtimageName: String!
    var dtdescriptions: String!
    var dtdetails: String!
    var dtAddress: String!
    var dtID: Int!
    
    var dtSwImg1: String!
    var dtSwImg2: String!
    var dtSwImg3: String!
    var dtSwImg4: String!
    
    let EnquiryInfo: enquiryInfo = enquiryInfo()
    let connector: DBConnector = DBConnector()
    
    var userID: Int = 0
    
    @IBOutlet weak var sliderImage: ImageSlideshow!
    var slideshowTransitioningDelegate: ZoomAnimatedTransitioningDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollViewBody.contentSize = self.contentView.frame.size
        
        let kingfisherSource = [KingfisherSource(urlString: dtimageName)!, KingfisherSource(urlString: dtSwImg1)!, KingfisherSource(urlString: dtSwImg2)!, KingfisherSource(urlString: dtSwImg3)!, KingfisherSource(urlString: dtSwImg4)!]
        
        lblPurchaseType.text = dtpurchaseType
        lblPropertyType.text = dtpropertyType
        lblFurnishStatus.text = dtfurnishStatus
        lblDescription.text = dtdescriptions
        lblTitle.text = dttitles
        lblDetails.text = dtdetails
        lblAddress.text = dtAddress
        
        self.EnquiryInfo.price = Double(dtprice)!
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        self.EnquiryInfo.getPrice = numberFormatter.string(from: NSNumber(value: self.EnquiryInfo.price))!
        
        lblPrice.text = "NGN "+self.EnquiryInfo.getPrice
        
        
        let sessionID: AnyObject
        sessionID = UserDefaults.standard.value(forKey: "sessionId")! as AnyObject
        
        userID = Int(sessionID as! String)!
        
        sliderImage.backgroundColor = UIColor.white
        sliderImage.slideshowInterval = 5.0
        sliderImage.pageControlPosition = PageControlPosition.underScrollView
        sliderImage.pageControl.currentPageIndicatorTintColor = UIColor.lightGray;
        sliderImage.pageControl.pageIndicatorTintColor = UIColor.black;
        sliderImage.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        // try out other sources such as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        sliderImage.setImageInputs(kingfisherSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(DetailsViewController.didTap))
        sliderImage.addGestureRecognizer(recognizer)
        
    }
    
    func didTap() {
        sliderImage.presentFullScreenController(from: self)
    }
    
    @IBAction func btnEnquire(_ sender: AnyObject) {
        
        self.EnquiryInfo.location = lblAddress.text!
        self.EnquiryInfo.title = lblTitle.text!
        self.EnquiryInfo.userID = userID
        self.EnquiryInfo.propertyID = dtID
        self.EnquiryInfo.descriptionss = lblDescription.text!
        self.EnquiryInfo.propertyType = lblPropertyType.text!
        self.EnquiryInfo.purchaseType = lblPurchaseType.text!
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal

        
        let params = ["userid":EnquiryInfo.userID, "propertyid": self.EnquiryInfo.propertyID]
            
            self.connector.validateEnquiry(params) { responseObj, error in
                
                let statusCode = responseObj?.object(forKey: "status") as? Int
                
                if (statusCode == 1) {
                    
                    let errAlert = UIAlertController(title: "Enquiry", message: "You have already made an enquiry for this property. Would you like to re-enquire?", preferredStyle: UIAlertControllerStyle.alert);
                    
                    let EnquiryActionHandler = { (action:UIAlertAction!) -> Void in
                        
                        let paramsss = ["userid":self.EnquiryInfo.userID, "propid": self.EnquiryInfo.propertyID, "title": self.EnquiryInfo.title, "price": self.EnquiryInfo.price, "location": self.EnquiryInfo.location, "purType": self.EnquiryInfo.purchaseType] as [String : Any]
                        
                        self.connector.addNewEnquiry(paramsss as [String : AnyObject]) { responseObj, error in
                            
                            
                            let response = responseObj?.object(forKey: "status") as? Int
                            
                            if (response == 1) {
                                
                                let mailComposeViewController = self.configuredMailComposeViewController()
                                if MFMailComposeViewController.canSendMail() {
                                    self.present(mailComposeViewController, animated: true, completion: nil)
                                } else {
                                    self.showSendMailErrorAlert()
                                }
                                
                                
                            }
                                
                            else if(response == 0) {
                                let errAlert = UIAlertController(title: "Error", message: "Error inserting data", preferredStyle: UIAlertControllerStyle.alert);
                                
                                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                                
                                errAlert.addAction(okAction);
                                
                                self.present(errAlert, animated: true, completion: nil);
                            }
                                
                            else {
                                let errAlert = UIAlertController(title: "Error", message: "No Internet Connection is available!", preferredStyle: UIAlertControllerStyle.alert);
                                
                                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                                
                                errAlert.addAction(okAction);
                                
                                self.present(errAlert, animated: true, completion: nil);
                                
                            }
                            
                            
                        }

                    }
                    
                    let okAction = UIAlertAction(title: "Re-Enquire", style: UIAlertActionStyle.default, handler: EnquiryActionHandler);

                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil);
                    
                    errAlert.addAction(okAction);
                    errAlert.addAction(cancelAction);
                    
                    self.present(errAlert, animated: true, completion: nil);
                    
                }
                else if(statusCode == 2) {
                    
                    let paramsss = ["userid":self.EnquiryInfo.userID, "propid": self.EnquiryInfo.propertyID, "title": self.EnquiryInfo.title, "price": self.EnquiryInfo.price, "location": self.EnquiryInfo.location, "purType": self.EnquiryInfo.purchaseType] as [String : Any]
                    
                    self.connector.addNewEnquiry(paramsss as [String : AnyObject]) { responseObj, error in
                        
                        
                        let response = responseObj?.object(forKey: "status") as? Int
                        
                        if (response == 1) {
                            
                            let mailComposeViewController = self.configuredMailComposeViewController()
                            if MFMailComposeViewController.canSendMail() {
                                self.present(mailComposeViewController, animated: true, completion: nil)
                            } else {
                                self.showSendMailErrorAlert()
                            }

                            
                        }
                        
                        else if(response == 0) {
                            let errAlert = UIAlertController(title: "Error", message: "Error inserting data", preferredStyle: UIAlertControllerStyle.alert);
                            
                            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                            
                            errAlert.addAction(okAction);
                            
                            self.present(errAlert, animated: true, completion: nil);
                        }
                            
                        else {
                            let errAlert = UIAlertController(title: "Error", message: "No Internet Connection is available!", preferredStyle: UIAlertControllerStyle.alert);
                            
                            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                            
                            errAlert.addAction(okAction);
                            
                            self.present(errAlert, animated: true, completion: nil);
                            
                        }

                        
                    }
                    
                    
                }
                    
                else {
                    
                    let errAlert = UIAlertController(title: "Error", message: "No Internet Connection is available!", preferredStyle: UIAlertControllerStyle.alert);
                    
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                    
                    errAlert.addAction(okAction);
                    
                    self.present(errAlert, animated: true, completion: nil);
                    
                }
                
                
            }
            
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        let proptyPrice:String = String(self.EnquiryInfo.price)
       // self.EnquiryInfo.price = proptyPrice
        
        let bookingMessage:String = "Property : \(self.EnquiryInfo.title) \n Details : \(self.EnquiryInfo.descriptionss) \n Property Style : \(self.EnquiryInfo.propertyType) \n Price : \(proptyPrice)"
       
        mailComposerVC.setToRecipients(["ajaysongz@gmail.com", "timoshimmo88@gmail.com"])
        
        mailComposerVC.setSubject("Enquiry")
        mailComposerVC.setMessageBody(bookingMessage, isHTML: false)
        
        return mailComposerVC
        
    }

    
    func showSendMailErrorAlert() {
        
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
        
        sendMailErrorAlert.addAction(okAction);
        
        self.present(sendMailErrorAlert, animated: true, completion: nil);
        
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
        
        if(result == MFMailComposeResult.cancelled || result == MFMailComposeResult.sent) {
            
            switch(result) {
                
            case MFMailComposeResult.cancelled:
                print("Message was cancelled!")
                
                break;
                
            case MFMailComposeResult.sent:
                let regAlert = UIAlertController(title: "Enquiry Sent Successfully", message: "Your enquiry has been sent to our email. Our agents will contact you via your ergistered email or mobile phone for more details.", preferredStyle: UIAlertControllerStyle.alert);
                
                let EnquiryActionHandler = { (action:UIAlertAction!) -> Void in
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeController") as! UITabBarController
                    self.present(next, animated: true, completion: nil)
                }
                
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: EnquiryActionHandler);
                
                regAlert.addAction(okAction);
                
                self.present(regAlert, animated: true, completion: nil);
                
                break;
                
                
            default:
                break;
                
            }
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
