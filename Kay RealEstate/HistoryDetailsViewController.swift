//
//  HistoryDetailsViewController.swift
//  Kay RealEstate
//
//  Created by MacBook Pro on 29/10/2016.
//  Copyright © 2016 AJE AJE. All rights reserved.
//

import UIKit

class HistoryDetailsViewController: UIViewController {

    
    var proptyID: Int!
    
    @IBOutlet weak var propImage: UIImageView!
    @IBOutlet weak var lblPurchaseType: UILabel!
    @IBOutlet weak var propertyType: UILabel!
    @IBOutlet weak var furnishStatus: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblPropDesc: UILabel!
    @IBOutlet weak var lblPropTitle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    var historyDetailsArrays: AnyObject!
    
    var results:resultInfo = resultInfo()
    
    let connector: DBConnector = DBConnector()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getHistoryPropertyDetails()
    }
    
    func getHistoryPropertyDetails() {
        
        let params = ["propId":self.proptyID as Int]
        
        self.connector.getHistoryPropertiesData(params) { responseObj, error in
            
            self.historyDetailsArrays = responseObj as AnyObject!
            
            
            self.results.propertyType = (self.historyDetailsArrays.objectAt(0)).object(forKey: "house_type")! as! String
            
            self.results.purchaseType = (self.historyDetailsArrays.objectAt(0)).object(forKey: "purchase_status")! as! String
            
            self.results.price = (self.historyDetailsArrays.objectAt(0)).object(forKey: "price")! as! String
            
            self.results.rooms = (self.historyDetailsArrays.objectAt(0)).object(forKey: "rooms")! as! String
            
            self.results.baths = (self.historyDetailsArrays.objectAt(0)).object(forKey: "bathrooms")! as! String
            
            self.results.size = (self.historyDetailsArrays.objectAt(0)).object(forKey: "size")! as! String
            
            self.results.title = (self.historyDetailsArrays.objectAt(0)).object(forKey: "title")! as! String
            
            self.results.imagePath = (self.historyDetailsArrays.objectAt(0)).object(forKey: "image_location")! as! String
            
            self.results.furnish = (self.historyDetailsArrays.objectAt(0)).object(forKey: "furnish")! as! String
            
            self.results.descriptionss = (self.historyDetailsArrays.objectAt(0)).object(forKey: "description")! as! String
            
            self.results.address = (self.historyDetailsArrays.objectAt(0)).object(forKey: "address")! as! String
            
            let propPrice:Double = Double(self.results.price)!
            let propSize:Int = Int(self.results.size)!
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            
            let convertedSize:String = numberFormatter.string(from: NSNumber(value: propSize))!
            
            self.results.details = self.results.rooms + " Rooms" + "  " + self.results.baths + " Bathrooms" + "  " + convertedSize + "Sqft"

            self.lblPurchaseType.text = self.results.purchaseType
            self.propertyType.text = self.results.propertyType
            self.furnishStatus.text = self.results.furnish
            self.lblPrice.text = "NGN "+numberFormatter.string(from: NSNumber(value: propPrice))!
            self.lblPropDesc.text = self.results.descriptionss
            self.lblPropTitle.text = self.results.title
            self.lblDetails.text = self.results.details
            self.lblAddress.text = self.results.address
            
            let imageUrl:URL = URL(string: self.results.imagePath)!
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                let imageData:NSData = NSData(contentsOf: imageUrl)!
                
                DispatchQueue.main.async {
                    
                    let image = UIImage(data: imageData as Data)
                    self.propImage.image = image
                    
                }
                
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
