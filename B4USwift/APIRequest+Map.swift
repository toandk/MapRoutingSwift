//
//  APIRequest+Map.swift
//  B4USwift
//
//  Created by admin on 12/7/16.
//  Copyright © 2016 admin. All rights reserved.
//

import Foundation
import CoreLocation

let GET_MAP_DIRECTIONS = "https://maps.googleapis.com/maps/api/directions/json"
let SEARCH_PLACES       = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
let SEARCH_PLACES_AUTOCOMPLETE              = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
let QUERY_PLACES_AUTOCOMPLETE               = "https://maps.googleapis.com/maps/api/place/autocomplete/json"

extension APIRequest {
    
    static func getMapDirection(startPoint: DTPlace, stopPoint: DTPlace, mode: String, completionHandler: APIResponseBlock) {
        let params = ["origin": "\(startPoint.coordinate!.latitude),\(startPoint.coordinate!.longitude)",
                      "destination": "\(stopPoint.coordinate!.latitude),\(stopPoint.coordinate!.longitude)",
                      "mode": mode,
                      "key": GOOGLE_MAP_API_KEY]
        requestWithUrl(GET_MAP_DIRECTIONS, param: params, method: "GET", completion: completionHandler)
    }
    
    
    
    static func searchFirstPlaceWithLocation(location: CLLocationCoordinate2D, completionHandler: APIResponseBlock) {
        let params = ["language": "vi",
                      "location": "\(location.latitude),\(location.longitude)",
                      "key": GOOGLE_MAP_API_KEY,
                      "radius": "100",
                      "ranky": "distance",
                      "type": "establishment"]
        requestWithUrl(SEARCH_PLACES, param: params, method: "GET", completion: completionHandler)
    }

}
