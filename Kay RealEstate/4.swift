//
//  SearchViewController.swift
//  Kay RealEstate
//
//  Created by MacBook Pro on 19/08/2016.
//  Copyright © 2016 AJE AJE. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UIPickerViewDataSource, UITextFieldDelegate, UIPickerViewDelegate {

    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var txtSort: UITextField!
    @IBOutlet var loadSearch: UIActivityIndicatorView!
    
    var locationPicker: UIPickerView!
    
    var locPickerDataSource = ["Any", "Abuja", "Calabar", "Ibadan", "Kaduna", "Lagos", "Port Harcourt"];
    var typeDataSource = ["For Sale", "Rent"];

    var loadProperties = false
    var countArray:Int!
    
    let connector: DBConnector = DBConnector()
    
    var PreferenceInfo: preferenceInfo = preferenceInfo()
    var propertiesArrays: AnyObject!
    var salesArrays: AnyObject!
    
    var getMaxPrice:String!
    var getMaxSize:String!
    var getMaxRooms:String!
    var getPropertyType:String!
    
    var prefArrays: AnyObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logDefaults = UserDefaults.standard
        logDefaults.set(true, forKey: "logged")
        logDefaults.synchronize()

        
        locationPicker = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 300))
        locationPicker.backgroundColor = UIColor.white
        
        locationPicker.showsSelectionIndicator = true
        
        txtLocation.delegate = self
        txtType.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        locationPicker.delegate = self
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SearchViewController.donePicker(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SearchViewController.cancelPicker(_:)))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        txtLocation.inputView = locationPicker
        txtLocation.inputAccessoryView = toolBar
        
        txtType.inputView = locationPicker
        txtType.inputAccessoryView = toolBar


        // Do any additional setup after loading the view.
    }
    
    func postSalesRequest() {
        
        let id: Int = 1 as Int
        
        let paramsss = ["preferenceId": id]
        
        connector.getPreferenceData(paramsss) { responseObj, error in
            
            self.prefArrays = responseObj as AnyObject!
            
            self.getMaxPrice = (self.prefArrays.object(at: 0) as AnyObject).object(forKey: "max_price") as! String
            self.getMaxSize = (self.prefArrays.object(at: 0) as AnyObject).object(forKey: "max_size") as! String
            self.getMaxRooms = (self.prefArrays.object(at: 0) as AnyObject).object(forKey: "max_rooms") as! String
            self.getPropertyType = (self.prefArrays.object(at: 0) as AnyObject).object(forKey: "house_type") as! String
            
            self.PreferenceInfo.houseType = self.getPropertyType
                
            let propertyType:String = String(self.getPropertyType)
            
            
            let location = self.txtLocation.text!
            let type = self.txtType.text!
            
            if(location == "Any") {
                
                if(propertyType == "Any") {
                    
                    let paramss = ["status": type, "price": self.getMaxPrice, "rooms": self.getMaxRooms, "size": self.getMaxSize] as [String : Any]

                    self.connector.getAllPropertiesPrefNoTypeData(paramss as [String : AnyObject]) { responseObj, error in
                        
                        self.propertiesArrays = responseObj as AnyObject!
                        self.countArray = responseObj?.count
                        
                        if(self.countArray < 1) {
                            let regAlert = UIAlertController(title: "Empty Result", message: "No data found for this search. Change the search input and try again!", preferredStyle: UIAlertControllerStyle.alert);
                            
                            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                            
                            regAlert.addAction(okAction);
                            
                            self.present(regAlert, animated: true, completion: nil);
                        }
                            
                        else {
                            
                            //  DispatchQueue.main.sync {
                            self.loadProperties = true
                            self.performSegue(withIdentifier: "searchSegues", sender: self)
                            // }
                            
                        }
                        
                        
                    }
                    
                    
                }
                    
                else {
                    
                    let paramssss = ["status": type, "price": self.getMaxPrice, "rooms": self.getMaxRooms, "size": self.getMaxSize, "house_type": self.getPropertyType] as [String : Any]
                    
                    self.connector.getAllPropertiesPrefData(paramssss as [String : AnyObject]) { responseObj, error in
                        
                        self.propertiesArrays = responseObj as AnyObject!
                        self.countArray = responseObj?.count
                        
                        if(self.countArray < 1) {
                            let regAlert = UIAlertController(title: "Empty Result", message: "No data found for this search. Change the search input and try again!", preferredStyle: UIAlertControllerStyle.alert);
                            
                            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                            
                            regAlert.addAction(okAction);
                            
                            self.present(regAlert, animated: true, completion: nil);
                        }
                            
                        else {
                            
                            //  DispatchQueue.main.sync {
                            self.loadProperties = true
                            self.performSegue(withIdentifier: "searchSegues", sender: self)
                            // }
                            
                        }
                        
                    }
                    
                }
                
            }
            
            else {
                
                
                if(propertyType == "Any") {
                    
                    let paramssss = ["status": type, "state": location, "price": self.getMaxPrice, "rooms": self.getMaxRooms, "size": self.getMaxSize] as [String : Any]
                    
                    
                    self.connector.getAllPropertiesPrefNoTypeData(paramssss as [String : AnyObject]) { responseObj, error in
                        
                        self.propertiesArrays = responseObj as AnyObject!
                        self.countArray = responseObj?.count
                        
                        if(self.countArray < 1) {
                            let regAlert = UIAlertController(title: "Empty Result", message: "No data found for this search. Change the search input and try again!", preferredStyle: UIAlertControllerStyle.alert);
                            
                            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                            
                            regAlert.addAction(okAction);
                            
                            self.present(regAlert, animated: true, completion: nil);
                        }
                            
                        else {
                            
                            //  DispatchQueue.main.sync {
                            self.loadProperties = true
                            self.performSegue(withIdentifier: "searchSegues", sender: self)
                            // }
                            
                        }
                        
                        
                    }
                    
                    
                }
                    
                else {
                    
                    let paramssss = ["status": type, "state": location, "price": self.getMaxPrice, "rooms": self.getMaxRooms, "size": self.getMaxSize, "house_type": self.getPropertyType] as [String : Any]
                    
                    
                    self.connector.getAllPropertiesPrefData(paramssss as [String : AnyObject]) { responseObj, error in
                        
                        self.propertiesArrays = responseObj as AnyObject!
                        self.countArray = responseObj?.count
                        
                        if(self.countArray < 1) {
                            let regAlert = UIAlertController(title: "Empty Result", message: "No data found for this search. Change the search input and try again!", preferredStyle: UIAlertControllerStyle.alert);
                            
                            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                            
                            regAlert.addAction(okAction);
                            
                            self.present(regAlert, animated: true, completion: nil);
                        }
                            
                        else {
                            
                            //  DispatchQueue.main.sync {
                            self.loadProperties = true
                            self.performSegue(withIdentifier: "searchSegues", sender: self)
                            // }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func postRentRequest() {
        
        let id: Int = 2 as Int
        
        let paramsss = ["preferenceId": id]
        
        loadSearch.startAnimating()
        
        connector.getPreferenceData(paramsss) { responseObj, error in
            
            self.prefArrays = responseObj as AnyObject!
            
            self.getMaxPrice = (self.prefArrays.object(at: 0) as AnyObject).object(forKey: "max_price") as! String
            self.getMaxSize = (self.prefArrays.object(at: 0) as AnyObject).object(forKey: "max_size") as! String
            self.getMaxRooms = (self.prefArrays.object(at: 0) as AnyObject).object(forKey: "max_rooms") as! String
            self.getPropertyType = (self.prefArrays.object(at: 0) as AnyObject).object(forKey: "house_type") as! String
            
            let propertyType:String = String(self.getPropertyType)
            
            let location = self.txtLocation.text!
            let type = self.txtType.text!
            
            if(location == "Any") {
                
                
                if(propertyType == "Any") {
                    
                    let paramssss = ["status": type, "price": self.getMaxPrice, "rooms": self.getMaxRooms, "size": self.getMaxSize] as [String : Any]
                    
                    self.connector.getAllPropertiesPrefNoTypeData(paramssss as [String : AnyObject]) { responseObj, error in
                        
                        self.propertiesArrays = responseObj as AnyObject!
                        self.countArray = responseObj?.count
                        
                        if(self.countArray < 1) {
                            let regAlert = UIAlertController(title: "Empty Result", message: "No data found for this search. Change the search input and try again!", preferredStyle: UIAlertControllerStyle.alert);
                            
                            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                            
                            regAlert.addAction(okAction);
                            
                            self.present(regAlert, animated: true, completion: nil);
                        }
                            
                        else {
                            
                            //  DispatchQueue.main.sync {
                            self.loadProperties = true
                            self.performSegue(withIdentifier: "searchSegues", sender: self)
                            // }
                            
                        }
                        
                    }
                    
                }
                    
                else {
                    
                   let paramssss = ["status": type, "price": self.getMaxPrice, "rooms": self.getMaxRooms, "size": self.getMaxSize, "house_type": self.getPropertyType] as [String : Any]
                    
                    self.connector.getAllPropertiesPrefData(paramssss as [String : AnyObject]) { responseObj, error in
                        
                        self.propertiesArrays = responseObj as AnyObject!
                        self.countArray = responseObj?.count
                        
                        if(self.countArray < 1) {
                            let regAlert = UIAlertController(title: "Empty Result", message: "No data found for this search. Change the search input and try again!", preferredStyle: UIAlertControllerStyle.alert);
                            
                            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                            
                            regAlert.addAction(okAction);
                            
                            self.present(regAlert, animated: true, completion: nil);
                        }
                            
                        else {
                            
                            //  DispatchQueue.main.sync {
                            self.loadProperties = true
                            self.performSegue(withIdentifier: "searchSegues", sender: self)
                            // }
                            
                        }
                        
                    }
                    
                }
                
                
            }
                
            else {
                
                
                if(propertyType == "Any") {
                    
                    
                    let paramssss = ["status": type, "state": location, "price": self.getMaxPrice, "rooms": self.getMaxRooms, "size": self.getMaxSize] as [String : Any]
                    
                    self.connector.getAllPropertiesPrefNoTypeData(paramssss as [String : AnyObject]) { responseObj, error in
                        
                        self.propertiesArrays = responseObj as AnyObject!
                        self.countArray = responseObj?.count
                        
                        if(self.countArray < 1) {
                            let regAlert = UIAlertController(title: "Empty Result", message: "No data found for this search. Change the search input and try again!", preferredStyle: UIAlertControllerStyle.alert);
                            
                            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                            
                            regAlert.addAction(okAction);
                            
                            self.present(regAlert, animated: true, completion: nil);
                        }
                            
                        else {
                            
                            //  DispatchQueue.main.sync {
                            self.loadProperties = true
                            self.performSegue(withIdentifier: "searchSegues", sender: self)
                            // }
                            
                        }
                        
                    }
                    
                }
                    
                else {
                    
                     let paramssss = ["status": type, "state": location, "price": self.getMaxPrice, "rooms": self.getMaxRooms, "size": self.getMaxSize, "house_type": self.getPropertyType] as [String : Any]
                    
                    
                    self.connector.getAllPropertiesPrefData(paramssss as [String : AnyObject]) { responseObj, error in
                        
                        self.propertiesArrays = responseObj as AnyObject!
                        self.countArray = responseObj?.count
                        
                        if(self.countArray < 1) {
                            let regAlert = UIAlertController(title: "Empty Result", message: "No data found for this search. Change the search input and try again!", preferredStyle: UIAlertControllerStyle.alert);
                            
                            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                            
                            regAlert.addAction(okAction);
                            
                            self.present(regAlert, animated: true, completion: nil);
                        }
                            
                        else {
                            
                            //  DispatchQueue.main.sync {
                            self.loadProperties = true
                            self.performSegue(withIdentifier: "searchSegues", sender: self)
                            // }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        loadSearch.stopAnimating()
    
    }


    func resign() {
        
        txtType.resignFirstResponder()
        
    }

    func donePicker(_ sender: UIBarButtonItem) {
         if(txtLocation.isEditing) {
            txtLocation.resignFirstResponder()
        }
        if(txtType.isEditing) {
            txtType.resignFirstResponder()
        }
        
        
    }

    func cancelPicker(_ sender: UIBarButtonItem) {
        
         if(txtLocation.isEditing) {
            txtLocation.resignFirstResponder()
            txtLocation.text = ""
        }
        
        if(txtType.isEditing) {
            txtType.resignFirstResponder()
            txtType.text = ""
        }
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(txtLocation.isEditing) {
            return locPickerDataSource.count
        }
        
        
        if(txtType.isEditing) {
            return typeDataSource.count
        }
        
        return 0
        
    }


    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        if(txtLocation.isEditing) {
            return self.locPickerDataSource[row]
        }
        
        if(txtType.isEditing) {
            return self.typeDataSource[row]
        }
        
        return nil
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(txtLocation.isEditing) {
            return txtLocation.text = self.locPickerDataSource[row]
        }
        
        if(txtType.isEditing) {
            return txtType.text = self.typeDataSource[row]
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if(identifier == "searchSegues") {
            
            let location = self.txtLocation.text!
            let type = self.txtType.text!
            
            
            if(location.isEmpty || type.isEmpty) {
                
                
                let regAlert = UIAlertController(title: "Empty Fields", message: "All fields are required", preferredStyle: UIAlertControllerStyle.alert);
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                
                regAlert.addAction(okAction);
                
                self.present(regAlert, animated: true, completion: nil);
                
            }
            
            else {
                
                if(!self.loadProperties) {
                    
                    
                        if(type == "For Sale") {
                            
                            postSalesRequest()
                            
                        }
                                
                        else {
                            
                            postRentRequest()
                            
                        }
                        
                    }
                
                }
            
            }
        
        return self.loadProperties
    }
    
    @IBAction func btnSearch(_ sender: AnyObject) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if(segue.identifier == "searchSegues") {
            
            let svc = segue.destination as! ResultTableViewController
            svc.searchResultsArray = self.propertiesArrays
            
        }
        
    }

    @IBAction func btnFilter(_ sender: AnyObject) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "FilterTabController") as! UITabBarController
        self.present(next, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


