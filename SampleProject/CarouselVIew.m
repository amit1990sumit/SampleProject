//
//  CarouselVIew.m
//  SampleProject
//
//  Created by admin on 12/03/18.
//  Copyright © 2018 namdev. All rights reserved.
//

#import "CarouselVIew.h"
#import "ImageCollectionView.h"
#import "UIImageView+WebCache.h"

#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)

@interface CarouselVIew()
@property(nonatomic,strong)NSArray *arrayImage;
@end

@implementation CarouselVIew

-(void)setImageArray:(NSArray*)arrayImage{
    _arrayImage = arrayImage;
    _collectionView.delegate = (id)self;
    _collectionView.dataSource = (id)self;
    [_collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionView"
                                                bundle:nil]
      forCellWithReuseIdentifier:@"ImageCollectionView"];
    self.pageControl.numberOfPages = _arrayImage.count;
    self.pageControl.hidesForSinglePage = true;
    
    [_collectionView reloadData];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma marks collection view delegate
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return _arrayImage.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH, 200);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageCollectionView *cell = nil;
    cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionView"
                                                             forIndexPath:indexPath];
   
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://media.redmart.com/newmedia/200p%@",[[_arrayImage objectAtIndex:indexPath.row] valueForKeyPath:@"name"]]]
                         placeholderImage:nil
                                  options:SDWebImageRetryFailed | SDWebImageLowPriority
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                    [cell.imgView setImage:image];
                                    if(cacheType == SDImageCacheTypeNone){
                                        [cell.imgView setAlpha:0.0];
                                        [UIView animateWithDuration:0.5 animations:^{
                                            [cell.imgView setAlpha:1.0];
                                        } completion:nil];
                                    }
                                }];
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    self.pageControl.currentPage = indexPath.row;
}


@end
