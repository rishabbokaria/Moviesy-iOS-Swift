//
//  CommunicationSecurity.swift
//  CommunicationKit
//
//  Created by Rishab Bokaria on 8/8/18.
//  Copyright © 2018 RB Inc. All rights reserved.
//

import Foundation

class CommunicationSecurity
{
    func protectionSpaceVerified(protectionSpace:URLProtectionSpace) -> Bool
    {
        /*
        var verified = true
        verified = verified && (protectionSpace.host.compare(ApiSecurity.apiHost, options: [.CaseInsensitiveSearch], range: nil, locale: nil) == .OrderedSame)
        if (ApiSecurity.enforceSsl){
            verified = verified && (protectionSpace.port == 443)
        }
        return verified */
        return true
    }
}
