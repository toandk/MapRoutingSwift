//
//  SearchServices.swift
//  B4USwift
//
//  Created by admin on 12/6/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import ReactiveCocoa

public typealias DTSearchBlock = (AnyObject?, NSError?) -> Void

class SearchServices: NSObject, GMSAutocompleteFetcherDelegate {
    
    var fetcher: GMSAutocompleteFetcher!
    var completionBlock: DTSearchBlock?
    
    override init() {
        super.init()
        setupFetcher()
    }
    
    func setupFetcher() {
        let filter = GMSAutocompleteFilter()
        let currentLocation = CLLocationCoordinate2DMake(DEFAULT_LATITUDE, DEFAULT_LONGITUDE)
        let neLocation = CLLocationCoordinate2DMake(currentLocation.latitude - 0.01, currentLocation.longitude - 0.01)
        let swLocation = CLLocationCoordinate2DMake(currentLocation.latitude + 0.01, currentLocation.longitude + 0.01)
        let bound = GMSCoordinateBounds(coordinate: neLocation, coordinate: swLocation)
        fetcher = GMSAutocompleteFetcher(bounds: bound, filter: filter)
        fetcher.delegate = self
    }
    
    func searchWithKeyword(keyword: String, completionBlock block: DTSearchBlock) {
        fetcher.sourceTextHasChanged(keyword)
        completionBlock = block
    }
    
    func getPlaceInfo(prediction: GMSAutocompletePrediction, comletionBlock block: DTSearchBlock) {
        GMSPlacesClient.sharedClient().lookUpPlaceID(prediction.placeID!) { (place: GMSPlace?, error: NSError?) -> Void in
            block(place, error)
        }
    }
    
    func getPlaceInfoSignalWithPlace(placeId: String) -> RACSignal {
        return RACSignal.createSignal({
            (subscriber: RACSubscriber!) -> RACDisposable! in
            
            GMSPlacesClient.sharedClient().lookUpPlaceID(placeId, callback: {  (place: GMSPlace?, error: NSError?) -> Void in
                if (error == nil) {
                    subscriber.sendNext(place)
                    subscriber.sendCompleted()
                }
                else {
                    subscriber.sendError(error)
                }
            })
            
            return RACDisposable(block: { })
        })
    }
    
    func getSearchSignalWithKeyword(keyword: String) -> RACSignal {
        return RACSignal.createSignal({
            (subscriber: RACSubscriber!) -> RACDisposable! in
            
            self.searchWithKeyword(keyword, completionBlock: { (object: AnyObject?, error: NSError?) in
                if (error == nil) {
                    subscriber.sendNext(object)
                    subscriber.sendCompleted()
                }
                else {
                    subscriber.sendError(error)
                }
            })
            return RACDisposable(block: { })
        })
    }
    
    func didAutocompleteWithPredictions(predictions: [GMSAutocompletePrediction]) {
        completionBlock!(predictions, nil)
    }
    
    func didFailAutocompleteWithError(error: NSError) {
        completionBlock!(nil, error)
    }
}
