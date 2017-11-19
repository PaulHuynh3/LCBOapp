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

+ (void)queryProductComplete:(void (^)(NSArray<Product*> *))complete {
    
    NSURL *query = [NSURL URLWithString:[NSString stringWithFormat:@"https://lcboapi.com/products?has_value_added_promotion&order=price_in_cents.desc"]];
    
    //Identification (API key) else we would have to put it in the query.
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:query];
    [request addValue:[NSString stringWithFormat:@"Token token =%@",LCBO_KEY] forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //perform error checking
        if (error != nil){
            NSLog(@"error in url session: %@",error.localizedDescription);
            abort(); //todo display an alert..
        }
        //check response code we receive if its >= 300 something is wrong
        if (((NSHTTPURLResponse*)response).statusCode >= 300) {
            NSLog(@"Unexpected http response %@", response);
            abort();
        }
        
        //begin the download.
        NSError *err = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
        
        if (err != nil) {
            NSLog(@"Something went wrong with parsing JSON: %@", err.localizedDescription);
            abort();
        }
        
        NSMutableArray<Product*> *products = [[NSMutableArray alloc]init];
        
        for (NSDictionary *productInfo in result){
         
            [products addObject:[[Product alloc]initWithalcoholInfo:productInfo]];
        }
        //save the mutablearray of dictionary items to completionhandler.
        complete(products);
        
    }];
    //always resume download task to continue while block is retrieving information.
    [downloadTask resume];
    
}


@end


