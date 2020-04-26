//
//  ConfigurationManager.swift
//  Moviesy
//
//  Created by Rishab on 23/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import Foundation

enum ConfigurationError: Error {
    case unknown
}

class ConfigurationManager: OnCommunicationResponseListener
{
    static let shared = ConfigurationManager()
    
    private weak var _listener:OnConfigurationResultListener?
    var configuration:Configuration? = nil
    var languages:[Language]? = nil
    var genres:[Genre]? = nil

    private init()
    {
        //hide
    }
    
    func loadConfiguration(withResultListener listener:OnConfigurationResultListener)
    {
        _listener = listener
        fetchConfiguration()
    }
    
    //MARK: -
    //MARK: Misc

    private func fetchConfiguration()
    {
        do
        {
            try CommunicationManager.shared.perform(operation: ConfigurationOpertation(withListener: self))
        }
        catch
        {
            notifyResultToListener(result: false, error: error)
            fetchConfigurationLanguages()
        }
    }
    
    private func fetchConfigurationLanguages()
    {
        do
        {
            try CommunicationManager.shared.perform(operation: ConfigurationLanguagesOpertation(withListener: self))
        }
        catch
        {
            fetchMovieGenreList()
        }
    }
    
    private func fetchMovieGenreList()
    {
        do
        {
            try CommunicationManager.shared.perform(operation: MovieGenreListOperation(withListener: self))
        }
        catch
        {
            //ignore
        }
    }
    
    private func notifyResultToListener(result:Bool, error:Error?)
    {
        if let listener = _listener
        {
            if (result)
            {
                listener.onConfigurationLoaded(self.configuration!)
            }
            else
            {
                listener.onConfigurationError(error ?? ConfigurationError.unknown)
            }
        }
    }
    
    //MARK: -
    //MARK: OnCommunicationResponseListener Methods
    
    func onSuccess(id: Int, processor: ICommunicationResponseProcessor)
    {
        if (id == Communication.OperationID.Configuration)
        {
            let configProcessor = processor as! ConfigurationResponseProcessor
            self.configuration = configProcessor.configuration!
            notifyResultToListener(result: true, error: nil)
            fetchConfigurationLanguages()
        }
        else if (id == Communication.OperationID.ConfigurationLanguages)
        {
            let configProcessor = processor as! ConfigurationLanguagesResponseProcessor
            self.languages = configProcessor.languages!
            fetchMovieGenreList()
        }
        else if (id == Communication.OperationID.MovieGenreList)
        {
            let movieGenreListProcessor = processor as! MovieGenreListResponseProcessor
            self.genres = movieGenreListProcessor.data?.genres
        }
    }
    
    func onFailure(id: Int, error: CommunicationError)
    {
        if (error.errorCode == CommunicationError.NO_NETWORK)
        {
            notifyResultToListener(result: false, error: error)
        }
    }
}

protocol OnConfigurationResultListener:class
{
    func onConfigurationLoaded(_ configuration:Configuration)
    func onConfigurationError(_ error:Error)
}
