//
//  ClientThread.m
//  iOSStudy
//
//  Created by Itghost Fan on 2022/8/28.
//

#import "ClientThread.h"

@interface ClientThread () <NSPortDelegate>
@property NSPort *clientPort;
@property NSPort *serverPort;
@end

@implementation ClientThread

- (instancetype)initWithServerPort:(NSPort *)serverPort clientPort:(NSPort *)clientPort  {
    if (self = [self initWithTarget:self selector:@selector(worker:) object:nil]) {
        self.name = @"ClientThread";
        self.clientPort = clientPort;
        self.serverPort = serverPort;
    }
    return self;
}

#pragma mark - Private

- (void)worker:(id)context {
    self.clientPort.delegate = self;
    [NSRunLoop.currentRunLoop addPort:self.clientPort forMode:NSDefaultRunLoopMode];
    while (!self.isCancelled) {
        if (![NSRunLoop.currentRunLoop runMode:NSDefaultRunLoopMode beforeDate:NSDate.distantFuture]) {
        }
    }
    [NSRunLoop.currentRunLoop removePort:self.clientPort forMode:NSDefaultRunLoopMode];
}

- (void)sendMessage:(NSString *)message {
    [self.serverPort sendBeforeDate:[NSDate dateWithTimeIntervalSinceNow:20] components:@[[message dataUsingEncoding:NSUTF8StringEncoding]].mutableCopy from:self.clientPort reserved:0];
}

#pragma mark - NSPortDelegate

- (void)handlePortMessage:(NSPortMessage *)message {
}

@end

