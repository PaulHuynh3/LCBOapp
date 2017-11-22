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

@property(nonatomic, strong) CLLocationManager *clLocationManager;

@property(nonatomic, strong) CLLocation *lastLocation;
@end


@implementation LocationManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _clLocationManager = [[CLLocationManager alloc] init];
        _clLocationManager.delegate = self;
        //in initializer when this is created it will prompt user for location.
        [self requestLocationPermissionIfNeeded];
        
    }
    return self;
}

//prompt user to use their location
- (void)requestLocationPermissionIfNeeded {
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusNotDetermined) {
            // we can ask for it
            [self.clLocationManager requestWhenInUseAuthorization];
        } else if (status == kCLAuthorizationStatusAuthorizedAlways
                   || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            [self.clLocationManager requestLocation];
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
    
    //sets the location for the function to be used in dvc.
    [self.locationDelegate passCurrentLocation:location];
    
}


@end

