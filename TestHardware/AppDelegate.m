//
//  AppDelegate.m
//  TestHardware
//
//  Created by Linda Cobb on 9/20/12.
//  Copyright (c) 2012 Linda Cobb. All rights reserved.
//

#import "AppDelegate.h"




@implementation AppDelegate
{
    CMMotionManager *motionManager;
}



- (CMMotionManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        motionManager = [[CMMotionManager alloc]init];
    });
    
    return motionManager;
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationWillEnterForeground:(UIApplication *)application {}
- (void)applicationDidBecomeActive:(UIApplication *)application {}
- (void)applicationWillTerminate:(UIApplication *)application {}


@end
