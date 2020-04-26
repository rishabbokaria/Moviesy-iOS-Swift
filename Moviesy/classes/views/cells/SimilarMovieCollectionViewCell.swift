//
//  SimilarMovieCollectionViewCell.swift
//  Moviesy
//
//  Created by Rishab on 26/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import UIKit

class SimilarMovieCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var _posterImageView: UIImageView!
    
    var viewModel:MovieViewModel?
    {
        didSet
        {
            viewModel?.configure(self)
        }
    }

   //MARK: -
    //MARK: Lifecycle
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        updateView()
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        resetCell()
    }
    
    
    //MARK: -
    //MARK: Update UI
    
    private func updateView()
    {
        //TODO:
    }
    
    private func resetCell()
    {
        self.viewModel = nil
        _posterImageView.image = #imageLiteral(resourceName: "logo.png")
    }

}
