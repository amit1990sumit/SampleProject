//
//  GetProductDetailOperation.m
//  SampleProject
//
//  Created by admin on 12/03/18.
//  Copyright © 2018 namdev. All rights reserved.
//

#import "GetProductDetailOperation.h"
#import "KConstants.h"
@interface GetProductDetailOperation() {

}
@end

@implementation GetProductDetailOperation

- (id)initWithProductID:(NSString*)productID{

  self = [super init];
  if (self) {
    [self setParamterWithProductID:productID];
  }
  return self;
}

- (NSURL *)url {
    NSString *urlString =  [NSString stringWithFormat:@"%@%@",ProductDetail,[self constructQueryParameter]];
    return [NSURL URLWithString:urlString];
}
-(NSString*)constructQueryParameter{
    NSMutableString *strUrlWithQueryString = nil;
    if (_queryParams) {
        strUrlWithQueryString = [[NSMutableString alloc] init];
        
        [strUrlWithQueryString appendFormat:@"/%@",[_queryParams valueForKey:@"id"]];
    }
    return strUrlWithQueryString;
}

- (NSString *)httpMethod {
    return HTTP_METHOD_GET;
}

- (void)setParamterWithProductID:(NSString*)productID{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setValue:productID forKey:@"id"];
    _queryParams = paramDict;
    [self mutableRequest];
}
- (void)successResponseReceived:(id)response {
    [self.delegate baseOperation:self dataReceived:response isError:NO];
}

@end
