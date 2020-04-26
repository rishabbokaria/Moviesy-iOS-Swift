//
//  MovieDetailsHeaderView.swift
//  Moviesy
//
//  Created by Rishab on 26/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import UIKit

class MovieDetailsHeaderView: UIView
{
    @IBOutlet weak var _contentView: UIView!
    @IBOutlet weak var _backdropImageView: UIImageView!
    @IBOutlet weak var _titleLabel: UILabel!
    @IBOutlet weak var _languageLabel: UILabel!
    @IBOutlet weak var _genreLabel: UILabel!
    @IBOutlet weak var _overviewLabel: UILabel!
    @IBOutlet weak var _releaseDateLabel: UILabel!
    
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
        _backdropImageView.image = #imageLiteral(resourceName: "logo.png")
        _titleLabel.text = ""
        _genreLabel.text = ""
        _languageLabel.text = ""
        _releaseDateLabel.text = ""
        _overviewLabel.text = ""
    }
}
