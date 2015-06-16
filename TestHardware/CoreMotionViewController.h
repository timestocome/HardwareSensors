//
//  CoreMotionViewController.h
//  TestHardware
//
//  Created by Linda Cobb on 9/21/13.
//  Copyright (c) 2013 Linda Cobb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "DailySteps.h"


@interface CoreMotionViewController : UIViewController
{
    
    __block int walking;
    __block int running;
    __block int driving;
    
    __block int totalTime;
    __block int timeDifference;
    
    __block int totalSteps;
    
    __block int walkingSteps;
    __block int runningSteps;
    
}


@property (nonatomic, weak) IBOutlet UILabel* walkingLabel;
@property (nonatomic, weak) IBOutlet UILabel* walkingDetailsLabel;
@property (nonatomic, weak) IBOutlet UILabel* walkingStepsMinLabel;

@property (nonatomic, weak) IBOutlet UILabel* runningLabel;
@property (nonatomic, weak) IBOutlet UILabel* runningDetailsLabel;
@property (nonatomic, weak) IBOutlet UILabel* runningStepsMinLabel;

@property (nonatomic, weak) IBOutlet UILabel* unknownLabel;
@property (nonatomic, weak) IBOutlet UILabel* totalStepsLabel;

@property (nonatomic, weak) IBOutlet UILabel* day7;
@property (nonatomic, weak) IBOutlet UILabel* day6;
@property (nonatomic, weak) IBOutlet UILabel* day5;
@property (nonatomic, weak) IBOutlet UILabel* day4;
@property (nonatomic, weak) IBOutlet UILabel* day3;
@property (nonatomic, weak) IBOutlet UILabel* day2;
@property (nonatomic, weak) IBOutlet UILabel* day1;




@end
