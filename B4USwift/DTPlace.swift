//
//  DTPlace.swift
//  B4USwift
//
//  Created by admin on 12/6/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class DTPlace: NSObject {
    var name: String?
    var placeID: String?
    var coordinate: CLLocationCoordinate2D?
    var phoneNumber: String?
    var formattedAddress: String?
    
    override init() {
        super.init()
    }
    
    init(place: GMSPlace) {
        super.init()
        name = place.name
        placeID = place.placeID
        coordinate = place.coordinate
        phoneNumber = place.phoneNumber
        formattedAddress = place.formattedAddress
    }
    
    func getAddress() -> String! {
        if (formattedAddress!.characters.count > 0) {
            return formattedAddress!
        }
        if (name!.characters.count > 0) {
            return name
        }
        return "\(coordinate?.latitude), \(coordinate?.longitude)"
    }
}
