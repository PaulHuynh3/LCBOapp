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

+(void)queryLocationProduct:(double)latitude longitude:(double)longitude product:(int)productId display:(int)stores complete:(void (^)(NSArray<Store*>*))complete{
    
    //return only stores that have product_id of seasonal products have to make this link dynamic so that when my seasonal products are returned with these ids..
    NSURL *queryURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://lcboapi.com/stores?lat=%f&lon=%f&product_id=%i",latitude,longitude,productId]];
    
    //header for website
    NSMutableURLRequest *reqWithHeader = [NSMutableURLRequest requestWithURL:queryURL];
    [reqWithHeader addValue:[NSString stringWithFormat:@"Token token=%@",LCBO_KEY] forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:reqWithHeader completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        //happening inside this block of code.
        // this is where we get the results
        if (error != nil) {
            NSLog(@"error in url session: %@", error.localizedDescription);
            return; // TODO: display an alert or something
        }
        // TODO: check the response code we got; if it's >= 300 something is wrong
        // remember to check status code, we need to cast response to a NSHTTPURLResponse
        if (((NSHTTPURLResponse*)response).statusCode >= 300) {
            NSLog(@"Unexpected http response: %@", response);
            return; // TODO: display an alert or something
        }
        
        NSError *err = nil;
        NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
        if (err != nil) {
            NSLog(@"Something went wrong parsing JSON: %@", err.localizedDescription);
            abort();
        }
        //short way of doing [[NSMutableArray alloc]init];
        NSMutableArray<Store*> *locationArray = [@[] mutableCopy];
        
        
        for (NSDictionary *locationInfo in result[@"result"]) {
            
            [locationArray addObject:[[Store alloc]initWithInfo:locationInfo]];
            
        }
        
        //providing option to show how many stores should be displayed.
        NSArray *numberOfStores = [locationArray subarrayWithRange:NSMakeRange(0, MIN(stores, locationArray.count))];
        
        //save the mutable array to the completion block.
        complete(numberOfStores);
        
    }];
    //always set after block to make sure the program continues to run while block is retriving data.
    [task resume];
    
}




@end


