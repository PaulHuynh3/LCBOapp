//
//  Alcohol.h
//  LCBO App
//
//  Created by Paul on 2017-11-17.
//  Copyright © 2017 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface Product : NSObject
@property NSString* name;
@property NSString* urlImage;

@property UIImage* alcoholImage;

-(instancetype)initWithalcoholInfo:(NSDictionary*)info;


@end
