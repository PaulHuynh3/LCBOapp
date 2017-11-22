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

+ (void)queryPromotionalProduct:(void (^)(NSArray<Product*> *))complete {
    
    NSURL *query = [NSURL URLWithString:[NSString stringWithFormat:@"https://lcboapi.com/products?where=has_value_added_promotion&order=price_in_cents.desc"]];
    
    //Identification (API key) else we would have to put it in the query.
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:query];
    [request addValue:[NSString stringWithFormat:@"Token token=%@",LCBO_KEY] forHTTPHeaderField:@"Authorization"];
    
    
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
        
        for (NSDictionary *productInfo in result[@"result"]){
         
            [products addObject:[[Product alloc]initWithalcoholInfo:productInfo]];
        }
        //save the mutablearray of dictionary items to completionhandler.
        complete(products);
        
    }];
    //always resume download task to continue while block is retrieving information.
    [downloadTask resume];
    
}

+(void)loadImageForPhoto:(Product *)photo complete:(void (^)(UIImage *))complete{
    
    NSURLSessionTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:[photo loadImageURL]completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil){
            NSLog(@"error in url session:%@",error.localizedDescription);
            return;
        }
        
        if (((NSHTTPURLResponse*)response).statusCode >= 300){
            NSLog(@"unexpected http response: %@",response);
            return;
        }
        
        UIImage *image = [UIImage imageWithData:data];
        
        complete(image);
        
    }];
    
    [downloadTask resume];
}

+(void)queryLimitedTimeOffer:(void (^)(NSArray<Product*> *))complete{
    
    
    NSURL* query = [NSURL URLWithString:[NSString stringWithFormat:@"https://lcboapi.com/products?where=has_limited_time_offer&order=price_in_cents.desc"]];
    
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:query];
    [request addValue:[NSString stringWithFormat:@"Token token=%@",LCBO_KEY] forHTTPHeaderField:@"Authorization"];

    
    NSURLSessionTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        //check error
        if (error != nil){
            NSLog(@"%@",error.localizedDescription);
            abort();
        }
        
        //check if status code is greater than 300
        if (((NSHTTPURLResponse*)response).statusCode >= 300){
            NSLog(@"error in response= %@",response);
            abort();
        }
        
        NSError* err = nil;
        NSDictionary* results = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
        
        NSMutableArray <Product*>* limitedProduct = [[NSMutableArray alloc]init];
        for (NSDictionary* aProduct in results[@"result"]){
            [limitedProduct addObject:[[Product alloc]initWithalcoholInfo:aProduct]];
        }
        //save array to completion handler
        complete(limitedProduct);
        
    }];
    //resumes the task to mainthread.
    [downloadTask resume];
}

+(void)queryKosherProduct:(void (^)(NSArray<Product*> *))complete{
    
    NSURL* query = [NSURL URLWithString:[NSString stringWithFormat:@"https://lcboapi.com/products?where=Is_kosher"]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:query];
    [request addValue:[NSString stringWithFormat:@"Token token=%@",LCBO_KEY] forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionTask* downloadTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        if (error != nil){
            NSLog(@"There is an error: %@",error.localizedDescription);
            abort();
        }
        
        if (((NSHTTPURLResponse*)response).statusCode >= 300){
            NSLog(@"The statuse code error:%@",response);
            abort();
        }
        
        NSError * err = nil;
        NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
        
        NSMutableArray <Product*>*kosherProducts = [[NSMutableArray alloc]init];
        
        for (NSDictionary* item in result[@"result"]){
            
            [kosherProducts addObject:[[Product alloc]initWithalcoholInfo:item]];
        }
        
        complete(kosherProducts);
        
    }];
    [downloadTask resume];
    
}

+(void)queryAllProducts:(void (^)(NSArray<Product*> *))complete{
    
    NSURL* query = [NSURL URLWithString:[NSString stringWithFormat:@"https://lcboapi.com/products?where_not=is_dead&per_page=100&page=1"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:query];
    
    [request addValue:[NSString stringWithFormat:@"Token token=%@", LCBO_KEY] forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionTask *downloadTask = [[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(error != nil){
            NSLog(@"The error is %@",error.localizedDescription);
            return;
        }
        
        if (((NSHTTPURLResponse*)response).statusCode >= 300){
            NSLog(@"there is an error with the response %@",response);
            return;
        }
       
        NSError* err = nil;
        NSMutableArray<Product*>* results = [[NSMutableArray alloc]init];
        NSDictionary* info = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
        
        for(NSDictionary*dict in info[@"result"]){
            
            [results addObject:[[Product alloc]initWithalcoholInfo:dict]];
        }
        
        complete(results);
        
    }];
    
    [downloadTask resume];
}

+(void)queryNearestLocationWithLatitude:(double)latitude longitude:(double)longitude product:(int)productID display:(int)showStores complete:(void (^)(NSArray<Store*> *results))complete{
    
    NSURL* query = [NSURL URLWithString:[NSString stringWithFormat:@"https://lcboapi.com/stores?lat=%f&lon=%f&product_id=%i",latitude,longitude,productID]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:query];
    [request addValue:[NSString stringWithFormat:@"Token token=%@",LCBO_KEY] forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        if (error != nil){
            NSLog(@"The error is %@",error.localizedDescription);
            return;
        }
        
        if (((NSHTTPURLResponse*)response).statusCode >= 300){
            NSLog(@"Error in response %@",response);
            return;
        }
        
        NSError* err = nil;
        NSMutableArray <Store*> *stores;
        
        NSDictionary* results = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
        
        for(NSDictionary*info in results[@"result"]){
            
            [stores addObject:[[Store alloc]initWithInfo:info]];
        }
        
        //option with how many stores should be displayed.
        NSArray *numberStores = [stores subarrayWithRange:NSMakeRange(0, MIN(showStores, stores.count)) ];
        
        complete(numberStores);
        
    }];
    [downloadTask resume];
    
    
}




@end


