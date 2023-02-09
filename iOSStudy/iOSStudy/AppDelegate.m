//
//  AppDelegate.m
//  iOSStudy
//
//  Created by ItghostFan on 2021/12/4.
//

#import "AppDelegate.h"

#import <sys/sysctl.h>
#import <mach/task.h>
#import <mach/mach_init.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    task_vm_info_data_t taskInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t result = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t)&taskInfo, &count);
    if (result == KERN_SUCCESS) {
        int64_t usedMemory = (int64_t)taskInfo.phys_footprint;
        NSLog(@"Usage Memory: %.1fM, Total Memory: %.1fG", (double)usedMemory / 1024 / 1024, ceil((double)NSProcessInfo.processInfo.physicalMemory / 1000 / 1000 / 1000));
    }
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
