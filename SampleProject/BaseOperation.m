//
//  BaseOperation.m
//  SampleProject
//
//  Created by admin on 12/03/18.
//  Copyright © 2018 namdev. All rights reserved.
//

#import "BaseOperation.h"
#import "NSDictionary+Addition.h"
#import "KUtility.h"
#import "Error.h"
#import "KConstants.h"
@interface BaseOperation(){
    NSMutableURLRequest *_req;
}

@property (atomic) BOOL _isExecuting;
@property (atomic) BOOL _isFinished;

@property (nonatomic, strong) NSURLConnection *con;
@property (nonatomic, strong) NSPort* port;

@end

@implementation BaseOperation

#pragma mark Declaring Concurrent operation

- (BOOL)isConcurrent {
    return YES;
}
- (BOOL)isExecuting
{
    // any thread
    return self._isExecuting;
}

- (BOOL)isFinished
{
    // any thread
    return self._isFinished;
}


- (NSURL *)url {
    return nil;
}

- (NSString*)httpMethod {
    return HTTP_METHOD_GET;
}

- (NSMutableURLRequest*) mutableRequest {
    if (_req) {
        return _req;
    }
    if ([self url]) {
        _req = [NSMutableURLRequest requestWithURL:[self url]];
        return _req;
    }
    return nil;
}

- (void)start {
    if ([self isCancelled]) {
        [self willChangeValueForKey:@"isFinished"];
        self._isFinished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }

    [self willChangeValueForKey:@"isExecuting"];
    self._isExecuting = YES;
    
    if(!_req)   _req = [self mutableRequest];
    
    if (!_req) {
        [self finish];
        return;
    }
    [_req setHTTPMethod:[self httpMethod]];

    NSInteger timeoutInSeconds = 30;
    if (timeoutInSeconds <= 0) {
        timeoutInSeconds = 20;
    }
    [_req setTimeoutInterval:timeoutInSeconds];
    self.data = [[NSMutableData alloc] init];
    self.con = [[NSURLConnection alloc] initWithRequest:_req delegate:self startImmediately:NO];
    self.port = [NSPort port];
    NSRunLoop* rl = [NSRunLoop currentRunLoop];
    [rl addPort:self.port forMode:NSDefaultRunLoopMode];
    [self.con scheduleInRunLoop:rl forMode:NSDefaultRunLoopMode];
    [self.con start];
    [rl run];
    
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)cancel{
    [self.con cancel];
    [super cancel];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
        if ([self isCancelled]) {
        return;
    }
    Error *e = [[Error alloc] initWithCode:URLErrorNetworkConnectionLost message:@"Network error"];
    [self.delegate failed:self withError:e];
    [self finish];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    // [[KLogger sharedInstance] logInfo:@"data = %@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]];
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if ([self isCancelled]) {
        return;
    }
    NSString *res = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    NSDictionary *response = [KUtility foundationObjectWithJSON:res];
    [self successResponseReceived:response];
    [self finish];

}

- (void)successResponseReceived:(id)response    {

}

/// marks the current operation finished.
- (void)finish {
    // Invalidate and remove the port, required for current thread to finish
    [self.port invalidate];
    [[NSRunLoop currentRunLoop] removePort:self.port forMode:NSDefaultRunLoopMode];
    
    // marks the operation finished and so removed from the operation queue
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    self._isExecuting = NO;
    self._isFinished = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}
@end
