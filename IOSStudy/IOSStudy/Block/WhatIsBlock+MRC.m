//
//  WhatIsBlock+MRC.m
//  iOSStudy
//
//  Created by ItghostFan on 2021/12/4.
//

#import "WhatIsBlock+MRC.h"

@implementation WhatIsBlock (MRC)

- (void)globalBlockCaseMrc {
    // MARK: Tips 1 MRC global block 的类为__NSGlobalBlock__
    BlockType globalBlock = ^(int value) {
        NSLog(@"Global block invoke!");
        return 0;
    };
    globalBlock(123);
}

- (void)stackBlockCaseMrc {
    // MARK: Tips 2 MRC stack block 的类为__NSStackBlock__
    NSString *stackValue = @"123";
    BlockType stackBlock = ^(int value) {
        NSLog(@"stackValue block invoke value:%@!", stackValue);
        return 0;
    };
    stackBlock(123);
}

- (void)mallocBlockCaseMrc {
    // MARK: Tips 3 MRC malloc block 的类为__NSMallocBlock__
    NSString *stackValue = @"123";
    BlockType mallocBlock = [^(int value) {
        NSLog(@"Malloc block invoke value:%@!", stackValue);
        return 0;
    } copy];
    mallocBlock(123);
    [mallocBlock release];
}

@end
