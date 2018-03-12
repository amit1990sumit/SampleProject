//
//  BaseOperation.h
//  SampleProject
//
//  Created by admin on 12/03/18.
//  Copyright © 2018 namdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OperationDelegate.h"

#define HTTP_METHOD_GET @"GET"
#define HTTP_METHOD_POST @"POST"
#define HTTP_METHOD_PUT @"PUT"

@interface BaseOperation : NSOperation <NSURLConnectionDelegate,
NSURLConnectionDataDelegate>{
    NSMutableDictionary* _queryParams;
}


@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, weak) id<OperationDelegate>delegate;

// returns the mutable request initialized with the url
- (NSMutableURLRequest*) mutableRequest;

/**
 Cancels the request
*/
- (void)cancel;

/**
 Called when success is received from server. Base call implementation does nothing
 Subclass should override this method to parse the response and call the delegate.
*/
- (void)successResponseReceived:(id)response;

- (void)finish;
@end


@interface KOpenAPIEndPoint : NSObject
@property (nonatomic, strong) NSString *apiURLString;
@property (nonatomic, strong) NSString *apiKey;

+ (KOpenAPIEndPoint*)envTest3;
+ (KOpenAPIEndPoint*)envQe13;
+ (KOpenAPIEndPoint*)envQe11;
@end

