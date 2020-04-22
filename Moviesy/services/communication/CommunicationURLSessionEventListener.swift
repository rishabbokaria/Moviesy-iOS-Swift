//
//  CKURLSessionEventListener.swift
//  CommunicationKit
//
//  Created by Rishab Bokaria on 8/9/18.
//  Copyright © 2018 RB Inc. All rights reserved.
//

import Foundation

protocol IURLSessionEventDelegate: class
{
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void);
}

class CommunicationURLSessionEventListener: NSObject, URLSessionDataDelegate
{
    private weak var _delegate: IURLSessionEventDelegate?;
    
    init(delegate: IURLSessionEventDelegate?)
    {
        _delegate = delegate;
    }
    
    func setDelegate(delegate: IURLSessionEventDelegate?)
    {
        _delegate = delegate;
    }
    
    deinit
    {
        _delegate = nil;
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        if (_delegate != nil)
        {
            _delegate!.urlSession(session, didReceive: challenge, completionHandler: completionHandler);
        }
    }
}

