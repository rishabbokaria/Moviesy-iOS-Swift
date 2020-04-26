//
//  SimilarViewModel.swift
//  Moviesy
//
//  Created by Rishab on 26/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import Foundation

class SimilarViewModel
{
    let title:String
    let movieItems:[MovieViewModel]
    
    init(withTitle title:String, forItems movieItems:[MovieViewModel])
    {
        self.title = title
        self.movieItems = movieItems
    }
}

extension SimilarViewModel
{
    public func configure(_ cell: SimilarMovieTableViewCell)
    {
        cell._titleLabel.text = self.title
        cell._similarMovieCollectionView.reloadData()
    }
}
