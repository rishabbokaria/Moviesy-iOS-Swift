//
//  ICommunicationResponseProcessor.swift
//  CommunicationKit
//
//  Created by Rishab Bokaria on 8/6/19.
//  Copyright © 2018 RB Inc. All rights reserved.
//

import Foundation

public protocol ICommunicationResponseProcessor
{
    func parseResponse(statusCode:Int, responseText:String, responseHeaders:[AnyHashable : Any]) throws -> Bool;
}
