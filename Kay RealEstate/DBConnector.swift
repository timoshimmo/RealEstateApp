//
//  DBConnector.swift
//  Kay RealEstate
//
//  Created by MacBook Pro on 25/06/2016.
//  Copyright © 2016 AJE AJE. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DBConnector: NSObject {
    
    func newUserPostRequest(_ urlString: String, params: [String:String], completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        
        Alamofire.request(urlString, method: .post, parameters: params)
            
            .responseJSON { res in
                
                print("Response Result Value: \(String(describing: res.result))")
                
                switch res.result {
                case .success(let dfr):
                    completionHandler(dfr as? NSDictionary, nil)
                    print("Add User Data: \(dfr)")
                case .failure(let err):
                    completionHandler(nil, err as NSError?)
                    print("Failure Error: \(err)")
                    
                }
            }
        
        }
    //http://macbooks-macbook-pro.local/webservices/other/newUser.php
    func addNewUser(_ parameterss: [String:String], completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        print("Request Parameters: \(parameterss)")
        
        self.newUserPostRequest("http://localhost/webservices/adduser.php", params: parameterss, completionHandler: completionHandler)
        
    }
    
    func validatePostRequest(_ urlString: String, params: [String:String], completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        
        Alamofire.request(urlString, method: .post , parameters: params)
            .responseJSON { res in
                
                print("Response Result Value: \(String(describing: res.result))")
                
                switch res.result {
                case .success(let dfr):
                    completionHandler(dfr as? NSDictionary, nil)
                    print("\(dfr)")
                case .failure(let err):
                    completionHandler(nil, err as NSError?)
                    
                }
        }
        
    }
    
    func validateUser(_ parameterss: [String:String], completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        self.validatePostRequest("http://localhost/webservices/getuser.php", params: parameterss, completionHandler: completionHandler)
        
    }
    
    func postAgentsRequest(_ urlString: String, completionHandler: @escaping ([[String:AnyObject]]?, NSError?) -> ()) {
        
        
        Alamofire.request(urlString, method: .post)
            
            .responseJSON { res in
                
                switch res.result {
                case .success(let list):
                    completionHandler(list as? [[String:AnyObject]], nil)
                    
                case .failure(let error):
                    completionHandler(nil, error as NSError?)
                }
                
        }
        
    }
    
    func agents(_ completionHandler: @escaping ([[String:AnyObject]]?, NSError?) -> ()) {
        
        self.postAgentsRequest("http://macbooks-macbook-pro.local/webservices/other/getAgents.php", completionHandler: completionHandler)
        
    }

    
    func editUsersNamesRequest(_ urlString: String, params: [String:AnyObject], completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        
        Alamofire.request(urlString, method: .post, parameters: params)
            
            .responseJSON { res in
                switch res.result {
                case .success(let dfr):
                    completionHandler(dfr as? NSDictionary, nil)
                    print("\(dfr)")
                case .failure(let err):
                    completionHandler([:], err as NSError?)
                    
                }
        }
        
    }
    
    func editUsersNames(_ parameterss: [String:AnyObject], completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        self.editUsersNamesRequest("http://macbooks-macbook-pro.local/webservices/other/editName.php", params: parameterss, completionHandler: completionHandler)
        
    }
    
    func editUsersEmailRequest(_ urlString: String, params: [String:AnyObject], completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        
        Alamofire.request(urlString, method: .post, parameters: params)
            
            .responseJSON { res in
                switch res.result {
                case .success(let dfr):
                    completionHandler(dfr as? NSDictionary, nil)
                    print("\(dfr)")
                case .failure(let err):
                    completionHandler([:], err as NSError?)
                    
                }
        }
        
    }
    
    func editUsersEmail(_ parameterss: [String:AnyObject], completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        self.editUsersEmailRequest("http://macbooks-macbook-pro.local/webservices/other/editEmail.php", params: parameterss, completionHandler: completionHandler)
        
    }
    
    func editUsersMobileRequest(_ urlString: String, params: [String:AnyObject], completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        
        Alamofire.request(urlString, method: .post, parameters: params)
            
            .responseJSON { res in
                switch res.result {
                case .success(let dfr):
                    completionHandler(dfr as? NSDictionary, nil)
                    print("\(dfr)")
                case .failure(let err):
                    completionHandler([:], err as NSError?)
                    
                }
        }
        
    }
    
    func editUsersMobile(_ parameterss: [String:AnyObject], completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        self.editUsersMobileRequest("http://macbooks-macbook-pro.local/webservices/other/editMobile.php", params: parameterss, completionHandler: completionHandler)
        
    }
    
    func editUsersPassRequest(_ urlString: String, params: [String:AnyObject], completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        
        Alamofire.request(urlString, method: .post, parameters: params)
            
            .responseJSON { res in
                switch res.result {
                case .success(let dfr):
                    completionHandler(dfr as? NSDictionary, nil)
                    print("\(dfr)")
                case .failure(let err):
                    completionHandler([:], err as NSError?)
                    
                }
        }
        
    }
    
    func editUsersPassword(_ parameterss: [String:AnyObject], completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        self.editUsersPassRequest("http://macbooks-macbook-pro.local/webservices/other/editPassword.php", params: parameterss, completionHandler: completionHandler)
        
    }
    

    func postgetUsersRequest(_ urlString: String, params: [String:Int], completionHandler: @escaping ([[String: AnyObject]]?, NSError?) -> ()) {
        
        Alamofire.request(urlString, method: .post, parameters: params)
            
            .responseJSON { res in
                switch res.result {
                case .success(let dfr):
                    completionHandler(dfr as? [[String:AnyObject]], nil)
                    print("Data \(dfr)")
                case .failure(let err):
                    completionHandler(nil, err as NSError?)
                    
                }
                
        }
        
    }
    
    func getUserData(_ parameterss: [String:Int], completionHandler: @escaping ([[String: AnyObject]]?, NSError?) -> ()) {
        
        self.postgetUsersRequest("http://macbooks-macbook-pro.local/webservices/other/getUserDetails.php", params: parameterss,completionHandler: completionHandler)
        
    }
    
    func postgetAllPropertiesRequest(_ urlString: String, params: [String:String], completionHandler: @escaping ([[String: AnyObject]]?, NSError?) -> ()) {
        
        Alamofire.request(urlString, method: .post, parameters: params)
            
            .responseJSON { res in
                switch res.result {
                case .success(let dfr):
                    completionHandler(dfr as? [[String:AnyObject]], nil)
                    print("Properties \(dfr)")
                case .failure(let err):
                    completionHandler(nil, err as NSError?)
                    
                }
                
        }
        
    }
    
    func getPropertiesData(_ parameterss: [String:String],completionHandler: @escaping ([[String: AnyObject]]?, NSError?) -> ()) {
        
        self.postgetAllPropertiesRequest("http://macbooks-macbook-pro.local/webservices/other/getAllProperties.php", params: parameterss, completionHandler: completionHandler)
        
    }
    
    
    func postgetLocationPropertiesRequest(_ urlString: String, params: [String:String], completionHandler: @escaping ([[String: AnyObject]]?, NSError?) -> ()) {
        
        Alamofire.request(urlString, method: .post, parameters: params)
            
            .responseJSON { res in
                switch res.result {
                case .success(let dfr):
                    completionHandler(dfr as? [[String:AnyObject]], nil)
                    print("Properties \(dfr)")
                case .failure(let err):
                    completionHandler(nil, err as NSError?)
                    
                }
                
        }
        
    }
    
    func getPropertiesLocationData(_ parameterss: [String:String],completionHandler: @escaping ([[String: AnyObject]]?, NSError?) -> ()) {
        
        self.postgetLocationPropertiesRequest("http://macbooks-macbook-pro.local/webservices/other/getPropertiesWithLocationStatus.php", params: parameterss, completionHandler: completionHandler)
        
    }

    
    
    func newEnquiryPostRequest(_ urlString: String, params: [String:AnyObject], completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        
        Alamofire.request(urlString, method: .post, parameters: params)
            
            .responseJSON { res in
                switch res.result {
                case .success(let dfr):
                    completionHandler(dfr as? NSDictionary, nil)
                    print("\(dfr)")
                case .failure(let err):
                    completionHandler(nil, err as NSError?)
                    
                }
        }
        
    }
    
    func addNewEnquiry(_ parameterss: [String:AnyObject], completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        self.newEnquiryPostRequest("http://macbooks-macbook-pro.local/webservices/other/newPropertyEnquiry.php", params: parameterss, completionHandler: completionHandler)
        
    }
    
    func validateEnquiryPostRequest(_ urlString: String, params: [String:Int], completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        
        Alamofire.request(urlString, method: .post , parameters: params)
            
            .responseJSON { res in
                switch res.result {
                case .success(let dfr):
                    completionHandler(dfr as? NSDictionary, nil)
                    print("\(dfr)")
                case .failure(let err):
                    completionHandler(nil, err as NSError?)
                    
                }
        }
        
    }
    
    func validateEnquiry(_ parameterss: [String:Int], completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        self.validateEnquiryPostRequest("http://macbooks-macbook-pro.local/webservices/other/checkPropertyEnquired.php", params: parameterss, completionHandler: completionHandler)
        
    }
    
    
    func postgetPropertiesWithPrefRequest(_ urlString: String, params: [String:AnyObject], completionHandler: @escaping ([[String: AnyObject]]?, NSError?) -> ()) {
        
        Alamofire.request(urlString, method: .post, parameters: params)
            
            .responseJSON { res in
                switch res.result {
                case .success(let dfr):
                    completionHandler(dfr as? [[String:AnyObject]], nil)
                    print("Properties \(dfr)")
                case .failure(let err):
                    completionHandler(nil, err as NSError?)
                    
                }
                
        }
        
    }
    
    
    func getPropertiesWithPref(_ parameterss: [String:AnyObject],completionHandler: @escaping ([[String: AnyObject]]?, NSError?) -> ()) {
        
        self.postgetPropertiesWithPrefRequest("http://macbooks-macbook-pro.local/webservices/other/getPropertiesWithPref.php", params: parameterss, completionHandler: completionHandler)
        
    }
    
    
    func postgetAllPropertiesPrefRequest(_ urlString: String, params: [String:AnyObject], completionHandler: @escaping ([[String: AnyObject]]?, NSError?) -> ()) {
        
        Alamofire.request(urlString, method: .post, parameters: params)
            
            .responseJSON { res in
                switch res.result {
                case .success(let dfr):
                    completionHandler(dfr as? [[String:AnyObject]], nil)
                    print("Properties \(dfr)")
                case .failure(let err):
                    completionHandler(nil, err as NSError?)
                    
                }
                
        }
        
    }
    
    func getAllPropertiesPrefData(_ parameterss: [String:AnyObject],completionHandler: @escaping ([[String: AnyObject]]?, NSError?) -> ()) {
        
        self.postgetAllPropertiesPrefRequest("http://macbooks-macbook-pro.local/webservices/other/getAllPropertiesWithPref.php", params: parameterss, completionHandler: completionHandler)
        
    }
    
    
    func postgetAllPropertiesPrefNoTypeRequest(_ urlString: String, params: [String:AnyObject], completionHandler: @escaping ([[String: AnyObject]]?, NSError?) -> ()) {
        
        Alamofire.request(urlString, method: .post, parameters: params)
            
            .responseJSON { res in
                switch res.result {
                case .success(let dfr):
                    completionHandler(dfr as? [[String:AnyObject]], nil)
                    print("Properties \(dfr)")
                case .failure(let err):
                    completionHandler(nil, err as NSError?)
                    
                }
                
        }
        
    }
    
    func getAllPropertiesPrefNoTypeData(_ parameterss: [String:AnyObject],completionHandler: @escaping ([[String: AnyObject]]?, NSError?) -> ()) {
        
        self.postgetAllPropertiesPrefNoTypeRequest("http://macbooks-macbook-pro.local/webservices/other/getAllPropertiesWithPrefNoType.php", params: parameterss, completionHandler: completionHandler)
        
    }
    
    func postgetPropertiesWithPrefNoTypeRequest(_ urlString: String, params: [String:AnyObject], completionHandler: @escaping ([[String: AnyObject]]?, NSError?) -> ()) {
        
        Alamofire.request(urlString, method: .post, parameters: params)
            
            .responseJSON { res in
                switch res.result {
                case .success(let dfr):
                    completionHandler(dfr as? [[String:AnyObject]], nil)
                    print("Properties \(dfr)")
                case .failure(let err):
                    completionHandler(nil, err as NSError?)
                    
                }
                
        }
        
    }
    
    
    func getPropertiesWithPrefNoType(_ parameterss: [String:AnyObject],completionHandler: @escaping ([[String: AnyObject]]?, NSError?) -> ()) {
        
        self.postgetPropertiesWithPrefNoTypeRequest("http://macbooks-macbook-pro.local/webservices/other/getPropertiesWithPrefNoType.php", params: parameterss, completionHandler: completionHandler)
        
    }
    
    func editPreferenceRequest(_ urlString: String, params: [String:AnyObject], completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        
        Alamofire.request(urlString, method: .post, parameters: params)
            
            .responseJSON { res in
                switch res.result {
                case .success(let dfr):
                    completionHandler(dfr as? NSDictionary, nil)
                    print("\(dfr)")
                case .failure(let err):
                    completionHandler([:], err as NSError?)
                    
                }
        }
        
    }
    
    func editPreference(_ parameterss: [String:AnyObject], completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        self.editPreferenceRequest("http://macbooks-macbook-pro.local/webservices/other/editPreferences.php", params: parameterss, completionHandler: completionHandler)
        
    }
    
    func postgetPreferenceRequest(_ urlString: String, params: [String:Int], completionHandler: @escaping ([[String: AnyObject]]?, NSError?) -> ()) {
        
        Alamofire.request(urlString, method: .post, parameters: params)
            
            .responseJSON { res in
                switch res.result {
                case .success(let dfr):
                    completionHandler(dfr as? [[String:AnyObject]], nil)
                    print("Properties \(dfr)")
                case .failure(let err):
                    completionHandler(nil, err as NSError?)
                    
                }
                
        }
        
    }
    
    func getPreferenceData(_ parameterss: [String:Int],completionHandler: @escaping ([[String: AnyObject]]?, NSError?) -> ()) {
        
        self.postgetPreferenceRequest("http://macbooks-macbook-pro.local/webservices/other/getPreferences.php", params: parameterss, completionHandler: completionHandler)
        
    }
    
    func postHistoryRequest(_ urlString: String, params: [String:Int], completionHandler: @escaping ([[String: AnyObject]]?, NSError?) -> ()) {
        
        Alamofire.request(urlString, method: .post, parameters: params)
            
            .responseJSON { res in
                switch res.result {
                case .success(let dfr):
                    completionHandler(dfr as? [[String:AnyObject]], nil)
                    print("Data \(dfr)")
                case .failure(let err):
                    completionHandler(nil, err as NSError?)
                    
                }
                
        }
        
    }
    
    func getHistoryData(_ parameterss: [String:Int], completionHandler: @escaping ([[String: AnyObject]]?, NSError?) -> ()) {
        
        self.postHistoryRequest("http://macbooks-macbook-pro.local/webservices/other/getEnquiry.php", params: parameterss,completionHandler: completionHandler)
        
    }
    
    func postgetHistoryPropertiesRequest(_ urlString: String, params: [String:Int], completionHandler: @escaping ([[String: AnyObject]]?, NSError?) -> ()) {
        
        Alamofire.request(urlString, method: .post, parameters: params)
            
            .responseJSON { res in
                switch res.result {
                case .success(let dfr):
                    completionHandler(dfr as? [[String:AnyObject]], nil)
                    print("Properties \(dfr)")
                case .failure(let err):
                    completionHandler(nil, err as NSError?)
                    
                }
                
        }
        
    }
    
    func getHistoryPropertiesData(_ parameterss: [String:Int],completionHandler: @escaping ([[String: AnyObject]]?, NSError?) -> ()) {
        
        self.postgetHistoryPropertiesRequest("http://macbooks-macbook-pro.local/webservices/other/getHistoryProperties.php", params: parameterss, completionHandler: completionHandler)
        
    }




}
