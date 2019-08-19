//
//  WebViewController.swift
//  DhallApp
//
//  Created by Aaron Brill on 8/15/19.
//  Copyright © 2019 Aaron Brill. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
  
    @IBOutlet var webView: WKWebView!
    
    var url = "https://www.skidmore.edu"
    var menuTitle = String()
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(url)
        guard let urlPage = URL(string: url) else {
            let alert = UIAlertController(title: "Error",
                                          message: "URL invalid",
                                          preferredStyle: .alert)
            present(alert, animated: true, completion:nil)
            return
        }
        webView.load(URLRequest(url: urlPage))
        
        webView.allowsBackForwardNavigationGestures = true
        self.title = menuTitle
        
    }
    
    
}
