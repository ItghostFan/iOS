//
//  WhatIsBlock+MRC.h
//  iOSStudy
//
//  Created by ItghostFan on 2021/12/4.
//

#import "WhatIsBlock.h"

NS_ASSUME_NONNULL_BEGIN

@interface WhatIsBlock (MRC)

- (void)globalBlockCaseMrc;
- (void)stackBlockCaseMrc;
- (void)mallocBlockCaseMrc;

@end

NS_ASSUME_NONNULL_END
