//
//  SearchResultsHeaderView.swift
//  Moviesy
//
//  Created by Rishab on 26/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import UIKit

class SearchResultsHeaderView:UIView
{
    @IBOutlet weak var _contentView: UIView!
    @IBOutlet weak var _titleLabel: UILabel!
    @IBOutlet weak var _searchQueriesCollectionView: UICollectionView!
    
    var viewModels:[RecentlySearchedViewModel]!
    {
        didSet
        {
            _searchQueriesCollectionView.reloadData()
        }
    }
    
    //MARK: -
    //MARK: Lifecycle
    
    override public init(frame: CGRect)
    {
        super.init(frame: frame)
        initFromXIB()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        initFromXIB()
    }
    
    private func initFromXIB()
    {
        let selfBundle = Bundle(for: type(of: self))
        let name = String(describing: type(of: self))
        let nib = UINib(nibName: name, bundle: selfBundle)
        nib.instantiate(withOwner: self, options: nil)
        
        _contentView.frame = self.bounds
        _contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(_contentView)
        updateView()
    }
    
    //MARK: -
    //MARK: Update UI
    
    private func updateView()
    {
        _searchQueriesCollectionView.register(UINib(nibName: StringValues.SearchQueryCollectionViewCellId, bundle: Bundle.main), forCellWithReuseIdentifier: StringValues.SearchQueryCollectionViewCellId)
    }
}

extension SearchResultsHeaderView : UICollectionViewDataSource, UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StringValues.SearchQueryCollectionViewCellId, for: indexPath) as! SearchQueryCollectionViewCell
        cell.viewModel = viewModels[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath)
    {
        
    }
}
