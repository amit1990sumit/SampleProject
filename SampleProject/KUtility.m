//
//  KUtility.m
//  SampleProject
//
//  Created by admin on 12/03/18.
//  Copyright © 2018 namdev. All rights reserved.
//

#import "KUtility.h"
#import "AppDelegate.h"
@implementation KUtility
+ (BOOL)isObjectNull:(id)object {
    if(object == nil) {
        return TRUE;
    } else if([object isKindOfClass:[NSNull class]]) {
        return TRUE;
    }
    else
        return FALSE;
}
+ (id)foundationObjectWithJSON:(NSString*)json {
    id obj = nil;
    @try {
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        
        if (! jsonData) {
        }else {
            
            obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        }
    }@catch (NSException *exception) {
    }
    return obj;
}
+ (void)showAlert:(NSString*)message{
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        dispatch_async(dispatch_get_main_queue(),^{
            if(message) {
                [[[UIAlertView alloc] initWithTitle:@""
                                            message:message
                                           delegate:nil
                                  cancelButtonTitle:@"Ok"
                                  otherButtonTitles:nil, nil] show];
            }
        });
    }
}

@end
