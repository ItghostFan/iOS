//
//  ClientThread.m
//  iOSStudy
//
//  Created by Itghost Fan on 2022/8/28.
//

#import "ClientThread.h"

@interface ClientThread () <NSPortDelegate>
@property NSMessagePort *clientPort;
@property NSMessagePort *serverPort;
@end

@implementation ClientThread

- (instancetype)initWithServerPort:(NSMessagePort *)serverPort clientPort:(NSMessagePort *)clientPort  {
    if (self = [self initWithTarget:self selector:@selector(worker:) object:nil]) {
        self.clientPort = clientPort;
        self.serverPort = serverPort;
    }
    return self;
}

#pragma mark - Private

- (void)worker:(id)context {
    [NSRunLoop.currentRunLoop run];
    [NSRunLoop.currentRunLoop addPort:self.clientPort forMode:NSDefaultRunLoopMode];
    self.clientPort.delegate = self;
    while (!self.isCancelled) {
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

