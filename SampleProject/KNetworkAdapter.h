//
//  KNetworkAdapter.h
//  SampleProject
//
//  Created by admin on 12/03/18.
//  Copyright © 2018 namdev. All rights reserved.
//


#import "Error.h"
#import "OperationDelegate.h"
#import "CDVReachability.h"
#import "KConstants.h"

@class KNetworkAdapter;

typedef enum{
    KNetworkAdapterRequestTypeWeather = 0,
    KNetworkAdapterRequestTypeForecast
} KNetworkAdapterRequestType;

@protocol KNetworkAdapterDelegate

@required

- (void)networkAdapter:(KNetworkAdapter*)sender didReceiveResponse:(id)response
               isError:(BOOL)isError;

- (void)networkAdapter:(KNetworkAdapter*)sender failedWithError:(Error*)error;

@end

@interface KNetworkAdapter : NSObject <OperationDelegate>
@property (nonatomic, strong) CDVReachability *reachability;
@property (nonatomic, weak) id<KNetworkAdapterDelegate> delegate;
@property (nonatomic, readonly) KNetworkAdapterRequestType requestType;



- (id)initWithDelegate:(id<KNetworkAdapterDelegate>)delegate;
+ (void)cancelRequest:(KNetworkAdapterRequestType)requestType;
- (void)getProductDetailWithProductID:(NSString*)productID;
- (void)getProductListWithPageSize:(NSInteger)pageSize
                         pageCount:(NSInteger)pageCount;
@end

