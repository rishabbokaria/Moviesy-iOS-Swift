//
//  CreditsViewModel.swift
//  Moviesy
//
//  Created by Rishab on 26/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import Foundation

class CreditsViewModel
{
    let title:String
    let creditItems:[CreditItemViewModel]
    
    init(withTitle title:String, forCreditItems creditItems:[CreditItemViewModel])
    {
        self.title = title
        self.creditItems = creditItems
    }
}

extension CreditsViewModel
{
    public func configure(_ cell: CastCrewTableViewCell)
    {
        cell._titleLabel.text = self.title
        cell._castCrewCollectionView.reloadData()
    }
}
