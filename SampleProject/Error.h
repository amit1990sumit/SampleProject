//
//  Error.h
//  SampleProject
//
//  Created by admin on 12/03/18.
//  Copyright © 2018 namdev. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Error : NSObject{
    NSDictionary *errorCodesDictionary;
}
@property (nonatomic, strong) NSString* errorCode;
@property (nonatomic, strong) NSString* errorMsg;
@property (nonatomic, assign) NSInteger httpStatusCode;

- (id)initWithCode:(NSString*)code message:(NSString*)message;
- (NSString*)message;
- (NSString*)code;


@end
