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
        static let NowPlaying:String                    = URL.BasePath + "/movie/now_playing"
    }
    class OperationID
    {
        static let Configuration:Int                    = 10001
        static let NowPlaying:Int                       = 10002
    }
    
    class Request
    {
        //MARK: -
        //MARK: Config
        static let TMDB_APIKeyV3Auth:String                  = "1978505bd119bec914b379ca8e9a86ec"
        static let TMDB_APIReadAccessTokenV4Auth:String      = """
        eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxOTc4NTA1YmQxMTliZWM5MTRiMzc5Y2E4ZTlhODZlYyIsInN1YiI6IjVlOWRmMzk0NjgwYmU4MDAyNmM2YmJlNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.hb9ot0bPWx9bdIuSsPOzDxQWsUWT4sX1b-5iQa6BHRQ

        """
        
        //MARK: -
        //MARK: Headers
        static let ContentTypeKey:String                = "Content-Type"
        static let ContentTypeJSON:String               = "application/json"
        
        
        //MARK: -
        //MARK: Params
        static let ParamAPIKey:String                   = "api_key"
        
        
        static func appendAPIKeyParam(toURL url:String) -> String
        {
            let APIKeyParam = Request.ParamAPIKey + "=" + Request.TMDB_APIKeyV3Auth
            if (url.contains("?"))
            {
                return url + "&" + APIKeyParam
            }
            else
            {
                return url + "?" + APIKeyParam
            }
        }
        
        static func getCommonHeaders() -> [String:String]
        {
            return [ContentTypeKey:ContentTypeJSON]
        }
    }
    
    
}
