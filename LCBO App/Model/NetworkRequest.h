//
//  NetworkRequest.h
//  LCBO App
//
//  Created by Paul on 2017-11-18.
//  Copyright © 2017 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "Store.h"
#import "Secret.h"

@interface NetworkRequest : NSObject

+(void)queryPromotionalProduct:(void (^)(NSArray<Product*> *))complete;
+(void)loadImageForPhoto:(Product *)photo complete:(void (^)(UIImage *))complete;
+(void)queryLimitedTimeOffer:(void (^)(NSArray<Product*> *))complete;
+(void)queryKosherProduct:(void (^)(NSArray<Product*> *))complete;
+(void)queryAllProducts:(void (^)(NSArray<Product*> *))complete;

@end
