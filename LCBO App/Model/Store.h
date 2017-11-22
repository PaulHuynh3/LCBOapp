//
//  Store.h
//  LCBO App
//
//  Created by Paul on 2017-11-22.
//  Copyright © 2017 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Store : NSObject

@property double latitude;
@property double longitude;
@property NSDictionary* info;


-(instancetype)initWithInfo:(NSDictionary*)info;

@end
