//
//  SearchQueryCollectionViewCell.swift
//  Moviesy
//
//  Created by Rishab on 27/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import UIKit

class SearchQueryCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var _titleLabel: UILabel!

    var viewModel:RecentlySearchedViewModel?
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
        self.layer.cornerRadius = self.bounds.size.height * 0.5
        _titleLabel.preferredMaxLayoutWidth = 100.0
    }
    
    private func resetCell()
    {
        self.viewModel = nil
        _titleLabel.text = ""
    }
}
