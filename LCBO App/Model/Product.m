//
//  Alcohol.m
//  LCBO App
//
//  Created by Paul on 2017-11-17.
//  Copyright © 2017 Paul. All rights reserved.
//

#import "Product.h"

@implementation Product

-(instancetype)initWithalcoholInfo:(NSDictionary *)info{
    if (self =[super init]){
    
        _name = info[@"name"];
        _urlImage = info[@"image_url"];
        if ([_urlImage isEqual:[NSNull null]]){
            _urlImage = nil;
        }
        _productID = [info[@"id"]intValue];
        
    }
    
    return self;
}

-(NSURL*)loadImageURL{
    
    return [NSURL URLWithString:self.urlImage];
}


@end
