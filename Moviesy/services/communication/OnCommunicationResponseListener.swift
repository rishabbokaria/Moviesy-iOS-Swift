//
//  OnCommunicationResponseListener.swift
//  CommunicationKit
//
//  Created by Rishab Bokaria on 8/6/19.
//  Copyright © 2018 RB Inc. All rights reserved.
//

import Foundation

public protocol OnCommunicationResponseListener:class
{
    func onSuccess(id:Int, processor:ICommunicationResponseProcessor);
    func onFailure(id:Int, error:CommunicationError);
}
