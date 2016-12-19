//
//  SearchViewModel.swift
//  B4USwift
//
//  Created by admin on 12/6/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import ReactiveCocoa
import GooglePlaces

class SearchViewModel: NSObject {
    dynamic var searchText: String! = ""
    var executeSearchCommand: RACCommand!
    var validSearchSignal: RACSignal!
    dynamic var searchResults: Array<AnyObject> = []
    dynamic var searchHistories: Array<AnyObject> = []
    dynamic var selectedPlace: DTPlace?
    var defaultPlace: DTPlace?
    var currentPlace: DTPlace?
    var searchServices: SearchServices?
    
    init(services: SearchServices, model: DTPlace?) {
        super.init()
        searchServices = services
        defaultPlace = model
        initialize()
    }
    
    func initialize() {
        validSearchSignal = RACObserve(self, keyPath: "searchText")
            .distinctUntilChanged()
            .mapAs { (text: NSString) -> NSNumber in
                return text.length > 1
            }
        validSearchSignal.subscribeNext({ (object: AnyObject!) in
            if (object.boolValue!) {
                self.executeSearchSignal().subscribeNext({ (object: AnyObject!) in
                    
                })
            }
        })
        executeSearchCommand = RACCommand(enabled: validSearchSignal, signalBlock: { (object: AnyObject!) -> RACSignal! in
            return self.executeSearchSignal()
        })
        getSearchHistory()
    }
    
    func getSearchHistory() {
        searchHistories = SearchRecentModelFactory.getListSavedRecentModel()
    }
    
    func executeSearchSignal() -> RACSignal {
        return searchServices!.getSearchSignalWithKeyword(searchText)
            .doNext({ (object: AnyObject!) in
//                    print("search results: " + object.description)
                    self.searchResults = object as! [AnyObject]
                })
    }
    
    func getSelectionAddressCommand() -> RACCommand {
        return RACCommand(signalBlock: { (input: AnyObject!) -> RACSignal! in
            let place = input as! GMSAutocompletePrediction
            SearchRecentModelFactory.saveSearchPrediction(place)
            return self.searchServices!.getPlaceInfoSignalWithPlace(place.placeID!)
                .doNext({ (object: AnyObject!) in
                        self.selectedPlace = DTPlace(place: object as! GMSPlace)
                    })
        })
    }
    
    
    func getSelectionHistorySearchCommand() -> RACCommand {
        return RACCommand(signalBlock: { (input: AnyObject!) -> RACSignal! in
            let place = input as! SearchRecentModel
            return self.searchServices!.getPlaceInfoSignalWithPlace(place.placeID)
                .doNext({ (object: AnyObject!) in
                    self.selectedPlace = DTPlace(place: object as! GMSPlace)
                })
        })
    }
    
    func getChoosingCurrentLocationCommand() -> RACCommand {
        return RACCommand(signalBlock: { (input: AnyObject!) -> RACSignal! in
            self.selectedPlace = self.currentPlace
            return RACSignal.empty()
        })
    }
}
