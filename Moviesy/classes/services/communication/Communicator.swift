//
//  Communicator.swift
//  CommunicationKit
//
//  Created by Rishab Bokaria on 8/6/19.
//  Copyright © 2019 RB Inc. All rights reserved.
//

import Foundation

class Communicator: NSObject
{
    //MARK: -
    
    private var _session:URLSession?;
    private var _operation: ICommunicationOperation?;
    var operation:ICommunicationOperation {
        return _operation!;
    };
    private weak var _listener: OnCommunicationCompletionListener?;
    private var _dataTask:URLSessionDataTask?;
    
    init(session:URLSession, operation: ICommunicationOperation, listener: OnCommunicationCompletionListener)
    {
        _session = session;
        _operation = operation;
        _listener = listener;
    }
    
    //MARK: -
    
    func call()
    {
        var request = URLRequest.init(url: URL.init(string: _operation!.getPath())!, cachePolicy: .reloadIgnoringLocalCacheData , timeoutInterval: 30);//in seconds
        let method:CommunicationHttpMethod = _operation!.getMethod();
        request.httpMethod = method.rawValue;
        if let headers = _operation!.getHeaders()//add headers
        {
            for (key, value) in headers
            {
                request.addValue(value, forHTTPHeaderField: key);
            }
        }
        if (method == .POST || method == .PUT)
        {
            if let httpBody = _operation!.getPayload()//add body
            {
                request.httpBody = httpBody;
            }
        }
        
        var loadFromServer:Bool = true;
        if (_operation!.shouldUseCache())
        {
            request.cachePolicy = .returnCacheDataElseLoad;
            let cachedResponse:CachedURLResponse? = self._session?.configuration.urlCache?.cachedResponse(for: request);
            if (cachedResponse != nil)
            {
                //print("loading-from-cache");
                loadFromServer = false;
                self.process(data: cachedResponse?.data, response: cachedResponse?.response, error: nil);
            }
        }
        
        if (loadFromServer)
        {
            weak var weakSelf = self
            let lOperation:ICommunicationOperation = self._operation!
            let cache:URLCache = (self._session?.configuration.urlCache!)!;
            
            _dataTask = _session!.dataTask(with: request) { [weakSelf = weakSelf] (data:Data?, response:URLResponse?, error:Error?) in
                //print("loading-from-server");
                if (error == nil && lOperation.shouldUseCache())
                {
                    let toCacheResponse:CachedURLResponse = CachedURLResponse(response: response!, data: data!);
                    cache.storeCachedResponse(toCacheResponse, for: request);
                }
                if (weakSelf == nil)
                {
                    print("i am nil in call")
                }
                weakSelf?.process(data: data, response: response, error: error);
            }
            _dataTask!.resume();
        }
    }
    
    func end()
    {
        _dataTask!.cancel();
    }
    
    func destroy()
    {
        _session = nil;
        _operation?.destroy();
        _operation = nil;
        _listener = nil;
        _dataTask = nil;
    }
    
    //MARK: -
    
    private func process(data:Data?, response:URLResponse?, error: Error?)
    {
        if let kOperation = self._operation
        {
            DispatchQueue.global(qos: .userInitiated).async
                {
                    var comError:CommunicationError? = nil;
                    var result:Bool = false;
                    let processor:ICommunicationResponseProcessor = kOperation.getProcessor();
                    
                    if (error == nil && data != nil)
                    {
                        let code = (response as! HTTPURLResponse).statusCode;
                        if (code == 200)
                        {
                            let responseHeaders = (response as! HTTPURLResponse).allHeaderFields;
                            let responseStr = String.init(data: data!, encoding: .utf8)!;
                            do
                            {
                                result = try processor.parseResponse(statusCode: code, responseText: responseStr, responseHeaders: responseHeaders);
                                if (!result)
                                {
                                    comError  = CommunicationError.error(forStatus: code, error: nil, response:responseStr);
                                }
                            }
                            catch let e1
                            {
                                comError = CommunicationError.error(forStatus: code, error: e1, response:responseStr);
                            }
                        }
                        else
                        {
                            comError = CommunicationError.error(forStatus: code, error: nil, response:nil);
                        }
                    }
                    else
                    {
                        comError = CommunicationError.error(forStatus: -1, error: error ?? nil, response:nil);
                    }
                    self.notifyListener(result: result, processor: processor, error: comError)
            }
        }
    }
    
    private func notifyListener(result:Bool, processor:ICommunicationResponseProcessor?, error:CommunicationError?)
    {
        if let mOperation = self._operation
        {
            DispatchQueue.main.async
                {
                    if let listener = mOperation.getListener()
                    {
                        if (result)
                        {
                            listener.onSuccess(id: mOperation.getId(), processor:processor!);
                        }
                        else
                        {
                            listener.onFailure(id: mOperation.getId(), error: error!);
                        }
                    }
                    self._listener?.onComplete(id: mOperation.getId(), success: result);
            }
        }
    }
}

extension Communicator: IURLSessionEventDelegate
{
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        let serverTrust = challenge.protectionSpace.serverTrust
        //let certificate =  SecTrustGetCertificateAtIndex(serverTrust!, 0)
        
        //set ssl polocies for domain name check
        let policies = NSMutableArray()
        policies.add(SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString))
        SecTrustSetPolicies(serverTrust!, policies)
        
        //evaluate server certifiacte
        var isServerTrusted:Bool = false
        
        if #available(iOS 13.0, *) {
            var error:CFError? = nil
            isServerTrusted = SecTrustEvaluateWithError(serverTrust!, &error)
        } else {
            var result:SecTrustResultType =  SecTrustResultType(rawValue: 0)!
            SecTrustEvaluate(serverTrust!, &result)
            isServerTrusted = (result == SecTrustResultType.unspecified || result == SecTrustResultType.proceed)
        }
        
        
        //get Local and Remote certificate Data
        
        //let remoteCertificateData:NSData =  SecCertificateCopyData(certificate!)
        //let pathToCertificate = Bundle.main.path(forResource: "github.com", ofType: "cer")
        //let localCertificateData:NSData = NSData(contentsOfFile: pathToCertificate!)!
        
        //Compare certificates
        if(isServerTrusted)
        {
            let credential:URLCredential =  URLCredential(trust:serverTrust!)
            completionHandler(.useCredential, credential)
        }
        else
        {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}
