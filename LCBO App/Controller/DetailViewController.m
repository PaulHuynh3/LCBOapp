//
//  DetailViewController.m
//  LCBO App
//
//  Created by Paul on 2017-11-20.
//  Copyright © 2017 Paul. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];

}

-(void)configureView{
    self.imageView.image = self.product.image;
    self.productNameLabel.text = self.product.name;
}




@end
