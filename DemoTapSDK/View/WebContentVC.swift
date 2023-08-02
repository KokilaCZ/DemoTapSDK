//
//  WebContentVC.swift
//  Terhal-Modon-IOS
//
//  Created by Kokila Ekanayake on 2022-10-21.
//

import UIKit
import WebKit

enum WebsiteType {
    case ANY(url: String)
}

class WebContentVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: Variables
    private var timeoutTimer: Timer?
    var website: WebsiteType = .ANY(url: "")
    
    // MARK: Life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        switch(website) {
        case .ANY(url: let url):
            if let url = URL(string: url) {
                webView.load(URLRequest(url: url))
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timeoutTimer?.invalidate()
        timeoutTimer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(self.didTimeoutRequest), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Actions
    @objc func didTimeoutRequest() {
        timeoutTimer?.invalidate()
    }
}

// MARK: - WKNavigationDelegate
extension WebContentVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        timeoutTimer?.invalidate()
        print("Did Finish")
        webView.evaluateJavaScript("String") { data, error in
            
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        timeoutTimer?.invalidate()
        print("Did Fail")
    }
}
