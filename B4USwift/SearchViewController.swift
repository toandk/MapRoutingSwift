//
//  SearchViewController.swift
//  B4USwift
//
//  Created by admin on 12/6/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import ReactiveCocoa
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var yourLocationButton: UIButton!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var historyView: UIView!
    
    var searchBinder: TableViewBindingHelper?
    var historyBinder: TableViewBindingHelper?
    var completionBlock: DTSearchBlock?
    var viewModel: SearchViewModel!
    
    class func showInViewController(viewController: UIViewController, viewModel: SearchViewModel, completionBlock: DTSearchBlock) -> SearchViewController {
        let picker = SearchViewController(viewModel: viewModel)
        picker.completionBlock = completionBlock
        viewController.navigationController?.pushViewController(picker, animated: true)
        return picker
    }

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SearchViewController", bundle: nil)
        edgesForExtendedLayout = .None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupDefaultUI()
        bindViewModel()
        bindTableView()
        handleResult()
    }
    
    func setupDefaultUI() {
        searchTextField.becomeFirstResponder()
        if (viewModel.defaultPlace != nil) {
            if (LocationManager.sharedManager.isCurrentLocation(viewModel.defaultPlace!.coordinate!)) {
                searchTextField.text = "Your location"
            }
            else {
                searchTextField.text = self.viewModel.defaultPlace!.name;
            }
            resultView.hidden = false;
        }
        yourLocationButton.hidden = self.viewModel.currentPlace == nil;
        let posY = self.viewModel.currentPlace != nil ? yourLocationButton.frame.origin.y + yourLocationButton.frame.size.height :
        yourLocationButton.frame.origin.y;
        resultView.frame = CGRectMake(resultView.frame.origin.x, posY, resultView.frame.size.width, self.view.frame.size.height - posY - 10);
        historyView.frame = CGRectMake(historyView.frame.origin.x, posY + 10, historyView.frame.size.width, self.view.frame.size.height - posY - 20);
    }
    
    func bindTableView() {
        searchBinder = TableViewBindingHelper(tableView: resultTableView,
                           sourceSignal: RACObserve(viewModel, keyPath: "searchResults"),
                           nibName: "SearchTableViewCell",
                           selectionCommand: viewModel.getSelectionAddressCommand())
        historyBinder = TableViewBindingHelper(tableView: historyTableView,
                            sourceSignal: RACObserve(viewModel, keyPath: "searchHistories"),
                            nibName: "SearchHistoryCell",
                            selectionCommand: viewModel.getSelectionHistorySearchCommand())
    }
    
    func bindViewModel() {
        searchTextField.rac_textSignal() ~> RAC(viewModel, "searchText")
        viewModel.validSearchSignal!.not() ~> RAC(resultView, "hidden")
        viewModel.executeSearchCommand.executionSignals.subscribeNext { (obj: AnyObject!) in
            
        }
        yourLocationButton.rac_command = viewModel.getChoosingCurrentLocationCommand()
    }
    
    
    func handleResult() {
        RACObserve(viewModel, keyPath: "selectedPlace")
            .deliverOn(RACScheduler.mainThreadScheduler())
            .subscribeNext { (obj: AnyObject!) in
                if (self.viewModel.selectedPlace != nil) {
                    self.completionBlock?(self.viewModel.selectedPlace, nil)
                    self.closeAction(nil)
                }
            }
    }
    
    @IBAction func closeAction(sender: AnyObject?) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func chooseOnMapAction(sender: AnyObject?) {
        self.view.endEditing(true)
        var center = LocationManager.sharedManager.currentLocation
        if (center!.longitude == 0 && center!.latitude == 0) {
            center = CLLocationCoordinate2DMake(DEFAULT_LATITUDE, DEFAULT_LONGITUDE);
        }
        let northEast = CLLocationCoordinate2DMake(center!.latitude + 0.01,
                                                                      center!.longitude + 0.01);
        let southWest = CLLocationCoordinate2DMake(center!.latitude - 0.01,
                                                                      center!.longitude - 0.01);
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)
        placePicker.pickPlaceWithCallback({ (place: GMSPlace?, error: NSError?) in
            if (place != nil) {
                let newPlace = DTPlace(place: place!)
                self.completionBlock?(newPlace, nil)
                self.closeAction(nil)
            }
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
