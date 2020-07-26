//
//  IMDBWebViewVC.swift
//  MovieAppEnq
//
//  Created by Birbay on 26.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import UIKit
import WebKit

class IMDBWebViewVC: BaseViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var imdbID: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: "https://www.imdb.com/title/\(String(describing: imdbID))") {
            webView.load(URLRequest(url: url))
        }
            
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: - to bring navBar back if transparentNavBar run
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: ""), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "")
    }
    
}
