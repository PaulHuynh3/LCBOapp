//
//  Alcohol.m
//  LCBO App
//
//  Created by Paul on 2017-11-17.
//  Copyright © 2017 Paul. All rights reserved.
//

#import "Alcohol.h"

@implementation Alcohol

-(instancetype)initWithalcoholname:(NSString *)name image:(UIImage *)image{
    if (self =[super init]){
        _name = name;
        _alcoholImage = image;
    }
    return self;
}

@end
