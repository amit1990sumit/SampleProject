//
//  GetProductListOperation.h
//  SampleProject
//
//  Created by admin on 12/03/18.
//  Copyright © 2018 namdev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseOperation.h"
#import "KConstants.h"

@interface GetProductListOperation : BaseOperation
- (id)initWithPageSize:(NSInteger)pageSize
             pageCount:(NSInteger)pageCount;
@end
