//
//  CommunicationManager.swift
//  Communication
//
//  Created by Rishab Bokaria on 8/6/19.
//  Copyright © 2018 RB Inc. All rights reserved.
//

import Foundation

public class CommunicationManager : OnCommunicationCompletionListener
{
    public static let shared: CommunicationManager = CommunicationManager();
    
    private var _operations: [ICommunicationOperation]?;
    private var _session:URLSession?;
    private var _sessionEventListener:CommunicationURLSessionEventListener?;
    private var _reachability:Reachability?;
    private var _communicator: Communicator?;
    var communicator:Communicator {
        return _communicator!
    }
    
    private var _isNetworkAvailable:Bool = false;
    var isNetworkAvailable:Bool {
        return _isNetworkAvailable;
    }
    
    init()
    {
        _operations = [];
        _session = nil;
        _sessionEventListener = nil;
        _reachability = nil;
        _isNetworkAvailable = false;
        _communicator = nil;
    }
    
    public func initialize()
    {
        initializeURLSession();
        initializeReachability();
    }
    
    public func perform(operation:ICommunicationOperation) throws -> Void
    {
        if (_isNetworkAvailable)
        {
            _operations!.append(operation);
            processQueue();
        }
        else
        {
            let domain = CommunicationError.DOMAIN;
            let description = "Internet connection not available.";
            let msg:String = domain + "---->" + description;
            let code:Int = CommunicationError.NO_NETWORK;
            let error:CommunicationError = CommunicationError(statusCode:-1, responseText: "", errorCode: code, errorMessage: msg);
            throw error;
        }
    }
    
    public func abort(operation:ICommunicationOperation) -> Void
    {
        if (_communicator != nil && _communicator!.operation.getId() == operation.getId())
        {
            _communicator?.end();
            clearCommunicator();
        }
        else
        {
            let indexToRemove = _operations!.firstIndex{$0 === operation} ?? -1;
            if (indexToRemove >= 0 && indexToRemove < _operations!.count)
            {
                _operations!.remove(at: indexToRemove);
            }
        }
    }
    
    private func initializeURLSession()
    {
        let idenitifer:String = Bundle.main.bundleIdentifier!;
        let queue:OperationQueue = OperationQueue.init();
        queue.name = idenitifer + ".communicationqueue";
        let cache:URLCache = URLCache.init(memoryCapacity: 2097152, diskCapacity: 10485760, diskPath: "data");
        let configuration:URLSessionConfiguration = URLSessionConfiguration.default;
        configuration.urlCache = cache;
        
        _sessionEventListener = CommunicationURLSessionEventListener(delegate:nil);
        _session = URLSession.init(configuration: configuration, delegate: _sessionEventListener!, delegateQueue: queue);
    }
    
    private func initializeReachability()
    {
        weak var weakSelf = self;
        _reachability = Reachability()!;
        _reachability?.whenReachable = { [weakSelf = weakSelf] reachability in
            weakSelf?._isNetworkAvailable = true;
            //print("Reachable");
        }
        _reachability?.whenUnreachable = { [weakSelf = weakSelf] _ in
            weakSelf?._isNetworkAvailable = false;
            //print("Not reachable");
        }
        
        do {
            try _reachability?.startNotifier();
        } catch {
            //print("Unable to start notifier");
        }
        _isNetworkAvailable = (_reachability?.connection != Reachability.Connection.none);
    }
    
    private func processQueue()
    {
        if (_operations!.count > 0 && _communicator == nil)
        {
            let operationToProcess = _operations!.removeFirst();
            _communicator = Communicator(session:_session!, operation: operationToProcess, listener: self);
            _sessionEventListener?.setDelegate(delegate: _communicator);
            _communicator?.call();
        }
    }
    
    private func clearCommunicator()
    {
        _sessionEventListener?.setDelegate(delegate: nil);
        _communicator!.destroy();
        _communicator = nil;
    }
    
    func onComplete(id:Int, success:Bool)
    {
        clearCommunicator();
        processQueue();
    }
    
    deinit
    {
        _session = nil;
        _operations?.removeAll();
        _operations = nil;
        _reachability?.stopNotifier();
        _reachability = nil;
        if (_communicator != nil)
        {
            _communicator?.end();
            clearCommunicator();
        }
    }
}
