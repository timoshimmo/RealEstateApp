//
//  RentViewController.swift
//  Kay RealEstate
//
//  Created by MacBook Pro on 30/09/2016.
//  Copyright © 2016 AJE AJE. All rights reserved.
//

import UIKit

class RentViewController: UIViewController, UIPickerViewDataSource, UITextFieldDelegate, UIPickerViewDelegate {
    
    @IBOutlet weak var txtMaxPrice: UILabel!
    @IBOutlet weak var rangePrice: UISlider!
    
    @IBOutlet weak var txtRooms: UILabel!
    @IBOutlet weak var rangeRooms: UISlider!
    
    @IBOutlet weak var txtPropertyType: UITextField!
    @IBOutlet weak var txtMaxSize: UILabel!
    
    @IBOutlet weak var rangeHouseSize: UISlider!
    
    var typePicker: UIPickerView!
    
    var typeDataSource = ["Any", "Apartment", "Detached Duplex", "Semi-Detached Duplex", "Terrace"];
    
    var PreferenceInfo: preferenceInfo = preferenceInfo()
    
    let connector: DBConnector = DBConnector()
    
    var rentArrays: AnyObject!
    
    var getMaxPrice:String!
    var getMaxSize:String!
    var getMaxRooms:String!
    var getPropertyType:String!


    override func viewDidLoad() {
        super.viewDidLoad()

        typePicker = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 150))
        typePicker.backgroundColor = UIColor.white
        
        typePicker.showsSelectionIndicator = true
        
        txtPropertyType.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        typePicker.delegate = self
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ForSaleViewController.donePicker(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ForSaleViewController.cancelPicker(_:)))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        txtPropertyType.inputView = typePicker
        txtPropertyType.inputAccessoryView = toolBar

        postRentRequest()
        
        
    }
    
    
    func postRentRequest() {
        
        let id: Int = 2 as Int
        
        let paramsss = ["preferenceId": id]
        
        connector.getPreferenceData(paramsss) { responseObj, error in
            
            self.rentArrays = responseObj as AnyObject!
            
            self.getMaxPrice = (self.rentArrays.object(at: 0) as AnyObject).object(forKey: "max_price") as! String
            self.getMaxSize = (self.rentArrays.object(at: 0) as AnyObject).object(forKey: "max_size") as! String
            self.getMaxRooms = (self.rentArrays.object(at: 0) as AnyObject).object(forKey: "max_rooms") as! String
            self.getPropertyType = (self.rentArrays.object(at: 0) as AnyObject).object(forKey: "house_type") as! String
            
            let maxPrice:Double = Double(self.getMaxPrice)!
            let maxSize:Int = Int(self.getMaxSize)!
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal

            
            self.txtMaxPrice.text = numberFormatter.string(from: NSNumber(value: maxPrice))
            self.txtMaxSize.text = numberFormatter.string(from: NSNumber(value: maxSize))
            self.txtRooms.text = String(self.getMaxRooms)
            self.txtPropertyType.text = String(self.getPropertyType)
            
            let price:Float = Float(self.getMaxPrice)!
            let rooms:Float = Float(self.getMaxRooms)!
            let sizes:Float = Float(self.getMaxSize)!
            let propertyType:String = String(self.getPropertyType)
            
            self.rangePrice.setValue(price, animated: true)
            self.rangeRooms.setValue(rooms, animated: true)
            self.rangeHouseSize.setValue(sizes, animated: true)
            self.txtPropertyType.text = propertyType
            
        }
        
    }
    
    
    @IBAction func btnSave(_ sender: AnyObject) {
        
        let size:Int = Int(txtMaxSize.text!)!
        let rooms:Int = Int(txtRooms.text!)!
        let price:Double = Double(txtMaxPrice.text!)!
        let id: Int = 2 as Int
        
        PreferenceInfo.id = id
        PreferenceInfo.size = size
        PreferenceInfo.roomsNo = rooms
        PreferenceInfo.price = price
        PreferenceInfo.houseType = txtPropertyType.text! as String
        
        let params = ["max_price": PreferenceInfo.price, "max_rooms": PreferenceInfo.roomsNo, "max_size": PreferenceInfo.size, "property_type": PreferenceInfo.houseType, "preferenceId": PreferenceInfo.id] as [String : Any]
        
        self.connector.editPreference(params as [String : AnyObject]) { responseObj, error in
            
            if let statusCode = responseObj?["status"]! as? Int {
                
                if (statusCode == 1) {
                    
                    let regAlert = UIAlertController(title: "Success", message: "Preference successfully updated!", preferredStyle: UIAlertControllerStyle.alert);
                    
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                    
                    regAlert.addAction(okAction);
                    
                    self.present(regAlert, animated: true, completion: nil);
                    
                    
                    //rangePrice.setValue(<#T##value: Float##Float#>, animated: <#T##Bool#>)
                    
                }
                    
                else {
                    let errAlert = UIAlertController(title: "Error", message: "Error updating preference", preferredStyle: UIAlertControllerStyle.alert);
                    
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil);
                    
                    errAlert.addAction(okAction);
                    
                    self.present(errAlert, animated: true, completion: nil);
                    
                }
                
                
            }
            
        }

    }
    
    
    func donePicker(_ sender: UIBarButtonItem) {
        txtPropertyType.resignFirstResponder()
        
    }
    
    func cancelPicker(_ sender: UIBarButtonItem) {
        
        txtPropertyType.resignFirstResponder()
        txtPropertyType.text = ""
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return typeDataSource.count
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        return self.typeDataSource[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        return txtPropertyType.text = self.typeDataSource[row]
        
    }
    
    
   
    @IBAction func priceSliderAction(_ sender: UISlider) {
        
        let step: Float = 100000
        
        let roundedValue = round(sender.value / step) * step
        
        sender.value = roundedValue

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        let currentPriceValue = Int(sender.value)
        txtMaxPrice.text = numberFormatter.string(from: NSNumber(value: currentPriceValue))
    }
    
    @IBAction func roomSlider(_ sender: UISlider) {
        
        let currentRoomsValue = Int(sender.value)
        txtRooms.text = "\(currentRoomsValue)"
    }
    
    @IBAction func sizeSlider(_ sender: UISlider) {
        
        let step: Float = 100
        
        let roundedValue = round(sender.value / step) * step
        
        sender.value = roundedValue
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal

        let currentSizeValue = Int(sender.value)
        txtMaxSize.text = numberFormatter.string(from: NSNumber(value: currentSizeValue))

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
