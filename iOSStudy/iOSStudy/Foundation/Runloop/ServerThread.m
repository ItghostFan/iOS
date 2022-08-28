//
//  ServerThread.m
//  iOSStudy
//
//  Created by Itghost Fan on 2022/8/28.
//

#import "ServerThread.h"

@interface ServerThread () <NSPortDelegate>
@property NSMessagePort *clientPort;
@property NSMessagePort *serverPort;
@end

@implementation ServerThread

- (instancetype)initWithClientPort:(NSMessagePort *)clientPort serverPort:(NSMessagePort *)serverPort {
    if (self = [self initWithTarget:self selector:@selector(worker:) object:nil]) {
        self.serverPort = serverPort;
        self.clientPort = clientPort;
    }
    return self;
}

#pragma mark - Private

- (void)worker:(id)context {
    [NSRunLoop.currentRunLoop run];
    [NSRunLoop.currentRunLoop addPort:self.serverPort forMode:NSDefaultRunLoopMode];
    self.serverPort.delegate = self;
    while (!self.isCancelled) {
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
