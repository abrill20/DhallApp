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
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(url)
        let urlPage = URL(string: url)!
        webView.load(URLRequest(url: urlPage))
        
        webView.allowsBackForwardNavigationGestures = true
        
    }
    
    
}
