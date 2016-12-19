//
//  HomeViewController.swift
//  B4USwift
//
//  Created by admin on 12/6/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import ReactiveCocoa
import SwiftyJSON

class HomeViewController: UIViewController, GMSMapViewDelegate {
    @IBOutlet var myMapView: GMSMapView!
    @IBOutlet var startPointTextField: UITextField!
    @IBOutlet var stopPointTextField: UITextField!
    @IBOutlet var reverveDirectionButton: UIButton!
    @IBOutlet var listTransportButton: [UIButton]!
    
    var viewModel: HomeViewModel!
    var routingLine: GMSPolyline?
    
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "HomeViewController", bundle: nil)
        edgesForExtendedLayout = .None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        myMapView.myLocationEnabled = true
        myMapView.delegate = self
        setupDefaultLocation()
        bindViewModel()
    }
    
    func setupDefaultLocation() {
        centerMapWithCoordinate(CLLocationCoordinate2DMake(DEFAULT_LATITUDE, DEFAULT_LONGITUDE))
    }
    
    func bindViewModel() {
        RACObserve(self.viewModel, keyPath: "currentPlace")
            .ignore(nil)
            .deliverOn(RACScheduler.mainThreadScheduler())
            .subscribeNext { (obj: AnyObject!) in
                self.centerMapWithCoordinate(self.viewModel.currentPlace!.coordinate!)
                self.updateUI()
        }
        RACObserve(self.viewModel, keyPath: "startPlace")
            .deliverOn(RACScheduler.mainThreadScheduler())
            .subscribeNext { (obj: AnyObject!) in
                if (self.viewModel.startPlace != nil) {
                    self.centerMapWithCoordinate(self.viewModel.startPlace!.coordinate!)
                }
                self.updateUI()
        }
        RACObserve(self.viewModel, keyPath: "stopPlace")
            .deliverOn(RACScheduler.mainThreadScheduler())
            .subscribeNext { (obj: AnyObject!) in
                if (self.viewModel.startPlace == nil && self.viewModel.stopPlace != nil) {
                    self.centerMapWithCoordinate(self.viewModel.stopPlace!.coordinate!)
                }
                self.updateUI()
        }
        RACObserve(self.viewModel, keyPath: "encodedRoutingPoints")
            .ignore(nil)
            .deliverOn(RACScheduler.mainThreadScheduler())
            .subscribeNext { (obj: AnyObject!) in
                self.removeOldRoutingLine()
                self.drawMapRoutingWithPoints(obj as! String)
                if (self.viewModel.mapBounds != nil) {
                    self.centerMapToViewAllMarkers(self.viewModel.mapBounds!)
                }
                
        }
        
        reverveDirectionButton.rac_command = self.viewModel.reverseDirectionCommand;
        self.viewModel.currentPlaceCommand?.execute(nil)
    }
    
    func centerMapWithCoordinate(coordinate: CLLocationCoordinate2D) {
        if (coordinate.latitude == 0 && coordinate.longitude == 0) {
            return
        }
        let camera = GMSCameraPosition.cameraWithLatitude(coordinate.latitude, longitude: coordinate.longitude, zoom: 14)
        myMapView.camera = camera
    }
    
    func updateUI() {
        myMapView.clear()
        
        if (viewModel.startPlace != nil) {
            if LocationManager.sharedManager.isCurrentLocation((viewModel.startPlace?.coordinate)!) {
                startPointTextField.text = "Your location"
            }
            else {
                startPointTextField.text = viewModel.startPlace?.formattedAddress
            }
            let marker = GMSMarker(position: viewModel.startPlace!.coordinate!)
            marker.icon = UIImage(named: "location_pin_blue")
            marker.title = "Starting point"
            marker.map = myMapView
            marker.draggable = true
            marker.userData = "startingPoint"
            myMapView.selectedMarker = marker
        }
        else {
            startPointTextField.text = "";
        }
        if (self.viewModel.stopPlace != nil) {
            if (LocationManager.sharedManager.isCurrentLocation(viewModel.stopPlace!.coordinate!)) {
                stopPointTextField.text = "Your location"
            }
            else {
                stopPointTextField.text = viewModel.stopPlace?.formattedAddress
            }
            let marker = GMSMarker(position: viewModel.stopPlace!.coordinate!)
            marker.icon = UIImage(named: "location_pin")
            marker.title = "Destination"
            marker.map = myMapView
            marker.draggable = true
            marker.userData = "Destination"
            myMapView.selectedMarker = marker
        }
        else {
            stopPointTextField.text = "";
        }
    }
    
    func centerMapToViewAllMarkers(mapBounds: [String: JSON]) {
        let northeast = mapBounds["northeast"]!.dictionary!
        let southwest = mapBounds["southwest"]!.dictionary!
        let location1 = CLLocation(latitude: northeast["lat"]!.double! as CLLocationDegrees, longitude: northeast["lng"]!.double! as CLLocationDegrees)
        let location2 = CLLocation(latitude: southwest["lat"]!.double! as CLLocationDegrees, longitude: southwest["lng"]!.double! as CLLocationDegrees)
        
        let distance = location1.distanceFromLocation(location2);
        if (distance < 100) {
            centerMapWithCoordinate(location1.coordinate)
            return;
        }
        
        let bounds = GMSCoordinateBounds(coordinate: location1.coordinate, coordinate: location2.coordinate)
        myMapView.animateWithCameraUpdate(GMSCameraUpdate.fitBounds(bounds, withEdgeInsets: UIEdgeInsetsMake(100, 50, 200, 50)))
    }
    
    func removeOldRoutingLine() {
        routingLine?.map = nil;
        routingLine = nil;
    }
    
    func drawMapRoutingWithPoints(encodedPoints: String) {
        if (encodedPoints == NO_ROUTE_KEY) {
            let alert = UIAlertController.init(title: "Alert", message: "No route found!", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return;
        }
        
        let path = GMSPath(fromEncodedPath: encodedPoints)
        routingLine = GMSPolyline(path: path)
        routingLine!.strokeWidth = 6.0;
        
        switch (self.viewModel.transportMode) {
        case "Driving":
            routingLine!.strokeColor = UIColor(red: 0, green: 122.0/255, blue: 1.0, alpha: 1.0)
            break;
        case "Transit":
            routingLine!.strokeColor = UIColor(red:245.0/255, green: 166.0/255, blue: 35.0, alpha: 1.0)
            break;
        case "Walking":
            routingLine!.strokeColor = UIColor(red: 126.0/255, green: 211.0/255, blue: 33.0/255, alpha: 1.0)
            break;
        case "Bicycling":
            routingLine!.strokeColor = UIColor(red: 144.0/255, green: 19.0/255, blue: 254.0/255, alpha: 1.0)
            break;
        default:
            break;
        }
        
        routingLine!.map = self.myMapView
    }
    
    @IBAction func pickAddressAction(sender: UIButton) {
        let tag = sender.tag;
        let place = (tag == 0) ? self.viewModel.startPlace : self.viewModel.stopPlace;
        let searchViewModel = viewModel.getAddressPickerViewModel(place)
        SearchViewController.showInViewController(self, viewModel: searchViewModel) { (obj: AnyObject?, error: NSError?) in
            if (error == nil) {
                if (tag == 0) {
                    self.viewModel.startPlace = obj as? DTPlace
                }
                else {
                    self.viewModel.stopPlace = obj as? DTPlace
                }
            }
        }
    }
    
    @IBAction func changeTransportAction(sender: UIButton) {
        let tag = sender.tag
        for button in listTransportButton {
            if (button.tag == tag) {
                button.tintColor = UIColor(red: 0, green: 122.0/255, blue: 1.0, alpha: 1.0)
            }
            else {
                button.tintColor = UIColor(red: 190.0/255, green: 213.0/255, blue: 251.0, alpha: 1.0)
            }
        }
        self.viewModel.transportMode = ["Driving", "Transit", "Walking", "Bicycling"][tag]
    }
    
    @IBAction func showCurrentLocation(sender: AnyObject) {
        LocationManager.sharedManager.askingPermission()
        let location = LocationManager.sharedManager.currentLocation
        if location?.longitude != 0 && location?.latitude != 0 {
            myMapView.animateToLocation(location!)
        }
    }
    
    func mapView(mapView: GMSMapView, didEndDraggingMarker marker: GMSMarker) {
        if marker.userData as! String == "startingPoint" {
            viewModel.changeLocation(marker.position, startPlace: true)
        }
        else {
            viewModel.changeLocation(marker.position, startPlace: false)
        }
    }

}
