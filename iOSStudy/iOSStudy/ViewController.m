//
//  ViewController.m
//  iOSStudy
//
//  Created by ItghostFan on 2021/12/4.
//

#import "ViewController.h"

#import "WhatIsBlock.h"

#import "HttpCase.h"

@interface ViewController ()
@property (strong, nonatomic) HttpCase *httpCase;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@", [WhatIsBlock new]);
    self.httpCase = [HttpCase new];
    for (NSInteger index = 0; index < 1000; ++index) {
        [self.httpCase request];
    }
}


@end
