//
//  ConfigurationOpertation.swift
//  Moviesy
//
//  Created by Rishab on 23/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import Foundation

class ConfigurationOpertation: ICommunicationOperation
{
    private weak var _listener: OnCommunicationResponseListener?

    init(withListener listener: OnCommunicationResponseListener?)
    {
        _listener = listener
    }
    
    func getId() -> Int
    {
        return Communication.OperationID.Configuration
    }
    
    func getPath() -> String
    {
        return Communication.Request.appendAPIKeyParam(toURL: Communication.URL.Configuration)
    }
    
    func getHeaders() -> [String : String]?
    {
        return Communication.Request.getCommonHeaders()
    }
    
    func getMethod() -> CommunicationHttpMethod
    {
        return .GET
    }
    
    func getPayload() -> Data?
    {
        return nil
    }
    
    func shouldUseCache() -> Bool
    {
        return true
    }
    
    func getProcessor() -> ICommunicationResponseProcessor
    {
        return ConfigurationResponseProcessor()
    }
    
    func getListener() -> OnCommunicationResponseListener?
    {
        return _listener
    }
    
    func destroy()
    {
        _listener = nil
    }
}


class ConfigurationResponseProcessor: ICommunicationResponseProcessor
{
    private var _config:Configuration?
    var config:Configuration
    {
        return _config!
    }
    
    func parseResponse(statusCode: Int, responseText: String, responseHeaders: [AnyHashable : Any]) throws -> Bool
    {
        do
        {
            _config = try JSONDecoder().decode(Configuration.self, from: responseText.data(using: .utf8)!)
            if let images = _config?.imagesInfo
            {
                if let secureBaseURL = images.secureBaseURL
                {
                    return !secureBaseURL.isEmpty
                }
            }
        }
        catch
        {
            throw CommunicationError(errorCode: CommunicationError.UNEXPECTED_RESPONSE, errorMessage: "Invalid JSON.")
        }
        return false
    }
}
