//
//  BaseViewController.swift
//  last_fm_search
//
//  Created by Moinuddin Girach on 23/06/20.
//  Copyright © 2020 Moinuddin Girach. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.color = .black
        loader.startAnimating()
        loader.hidesWhenStopped = true
        return loader
    }()
    
    let loaderView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loader.center = view.center
        loaderView.addSubview(loader)
        
        // Do any additional setup after loading the view.
    }
    
    func showLoader() {
        self.view.addSubview(loaderView)
    }
    
    func hideLoader() {
        loaderView.removeFromSuperview()
    }
    
    
    /// show alert message
    /// - Parameter message: message string.
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
