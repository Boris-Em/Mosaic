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
        imageView.backgroundColor = .black
        return imageView
    }()
    
    private let captureSessionManager = CaptureSessionManager()
    private lazy var mosaic: Mosaic = {
        var images = [UIImage]()
        for i in 0..<27 {
            images.append(UIImage(named: "Rectangle_\(i).jpg")!)
        }
        
        images = images + [#imageLiteral(resourceName: "IMG_2006.jpeg"), #imageLiteral(resourceName: "IMG_2055.jpeg"), #imageLiteral(resourceName: "IMG_3991.jpeg"), #imageLiteral(resourceName: "IMG_4414.jpeg"), #imageLiteral(resourceName: "IMG_8293.jpeg"), #imageLiteral(resourceName: "IMG_9945.jpeg"), #imageLiteral(resourceName: "IMG_9346.jpg"), #imageLiteral(resourceName: "IMG_8348.jpg"), #imageLiteral(resourceName: "IMG_9825.jpg")]
        
        return try! Mosaic(imagePool: images)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        mosaic.preHeat()
        
        captureSessionManager.delegate = self
        
        view.addSubview(imageView)
        
        captureSessionManager.start()
        
//        let image: UIImage = mosaic.generateMosaic(for: #imageLiteral(resourceName: "Test_image_1.jpg").cgImage!)!
//        imageView.image = image
    }

}

extension ViewController: CaptureSessionManagerDelegate {
    func didCapture(_ texture: MTLTexture) {
        let image: UIImage = mosaic.generateMosaic(for: texture)!
        imageView.image = image
    }
    
}
