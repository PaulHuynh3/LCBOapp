//
//  DetailViewController.m
//  LCBO App
//
//  Created by Paul on 2017-11-20.
//  Copyright © 2017 Paul. All rights reserved.
//

#import "DetailViewController.h"
@import MapKit;
#import "LocationManager.h"
#import "NetworkRequest.h"

@interface DetailViewController ()<MKMapViewDelegate, CoreLocationDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property LocationManager* locationManager;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    //create instance of locationManager that will have the same properties as the one created in locationmanager.m
    self.locationManager = [[LocationManager alloc]init];
    //set it as the delegate of locationManager
    self.locationManager.locationDelegate = self;
    //annotations
    self.mapView.delegate = self;

}

-(void)configureView{
    self.imageView.image = self.product.image;
    self.productNameLabel.text = self.product.name;
}

-(void)passCurrentLocation:(CLLocation *)location{
    [NetworkRequest queryNearestLocationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude product:self.product.productID display:5 complete:^(NSArray<Store*> *results) {
       
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [self.mapView addAnnotation: results];
            
            self.mapView.showsUserLocation = YES;
            [self.mapView showAnnotations:results animated:YES];
        }];
        
    }];
    
    
}





@end
