//
//  Helper.swift
//  DemoTapSDK
//
//  Created by Kokila Ekanayake on 8/2/23.
//

import UIKit

enum Storyboard: String {
    case Main
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}

extension UIViewController {
    
    static func storyboardInstantiate(in appStoryboard: Storyboard, identifier: String) -> Self {
        return appStoryboard.instance.instantiateViewController(withIdentifier: identifier) as! Self
    }
}
