//
//  Date.swift
//  Moviesy
//
//  Created by Rishab on 26/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import Foundation

extension Date
{
    func toString(withFormat format: String = "EEE، d MMM yy") -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_IN")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Mumbai")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        return str
    }
}
