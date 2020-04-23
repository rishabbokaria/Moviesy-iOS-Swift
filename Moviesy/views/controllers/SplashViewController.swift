//
//  ViewController.swift
//  Moviesy
//
//  Created by Rishab on 21/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController, OnCommunicationResponseListener
{
    //MARK: -
    //MARK: Lifecycle

    override func viewDidLoad()
    {
        super.viewDidLoad()
        fetchData()
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
    //MARK: Misc

    private func fetchData()
    {
        do
        {
            try CommunicationManager.shared.perform(operation: ConfigurationOpertation(withListener: self))
        }
        catch
        {
            showNoNetworkAlert()
        }
    }
    
    //MARK: -
    //MARK: OnCommunicationResponseListener Methods
    
    func onSuccess(id: Int, processor: ICommunicationResponseProcessor)
    {
        if (id == Communication.OperationID.Configuration)
        {
            let configProcessor = processor as! ConfigurationResponseProcessor
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.configuration = configProcessor.config
            moveToNextScreen(afterDelay: 0.1)
        }
    }
    
    func onFailure(id: Int, error: CommunicationError)
    {        
        if (error.errorCode == CommunicationError.NO_NETWORK)
        {
            showNoNetworkAlert()
        }
    }
}

