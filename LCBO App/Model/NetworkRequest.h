//
//  NetworkRequest.h
//  LCBO App
//
//  Created by Paul on 2017-11-18.
//  Copyright © 2017 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "Secret.h"

@interface NetworkRequest : NSObject

+ (void)queryProductComplete:(void (^)(NSArray<Product*> *))complete;

@end
