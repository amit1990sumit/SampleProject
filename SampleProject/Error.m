//
//  Error.m
//  SampleProject
//
//  Created by admin on 12/03/18.
//  Copyright © 2018 namdev. All rights reserved.
//

#import "Error.h"
#import "NSDictionary+Addition.h"

@implementation Error

@synthesize errorCode;
@synthesize errorMsg;

- (id)initWithCode:(NSString*)code message:(NSString*)message {
    self = [super init];
    if (self) {
        [self getErrorFromCode:code andMessage:message];
    }
    return self;
}

-(void)getErrorFromCode:(NSString*)strErrorCode andMessage:(NSString*)message{
    
    NSDictionary *errorCodes = [self getErrorCodeDict];
    NSString *displayErrorMessage = errorCodes[strErrorCode];
    if (!displayErrorMessage) {
        displayErrorMessage = message;
    }
    self.errorMsg = displayErrorMessage;
    self.errorCode = strErrorCode;
}
-(NSDictionary*)getErrorCodeDict{
    if (!errorCodesDictionary) {
        errorCodesDictionary = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ErrorCodes" ofType:@"plist"]];
        return errorCodesDictionary;
    }
    else{
        return errorCodesDictionary;
    }
}
- (NSString*)message{
   return self.errorMsg;
}

- (NSString*)code {
  return self.errorCode;
}

@end
