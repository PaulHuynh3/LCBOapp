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
        
    }
    return self;
}

@end
