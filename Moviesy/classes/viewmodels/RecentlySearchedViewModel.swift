//
//  RecentlySearchedViewModel.swift
//  Moviesy
//
//  Created by Rishab on 27/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import Foundation

class RecentlySearchedViewModel
{
    let title:String
    
    init(withTitle title:String)
    {
        self.title = title
    }
}

extension RecentlySearchedViewModel
{
    public func configure(_ cell: SearchQueryCollectionViewCell)
    {
        cell._titleLabel.text = self.title
    }
}
