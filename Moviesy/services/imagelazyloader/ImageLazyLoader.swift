//
//  ImageLazyLoader.swift
//  ImageLazyLoader
//
//  Created by Rishab Bokaria on 8/7/18.
//  Copyright © 2019 RB Inc. All rights reserved.
//

import Foundation
import UIKit

public typealias ImageLazyLoadingResultHandler = (_ path:String, _ image:UIImage?, _ error:Error?) -> Void;

public class ImageLazyLoader
{
    //MARK: -
    //MARK: Static

    public static let shared = ImageLazyLoader();

    //MARK: -
    //MARK: Instance

    private var _session:URLSession?;

    private init()
    {
        //do nothing.
        let idenitifer:String = Bundle.main.bundleIdentifier!;
        let queue = OperationQueue.init();
        queue.name = idenitifer + ".imagelazyloadingqueue";
        let cache:URLCache = URLCache.init(memoryCapacity: 5242880, diskCapacity: 26214400, diskPath: "images");
        let configuration = URLSessionConfiguration.default;
        configuration.urlCache = cache;
        _session = URLSession.init(configuration: configuration, delegate: nil, delegateQueue: queue);
    }
    
    
    //MARK: -
    //MARK: Load Image

    public func load(imageUrl:String, hanlder:@escaping ImageLazyLoadingResultHandler) -> Void
    {
        let completion = { (data:Data?, error:Error?) -> Void in
            DispatchQueue.main.async
            {
                if let imageData = data
                {
                    if let image = UIImage.init(data: imageData)
                    {
                        hanlder(imageUrl, image, nil);
                    }
                    else
                    {
                        hanlder(imageUrl, nil, error ?? CommunicationError.init(errorCode: -1192, errorMessage: "Unable to load image."));
                    }
                }
                else
                {
                    hanlder(imageUrl, nil, error ?? CommunicationError.init(errorCode: -1191, errorMessage: "Unable to fetch image."));
                }
            }
        };
        
        let url = URL.init(string: imageUrl);
        let request = URLRequest(url: url!, cachePolicy:  URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60);
        let storedCacheResponse = self._session?.configuration.urlCache?.cachedResponse(for: request);
        if (storedCacheResponse == nil)
        {
            //print("remote-image");
            weak var weakSelf = self
            let urlTask = _session!.dataTask(with: request) { [weakSelf = weakSelf] (data:Data?, response:URLResponse?, error:Error?) -> Void in
                if (error == nil)
                {
                    let cacheResponse = CachedURLResponse(response: response!, data: data!);
                    weakSelf?._session?.configuration.urlCache?.storeCachedResponse(cacheResponse, for: request);
                    completion(data, nil);
                }
                else
                {
                    completion(nil, error);
                }
            }
            urlTask.resume();
        }
        else
        {
            //print("cached-image");
            completion(storedCacheResponse!.data, nil);
        }
    }
}
