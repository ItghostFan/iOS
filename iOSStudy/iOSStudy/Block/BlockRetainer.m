//
//  BlockRetainer.m
//  iOSStudy
//
//  Created by ItghostFan on 2021/12/4.
//

#import "BlockRetainer.h"

@implementation BlockRetainer

- (void)dealloc {
    NSLog(@"%@ %s", NSStringFromClass(self.class), __FUNCTION__);
}

@end
