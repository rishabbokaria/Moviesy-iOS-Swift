//
//  UIViewController.swift
//  Moviesy
//
//  Created by Rishab on 23/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    
    //MARK: -
    //MARK: Loader
    
    func showSpinner(onView view: UIView) -> UIView
    {
        let spinnerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 56, height: 56))
        spinnerView.backgroundColor = UIColor.darkGray
        spinnerView.layer.cornerRadius = 8.0
        
        let spinner = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        spinner.startAnimating()
        
        spinner.center = spinnerView.center
        spinnerView.center = view.center

        DispatchQueue.main.async
        {
            view.endEditing(true)
            spinnerView.addSubview(spinner)
            view.addSubview(spinnerView)
            view.bringSubviewToFront(spinnerView)
        }
        
        return spinnerView
    }
    
    func hideSpinner(spinner :UIView?)
    {
        if (spinner != nil)
        {
            DispatchQueue.main.async
            {
                spinner!.removeFromSuperview()
            }
        }
    }
    
    //MARK: -
    //MARK: Alert
    
    func showNoNetworkAlert(completion: ((UIAlertAction) -> Void)? = nil)
    {
        let alert:UIAlertController = UIAlertController.init(title: StringValues.Error, message: StringValues.NoNetworkError, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: StringValues.Ok, style: .cancel, handler: completion))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title:String, message:String, completion: ((UIAlertAction) -> Void)? = nil)
    {
        let alert:UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: StringValues.Ok, style: .cancel, handler: completion))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showConfirmationAlert(title:String, message:String, action1: String, action2: String, completion: @escaping ((_ isConfirmedYes:Bool) -> Void))
    {
        let alert:UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: action1, style: .default, handler: { (action) in
            completion(true)
        }))
        alert.addAction(UIAlertAction.init(title: action2, style: .default, handler: { (action) in
            completion(false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
