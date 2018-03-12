

#import "NSMutableArray+Addition.h"
#import "KUtility.h"

@implementation NSMutableArray (Addition)
-(void)addNewObject:(id)object{
    if([KUtility isObjectNull:object])
        return;
    
    [self addObject:object];
}
- (void)addingNewObjectsFromArray:(id)array{
    if([KUtility isObjectNull:array])
        return;
    
    [self addObjectsFromArray:array];
}

@end
