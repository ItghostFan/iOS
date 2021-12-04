//
//  WhatIsBlock.m
//  iOSStudy
//
//  Created by ItghostFan on 2021/12/4.
//

#import "WhatIsBlock.h"

#import "WhatIsBlock+MRC.h"

@interface WhatIsBlock ()
@end

@implementation WhatIsBlock

- (instancetype)init {
    self = [super init];
    if (self) {
//        [self globalBlockCase];
//        [self stackBlockCase];
//        [self mallocBlockCase];
        
        [self globalBlockCaseMrc];
        [self stackBlockCaseMrc];
        [self mallocBlockCaseMrc];
    }
    return self;
}

- (void)globalBlockCase {
    // MARK: Tips 4 ARC global block 的类为__NSGlobalBlock__
    BlockType globalBlock = ^(int value) {
        NSLog(@"Global block invoke!");
        return 0;
    };
    globalBlock(123);
}

- (void)stackBlockCase {
    // MARK: Tips 5 ARC stack block 的类为__NSMallocBlock__
    NSString *stackValue = @"123";
    BlockType stackBlock = ^(int value) {
        NSLog(@"stackValue block invoke value:%@!", stackValue);
        return 0;
    };
    stackBlock(123);
}

- (void)mallocBlockCase {
    // MARK: Tips 6 ARC malloc block 的类为__NSMallocBlock__
    NSString *stackValue = @"123";
    BlockType mallocBlock = [^(int value) {
        NSLog(@"Malloc block invoke value:%@!", stackValue);
        return 0;
    } copy];
    mallocBlock(123);
}

@end
