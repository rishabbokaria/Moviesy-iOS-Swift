//
//  CommunicationError.swift
//  CommunicationKit
//
//  Created by Rishab Bokaria on 8/6/19.
//  Copyright © 2019 RB Inc. All rights reserved.
//

import Foundation

public class CommunicationError:Error
{
    public static let DOMAIN:String = "CommunicationErrorDomain";

    public static let NO_NETWORK                = 2199;
    public static let UNEXPECTED_RESPONSE       = 2200;
    public static let NO_RESPONSE               = 2201;
    public static let CONTENT_NOT_AVAILABLE     = 2202;
    public static let CONTENT_NOT_MODIFIED      = 2203;
    
    private let _statusCode:Int;
    public var statusCode:Int {
        return _statusCode;
    };
    
    private let _errorCode:Int;
    public var errorCode:Int {
        return _errorCode;
    };
    
    private let _errorMessage:String;
    public var errorMessage:String {
        return _errorMessage;
    };
    
    private let _responseText:String;
    public var responseText:String {
        return _responseText;
    };
    
    init(statusCode:Int, responseText:String, errorCode:Int, errorMessage:String)
    {
        _statusCode = statusCode;
        _responseText = responseText;
        _errorCode = errorCode;
        _errorMessage = errorMessage;
    }
    
    public init(errorCode:Int, errorMessage:String)
    {
        _statusCode = -1;
        _responseText = "";
        _errorCode = errorCode;
        _errorMessage = errorMessage;
    }
    
    static func error(forStatus status:Int, error:Error?, response:String?) -> CommunicationError
    {
        if (CommunicationManager.shared.isNetworkAvailable)
        {
            let domain = error?.domain ?? CommunicationError.DOMAIN;
            let description = error?.localizedDescription ?? "No response from server.";
            let msg:String = domain + "---->" + description;
            let code:Int = error?.code ?? CommunicationError.NO_RESPONSE;
            return CommunicationError(statusCode:status, responseText:response ?? "", errorCode: code, errorMessage: msg);
        }
        else
        {
            let domain = CommunicationError.DOMAIN;
            let description = "Internet connection not available.";
            let msg:String = domain + "---->" + description;
            let code:Int = CommunicationError.NO_NETWORK;
            return CommunicationError(statusCode:status, responseText:response ?? "", errorCode: code, errorMessage: msg);
        }
    }
}

extension Error
{
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
    var description: String { return (self as NSError).localizedDescription }
}
