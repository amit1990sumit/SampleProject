

#import <Foundation/Foundation.h>

@class Error;
@class BaseOperation;

@protocol OperationDelegate <NSObject>

@required

- (void)baseOperation:(BaseOperation*)request
            dataReceived:(id)data
              isError:(BOOL)isError;
- (void)failed:(BaseOperation*)request withError:(Error*)err;

@end
