//
//  HistoryTableViewController.swift
//  Kay RealEstate
//
//  Created by MacBook Pro on 28/10/2016.
//  Copyright © 2016 AJE AJE. All rights reserved.
//

import UIKit
import Foundation

class HistoryTableViewController: UITableViewController {
    
    var historyArrays: AnyObject!
    let enquiryData: enquiryInfo = enquiryInfo()

    let connector: DBConnector = DBConnector()
    var userID: Int = 0
    
    var pID: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getHistory()

        self.tableView.tableFooterView = UIView()
        tableView.sizeToFit()
        tableView.estimatedRowHeight = 75
        
    }
    
    func getHistory() {
        
        let sessionID: AnyObject
        sessionID = UserDefaults.standard.value(forKey: "sessionId")! as AnyObject
        
        // loggedUser = UserDefaults.standard.object(forKey: "sessionUser")! as AnyObject
        userID = Int(sessionID as! String)!
        
        let params = ["userId":self.userID as Int]
        
        self.connector.getHistoryData(params) { responseObj, error in
            
            self.historyArrays = responseObj as AnyObject!
            
            self.enquiryData.rowCount = self.historyArrays.count
            self.tableView.reloadData()
            
            
        }
        
        
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
        return self.enquiryData.rowCount
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryRow", for: indexPath) as! HistoryTableViewCell
        
        self.enquiryData.title = (self.historyArrays.object(at: indexPath.row) as AnyObject).object(forKey: "property_title")! as! String
        
        self.enquiryData.location = (self.historyArrays.object(at: indexPath.row) as AnyObject).object(forKey: "property_location")! as! String
        
        self.enquiryData.getPrice = (self.historyArrays.object(at: indexPath.row) as AnyObject).object(forKey: "property_price")! as! String
        
        self.enquiryData.dateEnquired = (self.historyArrays.object(at: indexPath.row) as AnyObject).object(forKey: "date_requested")! as! String
        
        self.enquiryData.purchaseType = (self.historyArrays.object(at: indexPath.row) as AnyObject).object(forKey: "purchase_type")! as! String
        
        let propPrice:Double = Double(self.enquiryData.getPrice)!
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        cell.lblTitle.text = self.enquiryData.title
        cell.lblPrice.text = "NGN "+numberFormatter.string(from: NSNumber(value: propPrice))!
        cell.lblDate.text = self.enquiryData.dateEnquired
        cell.lblAddress.text = self.enquiryData.location
        cell.lblPurchaseType.text = self.enquiryData.purchaseType


        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "historySegue", sender: self)
        
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

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "historySegue") {
            
            let hdvc = segue.destination as! HistoryDetailsViewController
            let rowIndex = (tableView.indexPathForSelectedRow?.row)! as Int
            
            let getID: String = (self.historyArrays.objectAt(rowIndex) as AnyObject).object(forKey: "propertyID")! as! String
            
            let convertID:Int = Int(getID)!
            pID = convertID
            
            hdvc.proptyID = pID
            
            
        }
        
    }
    

}
