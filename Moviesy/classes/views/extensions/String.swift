//
//  String.swift
//  Moviesy
//
//  Created by Rishab on 26/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import Foundation

extension String
{
    func toDate(withFormat format: String = "yyyy-MM-dd")-> Date?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_IN")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Mumbai")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
}
