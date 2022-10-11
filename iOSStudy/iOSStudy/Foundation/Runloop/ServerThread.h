//
//  ServerThread.h
//  iOSStudy
//
//  Created by Itghost Fan on 2022/8/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ServerThread : NSThread

- (instancetype)initWithClientPort:(NSMachPort *)clientPort serverPort:(NSMachPort *)serverPort;
- (void)sendMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
