//
//  WhatIsBlock.h
//  iOSStudy
//
//  Created by ItghostFan on 2021/12/4.
//

#import <Foundation/Foundation.h>

typedef int (^BlockType)(int value);

NS_ASSUME_NONNULL_BEGIN

@interface WhatIsBlock : NSObject

- (instancetype)init;

@end

NS_ASSUME_NONNULL_END
