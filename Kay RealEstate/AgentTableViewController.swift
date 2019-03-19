//
//  AgentTableViewController.swift
//  Kay RealEstate
//
//  Created by MacBook Pro on 27/09/2016.
//  Copyright © 2016 AJE AJE. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Foundation

class AgentTableViewController: UITableViewController {
    
    var agentArrays: AnyObject!
    let agentData: agentsInfo = agentsInfo()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        postAgentsRequest()
        
        self.tableView.tableFooterView = UIView()
        tableView.sizeToFit()
        tableView.estimatedRowHeight = tableView.rowHeight

    }
    
    func postAgentsRequest() {
        
        
        Alamofire.request("http://macbooks-macbook-pro.local/webservices/other/getAgents.php",method: .post)
            
            .responseJSON { res in
                
                switch res.result {
                case .success(let list):
                    self.agentArrays = list as? [[String:AnyObject]] as AnyObject!
                    self.agentData.rowCount = self.agentArrays.count
                    self.tableView.reloadData()
                    print("Agents : \(list)")
                    
                case .failure(let error):
                    print("Error in response : \(error)")
                }
                
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
        return self.agentData.rowCount
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AgentRow", for: indexPath) as! AgentTableViewCell

        self.agentData.firstName = (self.agentArrays.object(at: indexPath.row) as AnyObject).object(forKey: "fname")! as! String
        self.agentData.lastName = (self.agentArrays.object(at: indexPath.row) as AnyObject).object(forKey: "lname")! as! String
        self.agentData.mobile = (self.agentArrays.object(at: indexPath.row) as AnyObject).object(forKey: "mobile")! as! String
       // self.agentData.rating = (self.agentArrays.object(at: indexPath.row) as AnyObject).object(forKey: "rating")! as! Double
        
        
        cell.agentName.text = self.agentData.firstName + " " + self.agentData.lastName
        cell.agentMobile.text = self.agentData.mobile
       // cell.agentRating.rating = self.agentData.rating

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowIndex = (tableView.indexPathForSelectedRow?.row)! as Int
        
        self.agentData.mobile = (self.agentArrays.object(at: rowIndex) as AnyObject).object(forKey: "mobile")! as! String
        
        let errAlert = UIAlertController(title: "Contact Agent", message: "Are you sure you want to contact our agent?", preferredStyle: UIAlertControllerStyle.alert);
        
        let CallActionHandler = { (action:UIAlertAction!) -> Void in
            
            if let url = URL(string:"tel://\(self.agentData.mobile)"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
            
        }
        
        let okAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: CallActionHandler);
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil);
        
        errAlert.addAction(okAction);
        errAlert.addAction(cancelAction);
        
        self.present(errAlert, animated: true, completion: nil);
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
