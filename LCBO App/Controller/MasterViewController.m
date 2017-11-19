//
//  MasterViewController.m
//  LCBO App
//
//  Created by Paul on 2017-11-19.
//  Copyright © 2017 Paul. All rights reserved.
//

#import "MasterViewController.h"
#import "Product.h"
#import "NetworkRequest.h"

@interface MasterViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSArray <Product*>* products;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NetworkRequest queryProductComplete:^(NSArray<Product *> *productList) {
        self.products = productList;
        [self.collectionView reloadData];
    }];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.products.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


@end
