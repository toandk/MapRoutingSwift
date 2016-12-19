//
//  SearchRecentModelFactory.swift
//  B4USwift
//
//  Created by admin on 12/6/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import RealmSwift
import GooglePlaces

class SearchRecentModelFactory: NSObject {
    
    class func getListSavedRecentModel() -> [SearchRecentModel] {
        let realm = try! Realm()
        let list = realm.objects(SearchRecentModel.self)
        var listRecent = [SearchRecentModel]()
        for i in 0 ..< list.count {
            listRecent.append(list[i])
        }
        return listRecent
    }
    
    class func isSearchPredictionExisted(prediction: GMSAutocompletePrediction) -> Bool {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "placeID == %@", prediction.placeID!)
        let list = realm.objects(SearchRecentModel.self).filter(predicate)
        return list.count > 0
    }
    
    class func saveSearchPrediction(prediction: GMSAutocompletePrediction) {
        if isSearchPredictionExisted(prediction) {
            return;
        }
        let realm = try! Realm()
        try! realm.write() {
            let model = realm.create(SearchRecentModel.self)
            model.setup(prediction)
            realm.add(model)
        }
        
        
    }

}
