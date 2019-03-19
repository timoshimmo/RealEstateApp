//
//  PanoramaViewController.swift
//  Kay RealEstate
//
//  Created by MacBook Pro on 04/11/2016.
//  Copyright © 2016 AJE AJE. All rights reserved.
//

import UIKit

class PanoramaViewController: UIViewController {

    
    @IBOutlet weak var panoramicDisplay: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        let url = NSURL (string: "http://www.easypano.com/gallery/Tourweaver/780/html5/Real-Estate-Virtual-Tour/index.html");
        let requestObj = NSURLRequest(url: url! as URL);
        panoramicDisplay.loadRequest(requestObj as URLRequest);
        
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
