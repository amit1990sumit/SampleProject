//
//  ProductDetailViewController.m
//  SampleProject
//
//  Created by admin on 12/03/18.
//  Copyright © 2018 namdev. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "KNetworkAdapter.h"
#import "CarouselVIew.h"
#import "NSMutableArray+Addition.h"
#import "UIImageView+WebCache.h"
#import "KUtility.h"
#import "ProductDetailView.h"

static NSInteger count = 1;

@interface ProductDetailViewController ()<KNetworkAdapterDelegate>{
    NSInteger weekday;
    NSMutableDictionary *dictProduct;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)KNetworkAdapter *networkAdapter;
@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    count = 1;
    self.title = @"PDP";
    dictProduct = [[NSMutableDictionary alloc] init];
    [_tableView registerNib:[UINib nibWithNibName:@"CarouselVIew" bundle:nil] forCellReuseIdentifier:@"CarouselVIew"];
    [_tableView registerNib:[UINib nibWithNibName:@"ProductDetailView" bundle:nil] forCellReuseIdentifier:@"ProductDetailView"];
    _tableView.rowHeight = UITableViewAutomaticDimension;
   _networkAdapter = [[KNetworkAdapter alloc]initWithDelegate:self];
   [_networkAdapter getProductDetailWithProductID:@"150882"];
    
}

#pragma mark - NetworkAdapterDelegate methods -
#pragma mark NetwokCall
- (void)networkAdapter:(KNetworkAdapter*)sender didReceiveResponse:(id)response
               isError:(BOOL)isError{
    dispatch_async(dispatch_get_main_queue(),^{
        if (isError) {
            Error *error = (Error*)response;
            [KUtility showAlert:error.errorMsg];
        }
        else{
            dictProduct = [response valueForKeyPath:@"product"];
            [_tableView reloadData];
        }
    });
}

-(void)networkAdapter:(KNetworkAdapter*)sender failedWithError:(Error*)error {
    dispatch_async(dispatch_get_main_queue(),^{
        [KUtility showAlert:error.errorMsg];
    });
}

#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
      return (CarouselVIew*)[tableView dequeueReusableCellWithIdentifier:@"CarouselVIew" forIndexPath:indexPath];
    }
    else if (indexPath.row == 1){
        ProductDetailView *cell = (ProductDetailView*)[tableView dequeueReusableCellWithIdentifier:@"ProductDetailView" forIndexPath:indexPath];
        cell.lblDesc.text = [dictProduct valueForKey:@"desc"];
        cell.lblPrice.text = [NSString stringWithFormat:@"Price: $%@",[dictProduct valueForKeyPath:@"pricing.price"]];
        return cell;
    }
    return nil;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        CarouselVIew *cellTemp = (CarouselVIew*)cell;
        [cellTemp setImageArray:[dictProduct valueForKey:@"images"]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 240;
    }
    else if (indexPath.row == 1){
        return 151;
    }
    return UITableViewAutomaticDimension;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dealloc{
}

@end
