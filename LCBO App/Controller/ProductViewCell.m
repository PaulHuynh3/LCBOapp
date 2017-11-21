//
//  ProductViewCell.m
//  LCBO App
//
//  Created by Paul on 2017-11-19.
//  Copyright © 2017 Paul. All rights reserved.
//

#import "ProductViewCell.h"

@interface  ProductViewCell()

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;

@end

@implementation ProductViewCell

-(void)setProduct:(Product *)product{
    _product = product;
    
    [NetworkRequest loadImageForPhoto:product complete:^(UIImage *result) {

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //set the product's image property to this result. so i can use it again for the dvc without having to do another network request.
            product.image = result;
            
            self.productImageView.image = product.image;
            self.productNameLabel.text = product.name;

        }];
    }];
    

    
}

@end
