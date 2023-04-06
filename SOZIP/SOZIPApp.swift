//
//  SOZIPApp.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/11.
//

import SwiftUI
import Firebase
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

@main
struct SOZIPApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init(){
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        UIView.appearance().tintColor = UIColor(Color.accent)
        
        UITableView.appearance().backgroundColor = UIColor(Color.backgroundColor)
        UITableViewCell.appearance().backgroundColor = UIColor(Color.backgroundColor)
        UITableView.appearance().tableFooterView = UIView()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(helper: UserManagement())
        }
    }
}

extension Color{
    static let backgroundColor = Color("background")
    static let accent = Color("AccentColor")
    static let btn_color = Color("btnColor")
    static let txt_color = Color("txtColor")
    static let btn_dark = Color("btn_dark")
    static let txt_dark = Color("txt_dark")
    static let tutorial_color_1 = Color("tutorialColor_1")
    static let tutorial_color_2 = Color("tutorialColor_2")
    static let tutorial_color_3 = Color("tutorialColor_3")
    static let sozip_bg_1 = Color("SOZIP_BG_1")
    static let sozip_bg_2 = Color("SOZIP_BG_2")
    static let sozip_bg_3 = Color("SOZIP_BG_3")
    static let sozip_bg_4 = Color("SOZIP_BG_4")
    static let sozip_bg_5 = Color("SOZIP_BG_5")
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}

extension View {
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

extension String {
    init<S: Sequence>(unicodeScalars ucs: S)
        where S.Iterator.Element == UnicodeScalar
    {
        var s = ""
        s.unicodeScalars.append(contentsOf: ucs)
        self = s
    }
}

extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
