//
//  SwiftLoading.swift
//  Ministry of Culture Public Art
//
//  Created by 乾太 on 2016/10/19.
//  Copyright © 2016年 乾太. All rights reserved.
//
//  # Show Overlay
//      -> LoadingView.shared.showOverlay(view: self.navigationController?.view)
//
//  # Hide Overlay
//      -> LoadingView.shared.hideOverlayView()
//

import UIKit
import Foundation

class SwiftLoading {
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: SwiftLoading {
        struct Static {
            static let instance: SwiftLoading = SwiftLoading()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView!) {
        overlayView = UIView(
            frame: UIScreen.main.bounds
        )
        overlayView.backgroundColor = UIColor(
            red: 0,
            green: 0,
            blue: 0,
            alpha: 0.5
        )
        activityIndicator = UIActivityIndicatorView(
            activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge
        )
        activityIndicator.center = overlayView.center
        overlayView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.addSubview(overlayView)
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }

}
