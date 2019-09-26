//
//  DetailViewController.swift
//  Firebase Realtime Database
//
//  Created by Gianluca Caliendo on 25/09/2019.
//  Copyright © 2019 Gianluca Caliendo. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    
    //indirizzo della cella selezionata
    var webSite: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //carica detail1
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
        if let address = webSite,
            let webURL = URL(string: address) {
            let urlRequest = URLRequest(url: webURL)
            webView.load(urlRequest)
        }

    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

