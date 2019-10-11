//
//  ViewController.swift
//  Mosaic Sample App
//
//  Created by Boris Emorine on 10/11/19.
//  Copyright © 2019 Boris Emorine. All rights reserved.
//

import UIKit
import Mosaic

class ViewController: UIViewController {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        
        let images = [#imageLiteral(resourceName: "IMG_2006.jpeg"), #imageLiteral(resourceName: "IMG_2055.jpeg"), #imageLiteral(resourceName: "IMG_3991.jpeg"), #imageLiteral(resourceName: "IMG_4414.jpeg"), #imageLiteral(resourceName: "IMG_8293.jpeg"), #imageLiteral(resourceName: "IMG_9945.jpeg")]
        let mosaic = try! Mosaic(imagePool: images)
        
        let mosaicImage = mosaic.generateMosaic(for: #imageLiteral(resourceName: "IMG_5400.jpg"))
        imageView.image = mosaicImage
    }

}

