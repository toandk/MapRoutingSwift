//
//  MapRoutingViewModelTests.m
//  MapRouting
//
//  Created by admin on 8/23/16.
//  Copyright © 2016 admin. All rights reserved.
//

import Quick
import Nimble

class MapRTViewModelSpec : QuickSpec {
    override func spec() {
        let viewModel = HomeViewModel()
        
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
            viewModel.startPlace = startPlace
            viewModel.stopPlace = stopPlace
//            it("Should assert that reverse start and stop place is ok") {
//                let resultSignal = viewModel.reverseDirectionCommand?.execute(nil)
//                _ = try resultSignal?.asynchronouslyWaitUntilCompleted()
////                expect(success).to(beTrue())
//                
//            }
            
            
        }
    }
}

//
//describe(@"reverse direction", ^{
//    __block DTPlace *stopPlace = nil;
//    __block DTPlace *startPlace = nil;
//    
//    beforeAll(^ {
//        viewModel = [[MapRoutingViewModel alloc] init];
//        startPlace = [[DTPlace alloc] init];
//        stopPlace = [[DTPlace alloc] init];
//        viewModel.startPlace = startPlace;
//        viewModel.stopPlace = stopPlace;
//    });
//    
//    it (@"Should assert that reverse start and stop place is ok", ^{
//        NSError *error = nil;
//        RACSignal *resultSignal = [viewModel.reverseDirectionCommand execute:nil];
//        BOOL success = [resultSignal asynchronouslyWaitUntilCompleted:&error];
//        expect(success).to.beTruthy();
//        expect(error).to.beNil();
//        expect(viewModel.startPlace).to.equal(stopPlace);
//        expect(viewModel.stopPlace).to.equal(startPlace);
//    });
//});
//
//describe(@"Load map routing", ^{
//    __block DTPlace *stopPlace = nil;
//    __block DTPlace *startPlace = nil;
//    
//    beforeAll(^ {
//        viewModel = [[MapRoutingViewModel alloc] init];
//        viewModel.encodedRoutingPoints = NO_ROUTE_KEY;
//        startPlace = [[DTPlace alloc] init];
//        startPlace.coordinate = CLLocationCoordinate2DMake(21.001315, 105.817504);
//        stopPlace = [[DTPlace alloc] init];
//        stopPlace.coordinate = CLLocationCoordinate2DMake(20.972324, 105.884813);
//    });
//    
//    it (@"Should assert that encodedRoutingPoints is found", ^{
//        viewModel.startPlace = startPlace;
//        viewModel.stopPlace = stopPlace;
//        
//        NSError *error = nil;
//        BOOL success = [viewModel.loadingMapRoutingSignal asynchronouslyWaitUntilCompleted:&error];
//        expect(success).to.beTruthy();
//        expect(error).to.beNil();
//        expect(viewModel.mapBounds).to.beTruthy();
//        expect(viewModel.encodedRoutingPoints).notTo.equal(NO_ROUTE_KEY);
//    });
//    
//    it (@"Should assert that encodedRoutingPoints is NO_ROUTE_KEY", ^{
//        viewModel.transportMode = DTTransportingModeTransit;
//        stopPlace.coordinate = CLLocationCoordinate2DMake(34.112603, -118.283608);
//        viewModel.startPlace = startPlace;
//        viewModel.stopPlace = stopPlace;
//        
//        NSError *error = nil;
//        BOOL success = [viewModel.loadingMapRoutingSignal asynchronouslyWaitUntilCompleted:&error];
//        expect(success).to.beTruthy();
//        expect(error).to.beNil();
//        expect(viewModel.encodedRoutingPoints).to.equal(NO_ROUTE_KEY);
//    });
//});
//
//SpecEnd
