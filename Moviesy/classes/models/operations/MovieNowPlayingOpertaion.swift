//
//  NowPlayingOpertaion.swift
//  Moviesy
//
//  Created by Rishab on 23/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import Foundation

class MovieNowPlayingOpertaion: ICommunicationOperation
{
    private weak var _listener: OnCommunicationResponseListener?
    
    private let _page:Int;
    
    init(withListener listener: OnCommunicationResponseListener?, pageNumber page:Int)
    {
        _listener = listener
        _page = page;
    }
    
    func getId() -> Int
    {
        return Communication.OperationID.MovieNowPlaying
    }
    
    func getPath() -> String
    {
        var path = Communication.appendAPIKeyParam(toURL: Communication.URL.MovieNowPlaying)
        path = Communication.appendQuery(param: Communication.Request.ParamLanguage, withValue: Communication.Request.ValueLanguage, toURL: path)
        path = Communication.appendQuery(param: Communication.Request.ParamRegion, withValue: Communication.Request.ValueRegion, toURL: path)
        path = Communication.appendQuery(param: Communication.Request.ParamPage, withValue: "\(_page)", toURL: path)
        return path
    }
    
    func getHeaders() -> [String : String]?
    {
        return Communication.getCommonHeaders()
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
    var data:MovieNowPlayingResponseData?
    
    func parseResponse(statusCode: Int, responseText: String, responseHeaders: [AnyHashable : Any]) throws -> Bool
    {
        do
        {
            if (statusCode == 200)
            {
                self.data = try JSONDecoder().decode(MovieNowPlayingResponseData.self, from: responseText.data(using: .utf8)!)
                return true
            }
        }
        catch
        {
            print(error)
            throw CommunicationError(errorCode: CommunicationError.UNEXPECTED_RESPONSE, errorMessage: "Invalid JSON.")
        }
        return false
    }
}

struct MovieNowPlayingResponseData: Codable
{
    let movies: [Movie]?
    let page, totalResults: Int?
    let dateInfo: DateInfo?
    let totalPages: Int?

    enum CodingKeys: String, CodingKey
    {
        case movies = "results"
        case page
        case totalResults = "total_results"
        case dateInfo = "dates"
        case totalPages = "total_pages"
    }
}

struct DateInfo: Codable
{
    let maximum, minimum: String?
}
