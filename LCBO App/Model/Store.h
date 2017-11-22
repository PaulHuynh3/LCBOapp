//
//  Store.h
//  LCBO App
//
//  Created by Paul on 2017-11-22.
//  Copyright © 2017 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

//need to make sure that store inherits annotation so we can set it to display it.
@interface Store : NSObject <MKAnnotation>

@property double latitude;
@property double longitude;
@property (nonatomic) NSString *intersection;
@property (nonatomic) NSString *address;
@property NSDictionary* info;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


-(instancetype)initWithInfo:(NSDictionary*)info;

@end
