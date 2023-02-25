//
//  Google.swift
//  Tracker
//
//  Created by Daniel Au on 2023-02-17.
//

import Foundation
import SwiftUI

class Google {
    public static var viewController: UIViewController {
        var rootController = UIApplication.shared.windows.first?.rootViewController ?? UIViewController()
//        while let presented = UIViewController().presentedViewController {
//            rootController = presented
//        }
        return rootController
    }
}
