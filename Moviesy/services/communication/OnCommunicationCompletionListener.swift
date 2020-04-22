//
//  OnCommunicationCompletionListener.swift
//  CommunicationKit
//
//  Created by Rishab Bokaria on 8/6/19.
//  Copyright © 2018 RB Inc. All rights reserved.
//

import Foundation

protocol OnCommunicationCompletionListener:class
{
    func onComplete(id:Int, success:Bool);
}
