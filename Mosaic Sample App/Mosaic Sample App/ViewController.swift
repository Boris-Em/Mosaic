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
    
    private let captureSessionManager = CaptureSessionManager()
    private lazy var mosaic: Mosaic = {
        let images = [#imageLiteral(resourceName: "IMG_2006.jpeg"), #imageLiteral(resourceName: "IMG_2055.jpeg"), #imageLiteral(resourceName: "IMG_3991.jpeg"), #imageLiteral(resourceName: "IMG_4414.jpeg"), #imageLiteral(resourceName: "IMG_8293.jpeg"), #imageLiteral(resourceName: "IMG_9945.jpeg"), #imageLiteral(resourceName: "IMG_9346.jpg"), #imageLiteral(resourceName: "IMG_8348.jpg"), #imageLiteral(resourceName: "IMG_9825.jpg")]
        return try! Mosaic(imagePool: images)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        return
        
        mosaic.preHeat()
        
        captureSessionManager.delegate = self
        
        view.addSubview(imageView)
        
        captureSessionManager.start()
    }

}

extension ViewController: CaptureSessionManagerDelegate {
    func didCapture(_ texture: MTLTexture) {
        let image = mosaic.generateMosaic(for: texture)
        imageView.image = image
    }
    
}
