//
//  SimilarMovieTableViewCell.swift
//  Moviesy
//
//  Created by Rishab on 26/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import UIKit

class SimilarMovieTableViewCell: UITableViewCell
{
    @IBOutlet weak var _titleLabel: UILabel!
    @IBOutlet weak var _similarMovieCollectionView: UICollectionView!
    
    var viewModel:SimilarViewModel?
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
        _similarMovieCollectionView.register(UINib.init(nibName: StringValues.SimilarMovieCollectionViewCellId, bundle: Bundle.main), forCellWithReuseIdentifier: StringValues.SimilarMovieCollectionViewCellId)
    }
    
    private func resetCell()
    {
        _titleLabel.text = ""
        self.viewModel = nil
        _similarMovieCollectionView.reloadData()
    }
}

extension SimilarMovieTableViewCell : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if let similar = self.viewModel
        {
            return similar.movieItems.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StringValues.SimilarMovieCollectionViewCellId, for: indexPath) as! SimilarMovieCollectionViewCell
        cell.viewModel = self.viewModel?.movieItems[indexPath.row]
        return cell
    }
    
}
