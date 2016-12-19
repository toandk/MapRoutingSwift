//
//  SearchRecentModel.swift
//  B4USwift
//
//  Created by admin on 12/6/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import RealmSwift
import GooglePlaces

class SearchRecentModel: Object {
    dynamic var placeID = ""
    dynamic var name = ""
    dynamic var address = ""
    
    func setup(prediction: GMSAutocompletePrediction) {
        placeID = prediction.placeID!
        name = prediction.attributedPrimaryText.string
        address = (prediction.attributedSecondaryText?.string)!
    }
}
