MapRouting
================

Note: This is Swift version of https://github.com/toandk/MapRouting

================
This is a simple iPhone app allows user to choose 2 places on the map and draw a direction route between them. The UX, UI is based on Google Maps application on iOS.

Main features:

- Choose starting point/destination by searching place name, address.  
- Choose starting point/destination by selecting on the map.
- Choose starting point/destination by using current location (while enabling location service)
- Choose transporting method: driving, transit, walking or bicycling
- Choose places from search recent history
- Draw routing path on the map base on starting point/destination and transporting mode
- Swap starting point and destination location


App using map and places data of GoogleMaps [SDK for iOS](https://developers.google.com/maps/documentation/ios-sdk/)

Code using MVVM design patern, bases on [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) library for Objective-C. Unit tests using [Specta](https://github.com/specta/specta) and [Expecta](https://github.com/specta/expecta)

![image](https://github.com/toandk/MapRouting/blob/master/gif/mr2.gif?raw=true)

### Compatibility
Support iOS 8.0+
