//
//  CastCrewCollectionViewCell.swift
//  Moviesy
//
//  Created by Rishab on 26/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import UIKit

class CastCrewCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var _profileImageView: UIImageView!
    @IBOutlet weak var _nameLabel: UILabel!
    
    var viewModel:CreditItemViewModel?
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
        
    }
    
    private func resetCell()
    {
        self.viewModel = nil
        _nameLabel.text = ""
        _profileImageView.image = #imageLiteral(resourceName: "logo.png")
    }
}
