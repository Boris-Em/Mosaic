//
//  UIColorExtensions.swift
//  Mosaic
//
//  Created by Boris Emorine on 10/11/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import UIKit

extension UIColor {
    
    var red: CGFloat {
        return self.cgColor.components![0]
    }
    var green: CGFloat {
        return self.cgColor.components![1]
    }
    var blue: CGFloat {
        return self.cgColor.components![2]
    }
    var alpha: CGFloat {
        return self.cgColor.components![3]
    }
    
}
