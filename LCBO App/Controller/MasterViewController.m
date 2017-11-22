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
    
}

-(void)indexChange{
    switch (self.productSegmentedControl.selectedSegmentIndex) {
        case 0:{
            [NetworkRequest queryPromotionalProduct:^(NSArray<Product *> *results) {
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    self.products = results;
                    [self.collectionView reloadData];
                }];
            }];
        }
            
        case 1: {
            [NetworkRequest queryLimitedTimeOffer:^(NSArray<Product *> *results) {
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    self.products = results;
                    [self.collectionView reloadData];
                }];
            }];
        }
            
        case 2:{
            [NetworkRequest queryKosherProduct:^(NSArray<Product *> *results) {
                
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    self.products = results;
                    [self.collectionView reloadData];
                    
                }];
                
            }];
            
        }
            
        default:{
            NSLog(@"Error in segmented Control");
            break;
        }
    }
}


- (IBAction)indexChanged:(UISegmentedControl *)sender {
    [self indexChange];
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
        
        //another way setting the sender as the cell
        //        ProductViewCell *cell = (ProductViewCell*)sender;
        //        dvc.product = cell.product;
        
        dvc.product = self.products[self.collectionView.indexPathsForSelectedItems[0].row];
        
    }
    
    
    
}


@end
