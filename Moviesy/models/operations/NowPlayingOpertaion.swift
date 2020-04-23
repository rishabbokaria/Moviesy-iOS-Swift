//
//  NowPlayingOpertaion.swift
//  Moviesy
//
//  Created by Rishab on 23/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import Foundation

class NowPlayingOpertaion: ICommunicationOperation
{
    private weak var _listener: OnCommunicationResponseListener?
    
    init(withListener listener: OnCommunicationResponseListener?)
    {
        _listener = listener
    }
    
    
    func getId() -> Int
    {
        return Communication.OperationID.NowPlaying
    }
    
    func getPath() -> String
    {
        return Communication.URL.NowPlaying
    }
    
    func getHeaders() -> [String : String]?
    {
        return nil
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
        return false
    }
    
    func getProcessor() -> ICommunicationResponseProcessor
    {
        return NowPlayingResponseProcessor()
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


class NowPlayingResponseProcessor: ICommunicationResponseProcessor
{
    func parseResponse(statusCode: Int, responseText: String, responseHeaders: [AnyHashable : Any]) throws -> Bool
    {
        return true
    }
}
