//
//  CompleteImageViewController.swift
//  Smashtag
//
//  Created by Chien on 2017/8/8.
//  Copyright © 2017年 Chien. All rights reserved.
//

import UIKit

class CompleteImageViewController: UIViewController {

    var image: UIImage = UIImage()
    var imageView: UIImageView = UIImageView()
    var scrollView = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        self.imageView = UIImageView(image: self.image)
        self.scrollView = UIScrollView(frame: self.view.bounds)

        self.scrollView.delegate = self
        self.scrollView.contentSize = self.imageView.bounds.size
        self.scrollView.minimumZoomScale = 0.1
        self.scrollView.maximumZoomScale = 5.0
        self.scrollView.zoomScale = 1.0
        self.scrollView.addSubview(self.imageView)

        self.view.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
}

extension CompleteImageViewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
