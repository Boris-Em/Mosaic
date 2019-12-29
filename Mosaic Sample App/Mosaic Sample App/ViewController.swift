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
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 20.0
        scrollView.backgroundColor = .black
        return scrollView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let captureSessionManager = CaptureSessionManager()
    private lazy var mosaic: Mosaic = {
        var images = [UIImage]()
        for i in 1...38 {
            images.append(UIImage(named: "Image_Pool_\(i).jpg")!)
        }
        
        return try! Mosaic(imagePool: images)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()

        mosaic.preHeat()
        
        captureSessionManager.delegate = self
        captureSessionManager.start()
        
//        let image: UIImage = mosaic.generate(for: UIImage(named: "Base_Image.jpg")!.cgImage!)!
//        imageView.image = image
    }
    
    private func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let constraints = [
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}

extension ViewController: CaptureSessionManagerDelegate {
    
    func didCapture(_ texture: MTLTexture) {
        let image: UIImage = mosaic.generate(for: texture)!
        imageView.image = image
    }
    
}

extension ViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
