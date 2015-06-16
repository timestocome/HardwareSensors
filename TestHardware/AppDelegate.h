//
//  AppDelegate.h
//  TestHardware
//
//  Created by Linda Cobb on 9/20/12.
//  Copyright (c) 2012 Linda Cobb. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>



@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) CMMotionManager *sharedManager;


@end
