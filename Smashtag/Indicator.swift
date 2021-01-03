//
//  Indicator.swift
//  Smashtag
//
//  Created by Chien on 2017/8/15.
//  Copyright © 2017年 Chien. All rights reserved.
//

import UIKit

class Indicator {

    fileprivate var keyWindow: UIWindow {
        guard let window = UIApplication.shared.keyWindow else { return UIWindow() }
        return window
    }

    fileprivate var indicatorView = UIView()

    fileprivate let activityIndicator = UIActivityIndicatorView()
    fileprivate let showingText = UILabel()

    init(style: UIActivityIndicatorViewStyle = .whiteLarge, color: UIColor = .white, text: String = "Please wait...", textColor: UIColor = .white) {
        self.activityIndicator.activityIndicatorViewStyle = style
        self.activityIndicator.color = color

        self.showingText.text = text
        self.showingText.textColor = textColor
        self.showingText.font = Constant.Font.helveticaBold
        self.showingText.textAlignment = .center
    }

    fileprivate func getBackgroundView() -> UIView {
        let background: UIView = UIView()
        background.backgroundColor = .darkGray
        background.alpha = 0.9

        return background
    }

    fileprivate func getIndicatorView() -> UIView {
        let indicatorView = self.getBackgroundView()

        // Add ActivityIndicator & Label
        indicatorView.addSubview(self.activityIndicator)
        indicatorView.addSubview(self.showingText)

        // Set Indicator & Label Constraint
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.centerXAnchor.constraint(equalTo: indicatorView.centerXAnchor).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: indicatorView.centerYAnchor).isActive = true

        self.showingText.translatesAutoresizingMaskIntoConstraints = false
        self.showingText.centerXAnchor.constraint(equalTo: self.activityIndicator.centerXAnchor).isActive = true
        self.showingText.centerYAnchor.constraint(equalTo: self.activityIndicator.centerYAnchor, constant: 50).isActive = true

        return indicatorView
    }

    func startAnimating() {
        self.indicatorView = self.getIndicatorView()
        self.keyWindow.addSubview(self.indicatorView)

        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.topAnchor.constraint(equalTo: self.keyWindow.topAnchor).isActive = true
        indicatorView.bottomAnchor.constraint(equalTo: self.keyWindow.bottomAnchor).isActive = true
        indicatorView.leadingAnchor.constraint(equalTo: self.keyWindow.leadingAnchor).isActive = true
        indicatorView.trailingAnchor.constraint(equalTo: self.keyWindow.trailingAnchor).isActive = true

        self.activityIndicator.startAnimating()
    }

    func stopAnimating() {
        self.activityIndicator.stopAnimating()
        self.indicatorView.removeFromSuperview()
    }
}
