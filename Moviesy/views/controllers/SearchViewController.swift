//
//  SearchViewController.swift
//  Moviesy
//
//  Created by Rishab on 23/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, OnCommunicationResponseListener
{
    private var _spinnerView:UIView?
    private var _backButton:UIButton!
    
    //MARK: -
    //MARK: Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        updateView()
    }
    
    //MARK: -
    //MARK:  UI Customization
    
    private func updateView()
    {
        updateNavigationBar()
    }
    
    private func updateNavigationBar()
    {
        _backButton = getBackButton()
        self.navigationItem.titleView = UIImageView(image:#imageLiteral(resourceName: "logo-small"))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: _backButton)
    }
    
    private func getBackButton() -> UIButton
    {
        let button = UIButton.init(type: .custom)
        button.setImage(#imageLiteral(resourceName: "ic_back"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "ic_back"), for: .highlighted)
        button.setImage(#imageLiteral(resourceName: "ic_back"), for: .selected)
        
        button.frame = CGRect.init(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        button.addTarget(self, action: #selector(SearchViewController.didClickOnBackButton), for: .touchUpInside)
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
    
    @objc private func didClickOnBackButton(_ sender:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
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
