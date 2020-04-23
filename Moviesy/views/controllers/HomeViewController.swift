//
//  HomeViewController.swift
//  Moviesy
//
//  Created by Rishab on 22/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController, OnCommunicationResponseListener
{
    private var _spinnerView:UIView?
    private var _searchButton:UIButton!

    //MARK: -
    //MARK: Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    //MARK: -
    //MARK:  UI Customization
    
    private func updateView()
    {
        updateNavigationBar()
    }
    
    private func updateNavigationBar()
    {
        _searchButton = getSearchButton()
        self.navigationItem.titleView = UIImageView(image:#imageLiteral(resourceName: "logo-small"))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: _searchButton)
    }
    
    private func getSearchButton() -> UIButton
    {
        let button = UIButton.init(type: .custom)
        button.setImage(#imageLiteral(resourceName: "ic_search"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "ic_search"), for: .highlighted)
        button.setImage(#imageLiteral(resourceName: "ic_search"), for: .selected)

        button.frame = CGRect.init(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        button.addTarget(self, action: #selector(HomeViewController.didClickOnSearchButton), for: .touchUpInside)
        button.backgroundColor = UIColor.clear
        button.tintColor = UIColor.white
        return button
    }
    
    private func removeSpinner()
    {
        hideSpinner(spinner: _spinnerView)
        _spinnerView = nil
    }
    
    //MARK: -
    //MARK: Actions
    
    @objc private func didClickOnSearchButton(_ sender:UIButton)
    {
        self.performSegue(withIdentifier: StringValues.SearchSegueId, sender:sender)
    }
    
    //MARK: -
    //MARK: Misc

    private func fetchData()
    {
        do
        {
            try CommunicationManager.shared.perform(operation: NowPlayingOpertaion(withListener: self))
            _spinnerView = showSpinner(onView: self.view)
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
        removeSpinner()
        
        if (id == Communication.OperationID.Configuration)
        {
            
        }
    }
    
    func onFailure(id: Int, error: CommunicationError)
    {
        removeSpinner()
        
        if (error.errorCode == CommunicationError.NO_NETWORK)
        {
            showNoNetworkAlert()
        }
    }

}
