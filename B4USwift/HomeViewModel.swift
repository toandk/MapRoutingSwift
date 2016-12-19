//
//  HomeViewModel.swift
//  B4USwift
//
//  Created by admin on 12/6/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import ReactiveCocoa
import SwiftyJSON

enum DTTransportingMode: Int {
    case Driving = 0
    case Transit
    case Walking
    case Bicycling
}

class HomeViewModel: NSObject {
    
    dynamic var transportMode: String {
        didSet {
            if (startPlace != nil && stopPlace != nil) {
                loadMapRoutingCommand?.execute(nil)
            }
        }
    }
    dynamic var startPlace: DTPlace? {
        didSet {
            if (self.stopPlace != nil) {
                loadMapRoutingCommand?.execute(nil)
            }
        }
    }
    dynamic var stopPlace: DTPlace? {
        didSet {
            if (self.startPlace != nil) {
                loadMapRoutingCommand?.execute(nil)
            }
        }
    }
    dynamic var currentPlace: DTPlace?
    var currentPlaceCommand: RACCommand?
    var loadMapRoutingCommand: RACCommand?
    var reverseDirectionCommand: RACCommand?
    var loadingMapRoutingSignal: RACSignal?
    dynamic var encodedRoutingPoints: String?
    var mapBounds: [String: JSON]?
    
    
    override init() {
        transportMode = "Driving"
        super.init()
        initialize()
    }
    
    func initialize() {
        initReverseDirectionCommand()
        initCurrentPlaceCommand()
        initLoadingMapRoutingSignal()
        initMapRoutingCommand()
    }
    
    func initReverseDirectionCommand() {
        reverseDirectionCommand = RACCommand(signalBlock: { (obj: AnyObject!) -> RACSignal! in
            return self.getReverseDirectionSignal()
        })
    }
    
    func initCurrentPlaceCommand() {
        LocationManager.sharedManager.askingPermission()
        currentPlaceCommand = RACCommand(signalBlock: { (obj: AnyObject!) -> RACSignal! in
            return self.getCurrentPlaceSignal()
        })
    }
    
    func initMapRoutingCommand() {
        loadMapRoutingCommand = RACCommand(signalBlock: { (obj: AnyObject!) -> RACSignal! in
            return self.loadingMapRoutingSignal
        })
    }
    
    func initLoadingMapRoutingSignal() {
        loadingMapRoutingSignal = RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            let mode = self.transportMode
            APIRequest.getMapDirection(self.startPlace!, stopPoint: self.stopPlace!, mode: mode, completionHandler: { (error: NSError?, object: JSON?) in
                if (error == nil) {
                    if (object!["routes"].count > 0) {
                        let routes = object!["routes"].array
                        self.mapBounds = routes![0]["bounds"].dictionary
                        self.encodedRoutingPoints = routes![0]["overview_polyline"]["points"].string
                    }
                    else {
                        self.encodedRoutingPoints = NO_ROUTE_KEY
                    }
                    subscriber.sendNext(self.encodedRoutingPoints)
                    subscriber.sendCompleted()
                }
                else {
                    self.encodedRoutingPoints = NO_ROUTE_KEY
                    subscriber.sendError(error)
                }
            })
            return nil
        })
    }
    
    func changeLocation(location: CLLocationCoordinate2D, startPlace: Bool) {
        APIRequest.searchFirstPlaceWithLocation(location) { (error: NSError?, object: JSON?) in
            let newPlace = DTPlace()
            newPlace.coordinate = location
            if (object != nil) {
                newPlace.name = object!["name"].string
                newPlace.placeID = object!["place_id"].string
            }
            else {
                newPlace.name = "\(location.latitude), \(location.longitude)"
            }
            if (startPlace) {
                self.startPlace = newPlace
            }
            else {
                self.stopPlace = newPlace
            }
        }
    }
    
    
    func getReverseDirectionSignal() -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            let place = self.startPlace
            self.startPlace = self.stopPlace
            self.stopPlace = place
            subscriber.sendNext(true)
            subscriber.sendCompleted()
            return nil
        })
    }
    
    func getCurrentPlaceSignal() -> RACSignal {
        return RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            GMSPlacesClient.sharedClient().currentPlaceWithCallback({ (likelihoodList: GMSPlaceLikelihoodList?, error: NSError?) in
                if (likelihoodList?.likelihoods.count > 0) {
                    self.currentPlace = DTPlace(place: (likelihoodList?.likelihoods[0].place)!)
                    LocationManager.sharedManager.currentLocation = self.currentPlace?.coordinate
                    if (self.startPlace == nil) {
                        self.startPlace = self.currentPlace
                    }
                    subscriber.sendNext(self.startPlace)
                    subscriber.sendCompleted()
                }
            })
            return nil;
            
        })
    }
    
    func getAddressPickerViewModel(place: DTPlace?) -> SearchViewModel {
        let searchServices = SearchServices()
        let viewModel = SearchViewModel(services: searchServices, model: place)
        viewModel.currentPlace = self.currentPlace
        return viewModel
    }
}
