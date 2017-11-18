//
//  NetworkRequest.m
//  LCBO App
//
//  Created by Paul on 2017-11-18.
//  Copyright © 2017 Paul. All rights reserved.
//

#import "NetworkRequest.h"


@interface NetworkRequest()

@property Product* alcoholProduct;

@end

@implementation NetworkRequest

+(void)queryProductComplete:(void (^)(NSArray<Product*> *))complete {
    
    NSURL *query = [NSURL URLWithString:[NSString stringWithFormat:@"https://lcboapi.com/products?has_value_added_promotion&order=price_in_cents.desc"]];
    
    //Identification (API key) else we would have to put it in the query.
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:query];
    [request addValue:[NSString stringWithFormat:@"Token token =%@",LCBO_KEY] forHTTPHeaderField:@"Authorization"];
    

    
}


@end


