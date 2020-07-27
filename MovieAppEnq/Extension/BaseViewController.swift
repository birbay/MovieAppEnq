//
//  BaseViewController.swift
//  MovieAppEnq
//
//  Created by Birbay on 25.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - refreshControl
    lazy var refreshControl: UIRefreshControl? = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshHandle), for: UIControl.Event.valueChanged)
        return control
    }()
    
    // MARK: - tableView
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .singleLine
        tv.clipsToBounds = true
        tv.keyboardDismissMode = .onDrag
        return tv
    }()
    
    // MARK: - setLoading
    lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.color = UIColor.label
        indicatorView.startAnimating()
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()
    
    // MARK: - lottieView
//    var animationView: AnimationView?
    
//    lazy var animationView: AnimationView = {
//        let view = AnimationView.init(name: "loading-dots-blue-on-white")
//        view.frame = view.bounds
//        view.contentMode = .scaleAspectFit
//        view.loopMode = .loop
//        view.animationSpeed = 1.5
//        return view
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func transparentNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    // MARK: - showAlert
    
    func showActionAlert(message: String) -> Void {
        let Alert = UIAlertController(title: Strings.error.localize(), message: message, preferredStyle: UIAlertController.Style.alert)
        
        Alert.addAction(UIAlertAction(title: Strings.ok.localize(), style: .default, handler: { (action: UIAlertAction!) in
    //            self.delegate?.okAction(controller: vc)
        }))
        
        self.present(Alert, animated: true, completion: nil)
    }
    
    // MARK: - refreshHandle
    
    @objc func refreshHandle(){
        
    }
    
    // MARK: - setLoadingIndicator
    func setLoadingIndicatorToBarButton() {
        let barButton = UIBarButtonItem(customView: loadingIndicatorView)
        loadingIndicatorView.startAnimating()
        self.navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    // MARK: - when scroll navbar transparent progress
    func setNavbar(backgroundColorAlpha alpha: CGFloat) {
        let newColor = universalWhite(alpha: alpha) //your color
        self.navigationController?.navigationBar.backgroundColor = newColor
        UIApplication.shared.statusBarUIView?.backgroundColor = newColor
    }

    func universalWhite(alpha: CGFloat) -> UIColor {
        if self.traitCollection.userInterfaceStyle == .dark {
            return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: alpha)
        } else {
            return UIColor(red: 1, green: 1, blue: 1, alpha: alpha)
        }
    }
    
}
