//
//  ViewController.m
//  iOSStudy
//
//  Created by ItghostFan on 2021/12/4.
//

#import "ViewController.h"

#import "WhatIsBlock.h"

#import "HttpCase.h"
#import "HttpUrlProtocol.h"
#import "ServerThread.h"
#import "ClientThread.h"

@interface ViewController ()
@property (strong, nonatomic) HttpCase *httpCase;
@property (strong, nonatomic) ServerThread *serverThread;
@property (strong, nonatomic) ClientThread *clientThread;
@property (weak, nonatomic) IBOutlet UIButton *sendToClientButton;
@property (weak, nonatomic) IBOutlet UIButton *runOnServerThreadButton;
@property (weak, nonatomic) IBOutlet UIButton *sendToServerButton;
@property (weak, nonatomic) IBOutlet UIButton *exitServerThreadButton;
@property (weak, nonatomic) IBOutlet UIButton *exitClientThreadButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@", [WhatIsBlock new]);
    self.httpCase = [HttpCase new];
    for (NSInteger index = 0; index < 1; ++index) {
        [self.httpCase request];
    }
    NSMachPort *clientPort = [NSMachPort new];
    NSMachPort *serverPort = [NSMachPort new];
    self.serverThread = [[ServerThread alloc] initWithClientPort:clientPort serverPort:serverPort];
    [self.serverThread start];
    self.clientThread = [[ClientThread alloc] initWithServerPort:serverPort clientPort:clientPort];
    [self.clientThread start];
    [self.sendToClientButton addTarget:self action:@selector(onSendToClient:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendToServerButton addTarget:self action:@selector(onSendToServer:) forControlEvents:UIControlEventTouchUpInside];
    [self.runOnServerThreadButton addTarget:self action:@selector(onRunOnServerThread:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onSendToClient:(id)sender {
    [self.serverThread sendMessage:@"Message Come From Server"];
}

- (void)onSendToServer:(id)sender {
    [self.clientThread sendMessage:@"Message Come From Client"];
}

- (void)onRunOnServerThread:(id)sender {
    [self performSelector:@selector(runOnServerThread) onThread:self.serverThread withObject:nil waitUntilDone:YES];
}

- (void)runOnServerThread {
}

- (void)dealloc {
}


@end
