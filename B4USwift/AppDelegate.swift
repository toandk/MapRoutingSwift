//
//  AppDelegate.swift
//  B4USwift
//
//  Created by admin on 12/6/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        let viewModel = HomeViewModel()
        let viewController = HomeViewController(viewModel: viewModel)
        navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBarHidden = true
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        
        setupGGMap()
        
        return true
    }
    
    func setupGGMap() {
        GMSServices.provideAPIKey("AIzaSyAw1R60pnySGfCQ-DXmmLNeFn-uPtK-7Ng")
        GMSPlacesClient.provideAPIKey("AIzaSyAw1R60pnySGfCQ-DXmmLNeFn-uPtK-7Ng")
    }
}

