//
//  CastCrewViewModel.swift
//  Moviesy
//
//  Created by Rishab on 26/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import Foundation

class CreditItemViewModel
{
    let name:String
    let profileURL:String
    
    init(withName name:String?, andProfileURL profileURL:String?)
    {
        self.name = name ?? StringValues.NotAvailable
        var tempURL = ""
        if let profilePath = profileURL
        {
            if let profileSizes = ConfigurationManager.shared.configuration?.imagesInfo?.profileSizes
            {
                if let baseURL = ConfigurationManager.shared.configuration?.imagesInfo?.baseURL
                {
                    tempURL = baseURL + profileSizes[1] + profilePath
                }
            }
        }
        self.profileURL = tempURL
    }
}

extension CreditItemViewModel
{
    public func configure(_ cell: CastCrewCollectionViewCell)
    {
        cell._nameLabel.text = self.name
        if (!self.profileURL.isEmpty)
        {
            ImageLazyLoader.shared.load(imageUrl: self.profileURL) { [weak self] (imageUrl, image, error) in
                if (error == nil && imageUrl == self?.profileURL)
                {
                    cell._profileImageView.imageWithFade = image
                }
            }
        }
    }
}
