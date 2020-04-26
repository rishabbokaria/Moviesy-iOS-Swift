//
//  ViewController.swift
//  Moviesy
//
//  Created by Rishab on 21/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController, OnConfigurationResultListener
{
    //MARK: -
    //MARK: Lifecycle

    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        //load config
        ConfigurationManager.shared.loadConfiguration(withResultListener: self)
    }
    
    //MARK: -
    //MARK: Navigation Methods
    
    private func moveToNextScreen(afterDelay delay:Double)
    {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) { [weak self] in
            self?.changeWindowRootToLandingScreen()
        }
    }
    
    private func changeWindowRootToLandingScreen()
    {
        if let storyboard = self.storyboard
        {
            let navigationController:UINavigationController = storyboard.instantiateViewController(identifier: StringValues.NavigationControllerId)
            let scene = UIApplication.shared.connectedScenes.first
            if let sceneDelegate : SceneDelegate = (scene?.delegate as? SceneDelegate)
            {
                if let sceneWindow = sceneDelegate.window
                {
                    sceneWindow.rootViewController = navigationController
                }
            }
        }
    }
    
    //MARK: -
    //MARK: OnConfigurationResultListener
    
    func onConfigurationLoaded(_ configuration: Configuration)
    {
        moveToNextScreen(afterDelay: 0.05)
    }
    
    func onConfigurationError(_ error: Error)
    {
        if let comError = error as? CommunicationError
        {
            if (comError.errorCode == CommunicationError.NO_NETWORK)
            {
                showNoNetworkAlert()
            }
            else
            {
                showAlert(title: StringValues.Error, message: StringValues.UnexpectedError)
            }
        }
        else
        {
            showAlert(title: StringValues.Error, message: StringValues.UnexpectedError)
        }
    }
}

