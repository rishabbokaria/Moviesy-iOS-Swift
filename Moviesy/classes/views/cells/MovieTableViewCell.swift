//
//  MovieTableViewCell.swift
//  Moviesy
//
//  Created by Rishab on 23/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell
{
    @IBOutlet weak var _holderView: UIView!
    @IBOutlet weak var _posterImageView: UIImageView!
    @IBOutlet weak var _bookButton: UIButton!
    @IBOutlet weak var _titleLabel: UILabel!
    @IBOutlet weak var _releaseDateLabel: UILabel!
    @IBOutlet weak var _overviewLabel: UILabel!
    
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
        _holderView.layer.cornerRadius = 5.0;
        _posterImageView.layer.cornerRadius = 3.0
        _bookButton.layer.cornerRadius = 2.5
    }
    
    private func resetCell()
    {
        self.viewModel = nil
        _titleLabel.text = ""
        _releaseDateLabel.text = ""
        _overviewLabel.text = ""
        _posterImageView.image = #imageLiteral(resourceName: "logo.png")
    }
    
    //MARK: -
    //MARK: Actions
    
    @IBAction func didClickOnBookButton(_ sender: Any)
    {
        
    }
}
