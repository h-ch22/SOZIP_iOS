//
//  Ad_BannerViewController.swift
//  Ad_BannerViewController
//
//  Created by 하창진 on 2021/08/03.
//

import Foundation
import GoogleMobileAds
import SwiftUI
import UIKit

struct Ad_BannerViewController : UIViewControllerRepresentable{
    func makeUIViewController(context : Context) -> UIViewController{
        let view = GADBannerView(adSize : kGADAdSizeBanner)
        let viewController = UIViewController()
        
        view.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin : .zero, size : kGADAdSizeBanner.size)
        view.load(GADRequest())
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}
