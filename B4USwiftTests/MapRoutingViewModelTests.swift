//
//  MapRoutingViewModelTests.m
//  MapRouting
//
//  Created by admin on 8/23/16.
//  Copyright © 2016 admin. All rights reserved.
//

import Quick
import Nimble
import CoreLocation

class MapRTViewModelSpec : QuickSpec {
    override func spec() {
        var viewModel = HomeViewModel()
        
        describe("Initialize") {
            it("has everything you need to get started") {
                
                expect(viewModel.transportMode).to(equal("Driving"))
                expect(viewModel.currentPlaceCommand).to(beTruthy())
                expect(viewModel.reverseDirectionCommand).to(beTruthy())
                expect(viewModel.loadMapRoutingCommand).to(beTruthy())
            }
            
//            context("if it doesn't have what you're looking for") {
//                it("needs to be updated") {
//                    let you = You(awesome: true)
//                    expect{you.submittedAnIssue}.toEventually(beTruthy())
//                }
//            }
        }
        
        describe("reverse direction") {
            let stopPlace = DTPlace()
            let startPlace = DTPlace()
            stopPlace.coordinate = CLLocationCoordinate2DMake(20.972324, 105.884813)
            startPlace.coordinate = CLLocationCoordinate2DMake(21.001315, 105.817504)
            let viewModel2 = HomeViewModel()
            viewModel2.startPlace = startPlace
            viewModel2.stopPlace = stopPlace
            it("Should assert that reverse start and stop place is ok") {
                _ = try! viewModel2.reverseDirectionCommand!.execute(nil).asynchronouslyWaitUntilCompleted()
//                expect(success).to(beTrue())
                expect(viewModel2.startPlace).to(equal(stopPlace))
                expect(viewModel2.stopPlace).to(equal(startPlace))
            }
        }
        
        describe("Load map routing") { 
            let stopPlace = DTPlace()
            let startPlace = DTPlace()
            stopPlace.coordinate = CLLocationCoordinate2DMake(20.972324, 105.884813)
            startPlace.coordinate = CLLocationCoordinate2DMake(21.001315, 105.817504)
            
            viewModel = HomeViewModel()
            
            it ("Should assert that encodedRoutingPoints is found") {
                viewModel.encodedRoutingPoints = NO_ROUTE_KEY
                viewModel.startPlace = startPlace
                viewModel.stopPlace = stopPlace
                let resultSignal = viewModel.loadingMapRoutingSignal
                _ = try! resultSignal?.asynchronouslyWaitUntilCompleted()
                expect(viewModel.mapBounds).to(beTruthy())
                expect(viewModel.encodedRoutingPoints).notTo(equal(NO_ROUTE_KEY))
            }
            
            it ("Should assert that encodedRoutingPoints is NO_ROUTE_KEY") {
                viewModel.transportMode = "Transit"
                stopPlace.coordinate = CLLocationCoordinate2DMake(34.112603, -118.283608);
                viewModel.startPlace = startPlace;
                viewModel.stopPlace = stopPlace;
        
                _ = try! viewModel.loadingMapRoutingSignal!.asynchronouslyWaitUntilCompleted()
                expect(viewModel.encodedRoutingPoints).to(equal(NO_ROUTE_KEY))
            }
        }
    }
}
