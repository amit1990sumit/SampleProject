//
//  KUtility.h
//  SampleProject
//
//  Created by admin on 12/03/18.
//  Copyright © 2018 namdev. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface KUtility : NSObject
+ (BOOL)isObjectNull:(id)object;
+ (id)foundationObjectWithJSON:(NSString*)json;
+ (void)showAlert:(NSString*)message;
@end
