//
//  Ad_BannerViewController.swift
//  Ad_BannerViewController
//
//  Created by 하창진 on 2021/08/03.
//

import UIKit
import SwiftUI
import GoogleMobileAds

struct Ad_BannerViewController : UIViewControllerRepresentable{
    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        let viewController = UIViewController()
        
        view.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeSmartBannerPortrait.size)
        view.load(GADRequest())
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
