//
//  ResultTableViewController.swift
//  Kay RealEstate
//
//  Created by MacBook Pro on 02/10/2016.
//  Copyright © 2016 AJE AJE. All rights reserved.
//

import UIKit

class ResultTableViewController: UITableViewController {
    
    
    @IBOutlet weak var numResults: UILabel!
    
    var results:resultInfo = resultInfo()
    var searchResultsArray : AnyObject!
    
    var titles: String!
    var purchaseType: String!
    var propertyType: String!
    var furnishStatus: String!
    var price: String!
    var imageName: String!
    var descriptions: String!
    var details: String!
    var address: String!
    var pID: Int!
    
    var slideImage1: String!
    var slideImage2: String!
    var slideImage3: String!
    var slideImage4: String!
    
    var imageArray: [Int: String] = [:]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        tableView.sizeToFit()
        tableView.estimatedRowHeight = tableView.rowHeight
        
        numResults.text = String(searchResultsArray.count) + " " + "Results"
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResultsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultRow", for: indexPath) as! ResultTableViewCell

        self.results.propertyType = (self.searchResultsArray.objectAt((indexPath as NSIndexPath).row) as AnyObject).object(forKey: "house_type")! as! String
        
        self.results.purchaseType = (self.searchResultsArray.objectAt((indexPath as NSIndexPath).row) as AnyObject).object(forKey: "purchase_status")! as! String
        
        self.results.price = (self.searchResultsArray.objectAt((indexPath as NSIndexPath).row) as AnyObject).object(forKey: "price")! as! String
        
        self.results.rooms = (self.searchResultsArray.objectAt((indexPath as NSIndexPath).row) as AnyObject).object(forKey: "rooms")! as! String
        
        self.results.baths = (self.searchResultsArray.objectAt((indexPath as NSIndexPath).row) as AnyObject).object(forKey: "bathrooms")! as! String
        
        self.results.size = (self.searchResultsArray.objectAt((indexPath as NSIndexPath).row) as AnyObject).object(forKey: "size")! as! String
        
        self.results.title = (self.searchResultsArray.objectAt((indexPath as NSIndexPath).row) as AnyObject).object(forKey: "title")! as! String
        
        self.results.imagePath = (self.searchResultsArray.objectAt((indexPath as NSIndexPath).row) as AnyObject).object(forKey: "image_location")! as! String
        
        self.results.furnish = (self.searchResultsArray.objectAt((indexPath as NSIndexPath).row) as AnyObject).object(forKey: "furnish")! as! String
        
         self.results.descriptionss = (self.searchResultsArray.objectAt((indexPath as NSIndexPath).row) as AnyObject).object(forKey: "description")! as! String
        
         self.results.address = (self.searchResultsArray.objectAt((indexPath as NSIndexPath).row) as AnyObject).object(forKey: "address")! as! String
        
        let propPrice:Double = Double(results.price)!
        let propSize:Int = Int(results.size)!
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        let convertedSize:String = numberFormatter.string(from: NSNumber(value: propSize))!

        self.results.details = results.rooms + " Rooms" + "  " + results.baths + " Bathrooms" + "  " + convertedSize + "Sqft"

        
        cell.HouseTypes.text = results.propertyType
        cell.PurchaseType.text = results.purchaseType
        cell.housePrice.text = "NGN "+numberFormatter.string(from: NSNumber(value: propPrice))!
        cell.propertyDetails.text = results.details
        cell.lblTitle.text = results.title
        
        let imageUrl:URL = URL(string: self.results.imagePath)!
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let imageData:NSData = NSData(contentsOf: imageUrl)!
            
              DispatchQueue.main.async {
                
                let image = UIImage(data: imageData as Data)
                cell.propertyImage.image = image
                
            }
            
        }
        
        
     /*   if((indexPath as NSIndexPath).row == 0) {
            
            self.results.imagePath = "large_deluxe_Villa2"
            cell.propertyImage.image = UIImage(named: self.results.imagePath)
            
            
        }
        
        if((indexPath as NSIndexPath).row == 1) {
            self.results.imagePath = "main-abj"
            cell.propertyImage.image = UIImage(named: self.results.imagePath)
            
        }
        
        if((indexPath as NSIndexPath).row == 2) {
            self.results.imagePath = "mainkd"
            cell.propertyImage.image = UIImage(named: self.results.imagePath)
            
        }
        
        if((indexPath as NSIndexPath).row == 3) {
            self.results.imagePath = "mainph"
            cell.propertyImage.image = UIImage(named: self.results.imagePath)
            
        } */
        
       
        
        
       /* if let filePath = Bundle.main.path(forResource: results.imagePath, ofType: "jpg"), let imagesss = UIImage(contentsOfFile: filePath) {
            
            cell.propertyImage.contentMode = .scaleAspectFit
            cell.propertyImage.image = imagesss
        } */

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.performSegue(withIdentifier: "detailsSegue", sender: self)

    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "detailsSegue") {
            
            let dvc = segue.destination as! DetailsViewController
            let rowIndex = (tableView.indexPathForSelectedRow?.row)! as Int
            
            titles = (self.searchResultsArray.objectAt(rowIndex) as AnyObject).object(forKey: "title")! as! String
            
            purchaseType = (self.searchResultsArray.objectAt(rowIndex) as AnyObject).object(forKey: "purchase_status")! as! String
            
            propertyType = (self.searchResultsArray.objectAt(rowIndex) as AnyObject).object(forKey: "house_type")! as! String
            
            furnishStatus = (self.searchResultsArray.objectAt(rowIndex) as AnyObject).object(forKey: "furnish")! as! String
            
            price = (self.searchResultsArray.objectAt(rowIndex) as AnyObject).object(forKey: "price")! as! String
            
            imageName = (self.searchResultsArray.objectAt(rowIndex) as AnyObject).object(forKey: "image_location")! as! String
            
            slideImage1 = (self.searchResultsArray.objectAt(rowIndex) as AnyObject).object(forKey: "swipe_image1")! as! String
            
            slideImage2 = (self.searchResultsArray.objectAt(rowIndex) as AnyObject).object(forKey: "swipe_image2")! as! String
            
            slideImage3 = (self.searchResultsArray.objectAt(rowIndex) as AnyObject).object(forKey: "swipe_image3")! as! String
            
            slideImage4 = (self.searchResultsArray.objectAt(rowIndex) as AnyObject).object(forKey: "swipe_image4")! as! String

            
            descriptions = (self.searchResultsArray.objectAt(rowIndex) as AnyObject).object(forKey: "description")! as! String
            
            address = (self.searchResultsArray.objectAt(rowIndex) as AnyObject).object(forKey: "address")! as! String
            
            let getID: String = (self.searchResultsArray.objectAt(rowIndex) as AnyObject).object(forKey: "_id")! as! String
            
            let convertID:Int = Int(getID)!
            pID = convertID
            
            let rooms:String = (self.searchResultsArray.objectAt(rowIndex) as AnyObject).object(forKey: "rooms")! as! String
            
            let baths:String = (self.searchResultsArray.objectAt(rowIndex) as AnyObject).object(forKey: "bathrooms")! as! String
            
            let size: String = (self.searchResultsArray.objectAt(rowIndex) as AnyObject).object(forKey: "size")! as! String
            
            let propSize:Int = Int(size)!
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            
            let convertedPropSize:String = numberFormatter.string(from: NSNumber(value: propSize))!
            
            details = rooms + " Rooms" + "  " + baths + " Bathrooms" + "  " + convertedPropSize + "Sqft"
            
            dvc.dtimageName = imageName
            dvc.dttitles = titles
            dvc.dtpurchaseType = purchaseType
            dvc.dtpropertyType = propertyType
            dvc.dtdescriptions = descriptions
            dvc.dtdetails = details
            dvc.dtprice = price
            dvc.dtfurnishStatus = furnishStatus
            dvc.dtAddress = address
            dvc.dtID = pID
            dvc.dtSwImg1 = slideImage1
            dvc.dtSwImg2 = slideImage2
            dvc.dtSwImg3 = slideImage3
            dvc.dtSwImg4 = slideImage4
            
            
        }
    
    
    }
    


}
