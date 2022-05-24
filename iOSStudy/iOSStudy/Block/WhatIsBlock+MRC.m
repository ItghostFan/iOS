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
    mallocBlock(3);
    
    [mallocBlock release];
    
    // MARK: Tips 7 MRC __unsafe_unretained 处理循环引用
    BlockRetainer *retainer = [BlockRetainer new];
    __unsafe_unretained typeof(retainer) unsafeUnretainedRetainer = retainer;
    retainer.block = [^(int value) {
        NSLog(@"Unsafe Unretained block invoke value:%@!", unsafeUnretainedRetainer);
        return 0;
    } copy];
    retainer.block(7);
    
    // MARK: Tips 8 MRC __block 处理循环引用
    __block typeof(retainer) blockedRetainer = retainer;
    retainer.block = [^(int value) {
        NSLog(@"Blocked block invoke value:%@!", blockedRetainer);
        return 0;
    } copy];
    retainer.block(8);

    [retainer release];
}

@end
