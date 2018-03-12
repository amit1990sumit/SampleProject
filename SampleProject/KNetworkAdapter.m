//
//  KNetworkAdapter.m
//  SampleProject
//
//  Created by admin on 12/03/18.
//  Copyright © 2018 namdev. All rights reserved.
//

#import "KNetworkAdapter.h"
#import "KUtility.h"
#import "BaseOperation.h"
#import "GetProductDetailOperation.h"
#import "GetProductListOperation.h"
#import "NSMutableArray+Addition.h"

@interface KNetworkAdapter() {
    KNetworkAdapterRequestType _requestType;
}

@property (nonatomic, strong) NSOperationQueue* networkQueue;
@property (atomic) NetworkStatus netStatus;

@end

short maxOperationCount = 3;
@implementation KNetworkAdapter

@synthesize requestType = _requestType;

+ (KNetworkAdapter*)globalInstance   {
    static KNetworkAdapter *_glbInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _glbInstance = [[KNetworkAdapter alloc] init];
        _glbInstance.networkQueue = [[NSOperationQueue alloc] init];
        [_glbInstance configureNetworkQueue];
        _glbInstance.reachability = [CDVReachability reachabilityForInternetConnection];
        [_glbInstance.reachability startNotifier];
        [[NSNotificationCenter defaultCenter] addObserver:_glbInstance selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    });
    return _glbInstance;
}

#pragma mark Helper methods
- (void)configureNetworkQueue{
    self.networkQueue.maxConcurrentOperationCount = maxOperationCount;
}

- (void)reachabilityChanged:(NSNotification*)notification{
    [KNetworkAdapter globalInstance].netStatus = [(CDVReachability*)[notification object] currentReachabilityStatus];
}

#pragma mark Class methods
+ (NetworkStatus)networkStatus{
    [KNetworkAdapter globalInstance].netStatus = [[KNetworkAdapter globalInstance].reachability currentReachabilityStatus];
    return [KNetworkAdapter globalInstance].netStatus;
}
+ (void)cancelRequest:(KNetworkAdapterRequestType)requestType {
    NSMutableArray *ops = nil;
    if ([KNetworkAdapter pendingRequestOfType:requestType operation:&ops]) {
        for(NSOperation* op in ops){
            [op cancel];
        }
    }
}
+ (BOOL)pendingRequestOfType:(KNetworkAdapterRequestType)type
                   operation:(NSMutableArray **)returnOperations {
    
    *returnOperations = [[NSMutableArray alloc] init];
    Class operationClass;
    switch (type) {
        case KNetworkAdapterRequestTypeWeather:
            operationClass = nil;
            break;
        default:
            return NO;
    }
    NSArray *opInProgress = [KNetworkAdapter globalInstance].networkQueue.operations;
    for (int i = 0; i < [opInProgress count]; i ++) {
        NSOperation *op = [opInProgress objectAtIndex:i];
        if ([op isKindOfClass:operationClass]) {
            [*returnOperations addNewObject:op];
        }
    }
    if([*returnOperations count]) return YES;
    return NO;
}

#pragma mark Instance methods

- (id)initWithDelegate:(id<KNetworkAdapterDelegate>)delegate{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.delegate = delegate;
    return self;
}
- (void)enqueueOperation:(BaseOperation*)op    {
    @synchronized ([KNetworkAdapter class]) {
        if ([KNetworkAdapter networkStatus] == NotReachable) {
            Error *noNetwork = [[Error alloc] initWithCode:URLErrorNetworkConnectionLost message:@"Network error"];
            [self failed:op withError:noNetwork];
            return;
        }
        op.delegate = self;
        [[KNetworkAdapter globalInstance].networkQueue addOperation:op];
    }
}
- (void)getProductListWithPageSize:(NSInteger)pageSize
                           pageCount:(NSInteger)pageCount {
    
    _requestType = KNetworkAdapterRequestTypeForecast;
    GetProductListOperation *op = [[GetProductListOperation alloc] initWithPageSize:pageSize pageCount:pageCount];
    [self enqueueOperation:op];
}
- (void)getProductDetailWithProductID:(NSString*)productID{
    _requestType = KNetworkAdapterRequestTypeWeather;
    GetProductDetailOperation *op = [[GetProductDetailOperation alloc] initWithProductID:productID];
    [self enqueueOperation:op];
}

#pragma mark baseOperationDelegate
- (void)baseOperation:(BaseOperation *)request dataReceived:(id)data isError:(BOOL)isError{

    [self.delegate networkAdapter:self didReceiveResponse:data isError:isError];
}
- (void)failed:(BaseOperation *)request withError:(Error *)err {
    [self.delegate networkAdapter:self failedWithError:err];
}
- (void)dealloc
{
    self.networkQueue =nil;
}
@end
