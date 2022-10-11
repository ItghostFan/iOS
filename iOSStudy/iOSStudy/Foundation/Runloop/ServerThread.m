//
//  ServerThread.m
//  iOSStudy
//
//  Created by Itghost Fan on 2022/8/28.
//

#import "ServerThread.h"

@interface ServerThread () <NSPortDelegate>
@property NSPort *clientPort;
@property NSPort *serverPort;
@end

@implementation ServerThread

- (instancetype)initWithClientPort:(NSMachPort *)clientPort serverPort:(NSMachPort *)serverPort {
    if (self = [self initWithTarget:self selector:@selector(worker:) object:nil]) {
        self.name = @"ServerThread";
        self.serverPort = serverPort;
        self.clientPort = clientPort;
    }
    return self;
}

#pragma mark - Private

- (void)worker:(id)context {
    self.serverPort.delegate = self;
    [NSRunLoop.currentRunLoop addPort:self.serverPort forMode:NSDefaultRunLoopMode];
    while (!self.isCancelled) {
        if (![NSRunLoop.currentRunLoop runMode:NSDefaultRunLoopMode beforeDate:NSDate.distantFuture]) {
        }
    }
    [NSRunLoop.currentRunLoop removePort:self.serverPort forMode:NSDefaultRunLoopMode];
}

- (void)sendMessage:(NSString *)message {
    [self.clientPort sendBeforeDate:[NSDate dateWithTimeIntervalSinceNow:20] components:@[[message dataUsingEncoding:NSUTF8StringEncoding]].mutableCopy from:self.serverPort reserved:0];
}

#pragma mark - NSPortDelegate

- (void)handlePortMessage:(NSPortMessage *)message {
}

@end
