//
//  DetailViewController.h
//  LCBO App
//
//  Created by Paul on 2017-11-20.
//  Copyright © 2017 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "Store.h"
#import "NetworkRequest.h"
#import "LocationManager.h"

@import MapKit;

@interface DetailViewController : UIViewController

@property Product* product;

@end
