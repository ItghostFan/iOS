//
//  ViewController.m
//  iOSStudy
//
//  Created by ItghostFan on 2021/12/4.
//

#import "ViewController.h"

#import "WhatIsBlock.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@", [WhatIsBlock new]);
}


@end
