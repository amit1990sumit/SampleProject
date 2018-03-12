//
//  ProductMatrixViewController.h
//  SampleProject
//
//  Created by admin on 12/03/18.
//  Copyright © 2018 namdev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ProductMatrixViewController : BaseViewController<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *productCollectionView;
@end

