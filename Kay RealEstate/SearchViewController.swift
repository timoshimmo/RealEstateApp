//
//  SearchViewController.swift
//  Kay RealEstate
//
//  Created by MacBook Pro on 19/08/2016.
//  Copyright © 2018 Tokmang Wang All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SearchViewController: UIViewController, UIPickerViewDataSource, UITextFieldDelegate, UIPickerViewDelegate {
    @IBOutlet weak var sgmtType: UISegmentedControl!
    
  //  @IBOutlet weak var txtLocation: UITextField!
  //  @IBOutlet weak var txtType: UITextField!
  //  @IBOutlet weak var txtSort: UITextField!
    @IBOutlet weak var searchFormView: UIStackView!
    
    @IBOutlet weak var btnFilter: UIButton!
    
    var txtLocation: SkyFloatingLabelTextFieldWithIcon!
    var txtType: SkyFloatingLabelTextFieldWithIcon!
    
    var locationPicker: UIPickerView!
    
    var locPickerDataSource = ["Any", "Abuja", "Lagos", "Port Harcourt"];
    var typeDataSource = ["Any", "Apartment", "Duplex", "Terrace", "Detached Bungalow", "Semi-Detached Bungalow", "Penthouse"];

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
    
    var sgmtPropType:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logDefaults = UserDefaults.standard
        logDefaults.set(true, forKey: "logged")
        logDefaults.synchronize()
        
        let tintColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        
        let blackColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        
        let darkGreyColor = UIColor(red: 31/255, green: 33/255, blue: 34/255, alpha: 1.0)
        
        txtLocation = SkyFloatingLabelTextFieldWithIcon(frame: CGRect.init(x: 0, y: 0, width: 310, height: 50), iconType: .image)
        
        txtLocation.placeholder = "Location"
        txtLocation.title = "State"
        txtLocation.tintColor = tintColor
        txtLocation.textColor = blackColor
        txtLocation.lineColor = darkGreyColor
        txtLocation.selectedTitleColor = tintColor
        txtLocation.selectedLineColor = tintColor
        
      //  txtLocation.iconFont = UIFont(name: "FontAwesome", size: 15)
        txtLocation.iconImage = UIImage(imageLiteralResourceName: "placeholder")
        txtLocation.lineHeight = 1.0
        txtLocation.selectedLineHeight = 1.5
        
        self.searchFormView.addSubview(txtLocation)
        
        txtType = SkyFloatingLabelTextFieldWithIcon(frame: CGRect.init(x: 0, y: 60, width: 310, height: 50), iconType: .image)
        
        txtType.placeholder = "Property Type"
        txtType.title = "Purchase Preference"
        txtType.tintColor = tintColor
        txtType.textColor = blackColor
        txtType.lineColor = darkGreyColor
        txtType.selectedTitleColor = tintColor
        txtType.selectedLineColor = tintColor
        
        txtType.iconImage = UIImage(imageLiteralResourceName: "property")
        txtType.lineHeight = 1.0
        txtType.selectedLineHeight = 1.5
        
        self.searchFormView.addSubview(txtType)
        
        locationPicker = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 220))
        locationPicker.backgroundColor = UIColor.white
        
        locationPicker.showsSelectionIndicator = true
        
        txtLocation.delegate = self
        txtType.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.barTintColor = UIColor(red: 255/255, green: 216/255, blue: 13/255, alpha: 1)
        toolBar.tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
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
    
    @IBAction func btnSgmtType(_ sender: Any) {
        
        switch sgmtType.selectedSegmentIndex {
            
        case 0:
            sgmtPropType = "For Sale";
            
        case 1:
            sgmtPropType = "Rent";
            
        default:
            break;
        }
        
        
        
    }
    
    func searchRequest() {
        
        /*let id: Int = 1 as Int
        
        let prefParams = ["preferenceId": id as Int]
        
        connector.getPreferenceData(prefParams) { responseObj, error in
            
            self.salesArrays = responseObj as AnyObject!
            
            self.getMaxPrice = (self.salesArrays.object(at: 0) as AnyObject).object(forKey: "max_price") as! String
            self.getMaxSize = (self.salesArrays.object(at: 0) as AnyObject).object(forKey: "max_size") as! String
            self.getMaxRooms = (self.salesArrays.object(at: 0) as AnyObject).object(forKey: "max_rooms") as! String
            self.getPropertyType = (self.salesArrays.object(at: 0) as AnyObject).object(forKey: "house_type") as! String
            
            let location = self.txtLocation.text!
            let type = self.txtType.text!
            
            let property_type: String = self.getPropertyType
            
            if(location == "Any") {
                
                
                if(property_type == "Any") {
                    
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
                    
                     let paramss = ["status": type, "price": self.getMaxPrice, "rooms": self.getMaxRooms, "size": self.getMaxSize, "house_type": self.getPropertyType] as [String : Any]
                    
                    self.connector.getAllPropertiesPrefData(paramss as [String : AnyObject]) { responseObj, error in
                        
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
                
                if(property_type == "Any") {
                    
                    
                    let paramssss = ["status": type as AnyObject, "state": location as AnyObject, "price": self.getMaxPrice as AnyObject, "rooms": self.getMaxRooms as AnyObject, "size": self.getMaxSize as AnyObject] as [String : AnyObject]
                    
                    
                    self.connector.getPropertiesWithPrefNoType(paramssss as [String: AnyObject]) { responseObj, error in
                        
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
                    
                    let paramssss = ["status": type as AnyObject, "state": location as AnyObject, "price": self.getMaxPrice as AnyObject, "rooms": self.getMaxRooms as AnyObject, "size": self.getMaxSize as AnyObject, "house_type": self.getPropertyType as AnyObject] as [String : AnyObject]
                    
                    
                    self.connector.getPropertiesWithPref(paramssss as [String: AnyObject]) { responseObj, error in
                        
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
            
        }*/
        
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
            
            
            let location = txtLocation.text!
            let type = txtType.text!
            
            
            if(location.isEmpty || type.isEmpty) {
                
                
                let regAlert = UIAlertController(title: "Empty Fields", message: "All fields are required", preferredStyle: UIAlertControllerStyle.alert);
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                
                regAlert.addAction(okAction);
                
                self.present(regAlert, animated: true, completion: nil);
            }
            
            else {
            
                
                if(!self.loadProperties) {
                    
                //    if(type == "For Sale") {
                        
                      //  let prefId:Int = 1 as Int
                        searchRequest()
                    
                 //   }
                    
                //    else {
                        
                      //  let prefId:Int = 2 as Int
                    //    searchRequest(id: prefId)
                        
                //    }
                    
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


