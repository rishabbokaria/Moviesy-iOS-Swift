//
//  CastCrewTableViewCell.swift
//  Moviesy
//
//  Created by Rishab on 26/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import UIKit

class CastCrewTableViewCell: UITableViewCell
{
    @IBOutlet weak var _titleLabel: UILabel!
    @IBOutlet weak var _castCrewCollectionView: UICollectionView!
    
    var viewModel:CreditsViewModel?
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
        resetCell()
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
        self.selectionStyle = .none
        _castCrewCollectionView.register(UINib.init(nibName: StringValues.CastCrewCollectionViewCellId, bundle: Bundle.main), forCellWithReuseIdentifier: StringValues.CastCrewCollectionViewCellId)
    }
    
    private func resetCell()
    {
        _titleLabel.text = ""
        self.viewModel = nil
        _castCrewCollectionView.reloadData()
    }
    
    
}

extension CastCrewTableViewCell : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if let credits = self.viewModel
        {
            return credits.creditItems.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StringValues.CastCrewCollectionViewCellId, for: indexPath) as! CastCrewCollectionViewCell
        cell.viewModel = self.viewModel?.creditItems[indexPath.row]
        return cell
    }
    
}
