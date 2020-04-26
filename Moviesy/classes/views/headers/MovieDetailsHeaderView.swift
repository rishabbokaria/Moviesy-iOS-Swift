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
    @IBOutlet var _contentView: UIView!
    @IBOutlet var _backdropImageView: UIImageView!
    @IBOutlet var _titleLabel: UILabel!
    @IBOutlet var _languageLabel: UILabel!
    @IBOutlet var _genreLabel: UILabel!
    @IBOutlet var _overviewLabel: UILabel!
    @IBOutlet var _releaseDateLabel: UILabel!
    
    override public init(frame: CGRect)
    {
        super.init(frame: frame);
        initFromXIB();
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
        initFromXIB();
    }
    
    private func initFromXIB()
    {
        let selfBundle = Bundle(for: type(of: self));
        let name = String(describing: type(of: self));
        let nib = UINib(nibName: name, bundle: selfBundle);
        nib.instantiate(withOwner: self, options: nil);
        
        _contentView.frame = self.bounds;
        _contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight];
        addSubview(_contentView);
    }
}
