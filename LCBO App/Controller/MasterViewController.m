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
#import "ProductViewCell.h"
#import "DetailViewController.h"

@interface MasterViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSArray <Product*>* products;
@property (weak, nonatomic) IBOutlet UISegmentedControl *productSegmentedControl;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NetworkRequest queryPromotionalProduct:^(NSArray<Product *> *productList) {
        //set the products array here with the query data.
        self.products = productList;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.collectionView reloadData];
        }];
        
    }];
    
}



- (IBAction)changeVarietyTapped:(UISegmentedControl *)sender {
    switch (self.productSegmentedControl.selectedSegmentIndex) {
        case 0:
            <#statements#>
            break;
            
        default:
            break;
    }
    
}


//MARK: Collectionview datasource.

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.products.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ProductViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    Product* alcoholProduct = self.products[indexPath.row];
    
    [cell setProduct:alcoholProduct];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"dvcSegue"]){
    DetailViewController* dvc = [segue destinationViewController];
        ProductViewCell *cell = (ProductViewCell*)sender;
        
        //set the dvc product property here.
        dvc.product = cell.product;
        
    }
    
    
    
}


@end
