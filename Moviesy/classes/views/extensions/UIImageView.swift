//
//  UIImageView.swift
//  Moviesy
//
//  Created by Rishab on 25/04/20.
//  Copyright © 2020 RB Inc. All rights reserved.
//

import UIKit

extension UIImageView
{
    var imageWithFade:UIImage?
    {
        get
        {
            return self.image
        }
        set
        {
            
            UIView.transition(with: self, duration: 0.25, options: .transitionCrossDissolve, animations:
                {
                    self.image = newValue
            }, completion: nil)
        }
    }
    
}
