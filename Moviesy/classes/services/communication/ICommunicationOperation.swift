//
//  CommunicationOperation.swift
//  CommunicationKit
//
//  Created by Rishab Bokaria on 8/6/19.
//  Copyright © 2019 RB Inc. All rights reserved.
//

import Foundation

public protocol ICommunicationOperation:class
{
    func getId() -> Int;
    func getPath() -> String;
    func getHeaders() -> [String: String]?;
    func getMethod() -> CommunicationHttpMethod;
    func getPayload() -> Data?;
    func shouldUseCache() -> Bool;
    func getProcessor() -> ICommunicationResponseProcessor;
    func getListener() -> OnCommunicationResponseListener?;
    func destroy();
}
