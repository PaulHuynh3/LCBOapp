//
//  LocationManager.m
//  LCBO App
//
//  Created by Paul on 2017-11-22.
//  Copyright © 2017 Paul. All rights reserved.
//

#import "LocationManager.h"
@import CoreLocation;

@interface LocationManager ()<CLLocationManagerDelegate>
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic,strong) CLLocation *lastLocation;
@end

@implementation LocationManager

- (instancetype)init
{
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc]init];
        //make it the delegate of cllocationmanager 
        _locationManager.delegate = self;
        //prompt user for location
        [self requestLocationPermissionIfNeeded];
        
    }
    return self;
}

- (void)requestLocationPermissionIfNeeded {
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusNotDetermined) {
            // we can ask for it
            [self.locationManager requestWhenInUseAuthorization];
        } else if (status == kCLAuthorizationStatusAuthorizedAlways
                   || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            [self.locationManager requestLocation];
        }
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"status changed to %d", status);
    //    [_clLocationManager startUpdatingLocation];
    //    [self.clLocationManager requestLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //    locationManager:didFailWithError:
    NSLog(@"%@", error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    //returns an array of user's locations set it to first one.
    CLLocation *location = locations.firstObject;
    
    //pass in the locationDelegate for DVC.
    [self.locationDelegate passCurrentLocation:location];
    
}

@end
