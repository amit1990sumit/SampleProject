
#import "NSDictionary+Addition.h"

@implementation NSDictionary (Addition)
-(NSArray*)arrayObjectForKey:(id)key {
    id obj = [self objectForKey:key];
    if (obj && [obj isKindOfClass:[NSArray class]]) {
        return (NSArray*)obj;
    }
    else if (!obj || ([obj isKindOfClass:[NSNull class]])) {
        return nil;
    }
    return nil;
}
-(NSString*)stringObjectForKey:(id)key{
    id obj = [self objectForKey:key];
    if (obj && [obj isKindOfClass:[NSString class]]) {
        return (NSString*)obj;
    }
    else if (!obj || ([obj isKindOfClass:[NSNull class]])) {
        return nil;
    }
    return nil;
}
-(NSNumber*)numberObjectForKey:(id)key{
    id obj = [self objectForKey:key];
    if (obj && [obj isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)obj;
    }
    else if (!obj || ([obj isKindOfClass:[NSNull class]])) {
        return nil;
    }
    return nil;
}
-(BOOL)boolValueForKey:(id)key{
    id obj = [self objectForKey:key];
    if(!obj)
        return NO;
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [(NSNumber*)obj boolValue];
    }
    else if([obj isKindOfClass:[NSString class]]){
        NSString *str = (NSString*)obj;
        BOOL isBoolean =  [str caseInsensitiveCompare:@"yes"] == NSOrderedSame ||
        [str caseInsensitiveCompare:@"1"] == NSOrderedSame ||
        [str caseInsensitiveCompare:@"true"] == NSOrderedSame;
        return isBoolean;
    }
    
    if (([obj isKindOfClass:[NSNull class]])) {
        return NO;
    }
    return NO;
}
@end
