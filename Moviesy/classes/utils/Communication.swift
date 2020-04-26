//
//  Communication.swift
//  Moviesy
//
//  Created by Rishab on 23/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import Foundation


class Communication
{
    class URL
    {
        private static let BasePath:String              = "https://api.themoviedb.org/3"
        
        static let Configuration:String                 = URL.BasePath + "/configuration"
        static let ConfigurationLanguages:String        = URL.BasePath + "/configuration/languages"
        static let MovieGenreList:String                = URL.BasePath + "/genre/movie/list"
        static let MovieNowPlaying:String               = URL.BasePath + "/movie/now_playing"
        static let MovieDetail:String                   = URL.BasePath + "/movie/{movie_id}"

    }
    class OperationID
    {
        static let Configuration:Int                    = 10001
        static let ConfigurationLanguages:Int           = 10002
        static let MovieGenreList:Int                   = 10003
        static let MovieNowPlaying:Int                  = 10004
        static let MovieDetail                          = 10005
    }
    
    class Request
    {
        //MARK: -
        //MARK: Headers
        static let ContentTypeKey:String                = "Content-Type"
        static let ContentTypeJSON:String               = "application/json"
        
        
        //MARK: -
        //MARK: Params
        static let ParamAPIKey:String                   = "api_key"
        static let ParamPage:String                     = "page"
        static let ParamLanguage:String                 = "language"
        static let ParamRegion:String                   = "region"
        static let ParamAppendToResponse:String         = "append_to_response"

        
        //MARK: -
        //MARK: Values
        static let ValueAPIKey:String                   = "1978505bd119bec914b379ca8e9a86ec"
        static let ValueLanguage:String                 = "en-IN"
        static let ValueRegion:String                   = "IN"
        static let ValueAppendToResponse:String         = "credits,reviews,similar"

    }
    
    static func appendAPIKeyParam(toURL url:String) -> String
    {
        return Communication.appendQuery(param: Request.ParamAPIKey, withValue: Request.ValueAPIKey, toURL: url)
    }
    
    static func appendQuery(param:String, withValue value:String, toURL url:String) -> String
    {
        let query = param + "=" + value
        if (url.contains("?"))
        {
            return url + "&" + query
        }
        else
        {
            return url + "?" + query
        }
    }
    
    static func getCommonHeaders() -> [String:String]
    {
        return [Request.ContentTypeKey:Request.ContentTypeJSON]
    }
}
