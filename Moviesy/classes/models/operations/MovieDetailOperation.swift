//
//  MovieDetailOperation.swift
//  Moviesy
//
//  Created by Rishab on 26/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import Foundation

class MovieDetailOperation : ICommunicationOperation
{
    private weak var _listener: OnCommunicationResponseListener?
    private var _movieId:String

    init(withListener listener: OnCommunicationResponseListener?, forMovieId movieId:String)
    {
        _listener = listener
        _movieId = movieId
    }
    
    func getId() -> Int
    {
        return Communication.OperationID.MovieDetail
    }
    
    func getPath() -> String
    {
        var path = Communication.URL.MovieDetail.replacingOccurrences(of: "{movie_id}", with: _movieId)
        path = Communication.appendAPIKeyParam(toURL: path)
        path = Communication.appendQuery(param: Communication.Request.ParamLanguage, withValue: Communication.Request.ValueLanguage, toURL: path)
        path = Communication.appendQuery(param: Communication.Request.ParamAppendToResponse, withValue: Communication.Request.ValueAppendToResponse, toURL: path)
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
        return true
    }
    
    func getProcessor() -> ICommunicationResponseProcessor
    {
        return MovieDetailResponseProcessor()
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

class MovieDetailResponseProcessor: ICommunicationResponseProcessor
{
    var data:Movie?

    func parseResponse(statusCode: Int, responseText: String, responseHeaders: [AnyHashable : Any]) throws -> Bool
    {
        do
        {
            if (statusCode == 200)
            {
                self.data = try JSONDecoder().decode(Movie.self, from: responseText.data(using: .utf8)!)
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
