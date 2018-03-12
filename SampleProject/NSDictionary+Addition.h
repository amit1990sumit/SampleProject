

#import <Foundation/Foundation.h>

@interface NSDictionary (Addition)
- (NSArray*)arrayObjectForKey:(id)key;
-(NSString*)stringObjectForKey:(id)key;
-(NSNumber*)numberObjectForKey:(id)key;
-(BOOL)boolValueForKey:(id)key;
@end
