//
//  GetProductListOperation.m
//  SampleProject
//
//  Created by admin on 12/03/18.
//  Copyright © 2018 namdev. All rights reserved.
//

#import "GetProductListOperation.h"

@implementation GetProductListOperation
- (id)initWithPageSize:(NSInteger)pageSize
             pageCount:(NSInteger)pageCount{
    
    self = [super init];
    if (self) {
        [self setParamterWithPageSize:pageSize pageCount:pageCount];
    }
    return self;
}

- (NSURL *)url {
    NSString *urlString =  [NSString stringWithFormat:@"%@%@",ProductList,[self constructQueryParameter]];
    return [NSURL URLWithString:urlString];
}
-(NSString*)constructQueryParameter{
    NSMutableString *strUrlWithQueryString = nil;
    if (_queryParams) {
        strUrlWithQueryString = [NSMutableString stringWithString:@"?"];
        for (NSString *key in _queryParams) {
            [strUrlWithQueryString appendFormat:@"%@=%@&",key,[_queryParams valueForKey:key]];
        }
    }
    return strUrlWithQueryString;
}

- (NSString *)httpMethod {
    return HTTP_METHOD_GET;
}

- (void)setParamterWithPageSize:(NSInteger)pageSize
    pageCount:(NSInteger)pageCount{
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setValue:[NSNumber numberWithInteger:pageSize] forKey:@"pageSize"];
    [paramDict setValue:[NSNumber numberWithInteger:pageCount] forKey:@"page"];
    [paramDict setValue:@"all-sales" forKey:@"theme"];
    _queryParams = paramDict;
    [self mutableRequest];
}
- (void)successResponseReceived:(id)response {
    [self.delegate baseOperation:self dataReceived:response isError:NO];
}
@end
