//
//  ProductMatrixViewController.m
//  SampleProject
//
//  Created by admin on 12/03/18.
//  Copyright © 2018 namdev. All rights reserved.
//

#import "ProductMatrixViewController.h"
#import "KNetworkAdapter.h"
#import "UIImageView+WebCache.h"
#import "KUtility.h"
#import "ProductMatrixGrid.h"
#import "ProductDetailViewController.h"
#import "KConstants.h"


#define PAGE_COUNT 10
#define MIN_SPACING 5



@interface ProductMatrixViewController ()<KNetworkAdapterDelegate>{
    dispatch_queue_t requestQueue;
    int pageCount;
    BOOL requestInProcess;
    
}
@property (nonatomic,strong)KNetworkAdapter *networkAdapter;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UILabel *cloud;
@property (weak, nonatomic) IBOutlet UILabel *temp;
@property (weak, nonatomic) IBOutlet UILabel *highAndLowTemp;
@property (weak, nonatomic) IBOutlet UILabel *humidity;
@property (weak, nonatomic) IBOutlet UIImageView *imgWeather;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSMutableArray *arrayProduct;
@end

@implementation ProductMatrixViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"PMP";
    [_productCollectionView registerNib:[UINib nibWithNibName:@"ProductMatrixGrid"
                                                       bundle:nil]
             forCellWithReuseIdentifier:@"ProductMatrixGridCellIdentifier"];
    _arrayProduct = [[NSMutableArray alloc] init];
    requestQueue = dispatch_queue_create("com.ssampleProject.mobile.pmpRequest", DISPATCH_QUEUE_SERIAL);
    [self requestForNextPage:PAGE_COUNT pageCount:0];

}
-(void)requestForNextPage:(NSInteger)pageSize pageCount:(NSInteger)pageCount1{
    
    [self showActivityIndicator];
    requestInProcess = YES;
    _networkAdapter = [[KNetworkAdapter alloc]initWithDelegate:self];
    [_networkAdapter getProductListWithPageSize:pageSize pageCount:pageCount1];
}
-(void)showActivityIndicator{
    dispatch_async(dispatch_get_main_queue(),^{
        [_productCollectionView bringSubviewToFront:_spinner];
        [_spinner startAnimating];
    });
}
#pragma mark - NetworkAdapterDelegate methods -
#pragma mark NetwokCall
- (void)networkAdapter:(KNetworkAdapter*)sender didReceiveResponse:(id)response
               isError:(BOOL)isError{
    dispatch_async(dispatch_get_main_queue(),^{
        if (isError) {
            Error *error = (Error*)response;
            [KUtility showAlert:error.errorMsg];
            [_spinner stopAnimating];
            requestInProcess = NO;
        }
        else{
            
            [_arrayProduct addObjectsFromArray:[response valueForKey:@"products"]];
            [self.productCollectionView reloadData];
            [_spinner stopAnimating];
            requestInProcess = NO;
        }
        
        
    });
}

-(void)networkAdapter:(KNetworkAdapter*)sender failedWithError:(Error*)error {
    dispatch_async(dispatch_get_main_queue(),^{
        [KUtility showAlert:error.errorMsg];
        [_spinner stopAnimating];
        requestInProcess = NO;
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma marks collection view delegate
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [_arrayProduct count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH/2)- MIN_SPACING, 282);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductMatrixGrid *cell = nil;
    cell = [_productCollectionView dequeueReusableCellWithReuseIdentifier:@"ProductMatrixGridCellIdentifier"
                                                                 forIndexPath:indexPath];
    cell.lblPrice.text = [NSString stringWithFormat:@"Price: $%@",[[_arrayProduct objectAtIndex:indexPath.row] valueForKeyPath:@"pricing.price"]];
    cell.lblDescription.text = [NSString stringWithFormat:@"%@",[[_arrayProduct objectAtIndex:indexPath.row] valueForKeyPath:@"desc"]];
    NSLog(@"%@",[NSString stringWithFormat:@"https://media.redmart.com/newmedia/200p%@",[[_arrayProduct objectAtIndex:indexPath.row] valueForKeyPath:@"img.name"]]);
    [cell.productImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://media.redmart.com/newmedia/200p%@",[[_arrayProduct objectAtIndex:indexPath.row] valueForKeyPath:@"img.name"]]]
                       placeholderImage:nil
                                options:SDWebImageRetryFailed | SDWebImageLowPriority
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                  [cell.productImage setImage:image];
                                  if(cacheType == SDImageCacheTypeNone){
                                      [cell.productImage setAlpha:0.0];
                                      [UIView animateWithDuration:0.5 animations:^{
                                          [cell.productImage setAlpha:1.0];
                                      } completion:nil];
                                  }
                              }];
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     ProductDetailViewController *productDetailViewController = [[ProductDetailViewController alloc] initWithNibName:@"ProductDetailViewController" bundle:nil];
        [self.navigationController pushViewController:productDetailViewController animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    __weak __typeof(self) weakSelf = self;
    
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    
    if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
    {
        dispatch_async(requestQueue, ^{
            if(requestInProcess == NO){
                [weakSelf requestForNextPage:PAGE_COUNT pageCount:++pageCount];
                NSLog(@"PageCount %d",pageCount);
            }
        });
    }
    
}

-(void)dealloc{
}


@end
