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
@property (weak, nonatomic) IBOutlet UIButton *sendToServerButton;
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
    NSMessagePort *clientPort = [NSMessagePort new];
    NSMessagePort *serverPort = [NSMessagePort new];
    self.serverThread = [[ServerThread alloc] initWithClientPort:clientPort serverPort:serverPort];
    self.clientThread = [[ClientThread alloc] initWithServerPort:serverPort clientPort:clientPort];
    [self.sendToClientButton addTarget:self action:@selector(OnSendToClient:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendToServerButton addTarget:self action:@selector(OnSendToServer:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)OnSendToClient:(id)sender {
    [self.serverThread sendMessage:@"Message Come From Server"];
}

- (void)OnSendToServer:(id)sender {
    [self.clientThread sendMessage:@"Message Come From Client"];
}

- (void)dealloc {
}


@end
