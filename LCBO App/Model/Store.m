//
//  Store.m
//  LCBO App
//
//  Created by Paul on 2017-11-22.
//  Copyright © 2017 Paul. All rights reserved.
//

#import "Store.h"

@implementation Store

-(instancetype)initWithInfo:(NSDictionary *)info{
    
    if(self = [super init]){
        _info = info;
        _latitude = [info[@"latitude"]doubleValue];
        _longitude = [info[@"longitude"]doubleValue];
        _address = info[@"name"];
        _intersection = info[@"address_line_1"];
    }
    return self;
}

-(CLLocationCoordinate2D)coordinate{
    
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

//override default properties of mkannotation and setting it as the title.
//title is mkannotation function
- (NSString *)title {
    return self.intersection;
}

//subtitle is also an annotation function.
- (NSString *)subtitle {
    return self.address;
}


@end
