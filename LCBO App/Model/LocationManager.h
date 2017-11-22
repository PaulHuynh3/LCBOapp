//
//  LocationManager.h
//  LCBO App
//
//  Created by Paul on 2017-11-22.
//  Copyright © 2017 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@protocol CoreLocationDelegate <NSObject>

- (void)passCurrentLocation:(CLLocation*)location;

@end

@interface LocationManager : NSObject

@property (nonatomic) id<CoreLocationDelegate> locationDelegate;


@end
