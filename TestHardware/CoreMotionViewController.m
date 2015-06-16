//
//  CoreMotionViewController.m
//  TestHardware
//
//  Created by Linda Cobb on 9/21/13.
//  Copyright (c) 2013 Linda Cobb. All rights reserved.
//

#import "CoreMotionViewController.h"


@implementation CoreMotionViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
}



- (void)viewWillAppear:(BOOL)animated
{
    [self updateTodaysSteps];
    [self updateMotion];
    [self typeOfSteps];
    [self updateWeeksSteps];
    
}






- (void)updateMotion
{
    if ( ![CMMotionActivityManager isActivityAvailable]){ return; }
    
    
    CMMotionActivityManager* cmMotionActivityManager = [[CMMotionActivityManager alloc] init];
    NSDate* currentTime = [NSDate date];
    
    NSDate* midnightToday = [NSDate date];
    // break today's date into components
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit |
                                    NSMonthCalendarUnit | NSDayCalendarUnit fromDate:currentTime];
    
    // calculate midnight
    [components setHour:0];
    midnightToday = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    
    
    // fetch activities
    [cmMotionActivityManager queryActivityStartingFromDate:midnightToday toDate:currentTime toQueue:[NSOperationQueue mainQueue] withHandler:^(NSArray* activities, NSError* error){
        
        int count = (int)activities.count;
        
        
        walking = 0;
        running = 0;
        driving = 0;
        totalTime = 0;
        timeDifference = 0;
        
        
        for ( int i=0; i<count-1; i++){
            
            CMMotionActivity* activity = (CMMotionActivity *)[activities objectAtIndex:i];
            CMMotionActivity* nextActivity = (CMMotionActivity *)[activities objectAtIndex:i+1];
            timeDifference = [nextActivity.startDate timeIntervalSinceDate:activity.startDate];
            
            if ( activity.walking ){
                walking += timeDifference;
            }else if ( activity.running ){
                running += timeDifference;
            }else if ( activity.automotive ){
                driving += timeDifference;
            }
        }
        
        
        self.walkingLabel.text = [NSString stringWithFormat:@"%.0lf", walking/60.0];
        self.runningLabel.text = [NSString stringWithFormat:@"%.0lf", running/60.0];
        
        totalTime = [[NSDate date] timeIntervalSinceDate:midnightToday];
        
    }];
}




-(void)typeOfSteps
{
    
    if ( ![CMMotionActivityManager isActivityAvailable]){ return; }
    
    
    CMMotionActivityManager* cmMotionActivityManager = [[CMMotionActivityManager alloc] init];
    
    // now
    NSDate* currentTime = [NSDate date];
    
    
    // previous midnight ( ie start of today )
    NSDate* midnightToday = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit |
                                    NSMonthCalendarUnit | NSDayCalendarUnit fromDate:currentTime];
    
    [components setHour:0];
    midnightToday = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    
    
    // setup step counter
    CMStepCounter *stepCounter = [[CMStepCounter alloc] init];
    walkingSteps = 0;
    runningSteps = 0;
    
    
    // fetch today's activities
    [cmMotionActivityManager queryActivityStartingFromDate:midnightToday toDate:currentTime toQueue:[NSOperationQueue mainQueue] withHandler:^(NSArray* activities, NSError* error){
        
        int count = (int)activities.count;
        
        for ( int i=0; i<count-1; i++){
            
            CMMotionActivity* activity = (CMMotionActivity *)[activities objectAtIndex:i];
            CMMotionActivity* nextActivity = (CMMotionActivity *)[activities objectAtIndex:i+1];
            
            
            if ( activity.running ){
                [stepCounter queryStepCountStartingFrom:activity.startDate to:nextActivity.startDate toQueue:[NSOperationQueue mainQueue] withHandler:^(NSInteger numberOfSteps, NSError *error){
                    runningSteps += numberOfSteps;
                    self.runningDetailsLabel.text = [NSString stringWithFormat:@"%d", runningSteps];
                    self.runningStepsMinLabel.text = [NSString stringWithFormat:@"%.0f", runningSteps/(running/60.0)];
                    self.unknownLabel.text = [NSString stringWithFormat:@"%d", (totalSteps - runningSteps - walkingSteps)];
                    
                }];
                
            }else if ( activity.walking ){
                [stepCounter queryStepCountStartingFrom:activity.startDate to:nextActivity.startDate toQueue:[NSOperationQueue mainQueue] withHandler:^(NSInteger numberOfSteps, NSError *error){
                    walkingSteps += numberOfSteps;
                    self.walkingDetailsLabel.text = [NSString stringWithFormat:@"%d", walkingSteps];
                    self.walkingStepsMinLabel.text = [NSString stringWithFormat:@"%.0f", walkingSteps/(walking/60.0)];
                    self.unknownLabel.text = [NSString stringWithFormat:@"%d", (totalSteps - runningSteps - walkingSteps)];
                    
                }];
            }
        }
    }];
    
}





// used to update steps
- (void)updateTodaysSteps
{
    // is step counting available?
    if ( ![CMStepCounter isStepCountingAvailable]){ return; }
    
    NSDate *currentDate = [NSDate date];
    NSDate *midnight = [NSDate date];
    totalSteps = 0;
    
    // break today's date into components
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit |
                                    NSMonthCalendarUnit | NSDayCalendarUnit fromDate:currentDate];
    
    // calculate midnight
    [components setHour:0];
    midnight = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    
    // fetch steps
    CMStepCounter *stepCounter = [[CMStepCounter alloc] init];
    [stepCounter queryStepCountStartingFrom:midnight to:currentDate toQueue:[NSOperationQueue mainQueue] withHandler:^(NSInteger numberOfSteps, NSError *error){
        totalSteps = (int)numberOfSteps;
        self.totalStepsLabel.text = [NSString stringWithFormat:@"%ld", (long)numberOfSteps];
    }];
}




// on load check current date against last database update date
// load any data not yet pulled from device into our database
// if last database update == null then grab all the data we can 7 days?
- (void)updateWeeksSteps
{
    if ( ![CMStepCounter isStepCountingAvailable]){ return; }
    
    
    
    NSDate *currentDate = [NSDate date];
    
    // grab and total steps by day - can go back 7 days at most
    
    // break today's date into components
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit |
                                    NSMonthCalendarUnit | NSDayCalendarUnit fromDate:currentDate];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger hour = 0;
    
    
    // go back 7 days
    NSDate* lastUpdateDate = [[NSDate date] dateByAddingTimeInterval:-7*24*60*60];
    
    
    // get last update date components
    components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit |
                  NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit
                                                 fromDate:lastUpdateDate];
    NSInteger lastYear = [components year];
    NSInteger lastMonth = [components month];
    NSInteger lastDay = [components day];
    NSInteger lastHour = 24;
    
    __block NSMutableArray* dailyStepsArray = [[NSMutableArray alloc] initWithCapacity:7];
    
    
    // step through hour by hour, grab steps and update or add record to database
    for (long y=lastYear; y<=year; y++){
        [components setYear:y];
        
        for ( long m=lastMonth; m<=month; m++){
            [components setMonth:m];
            
            for (long d=lastDay; d<=day; d++){
                [components setDay:d];
                
                
                // fetch steps
                // create start and end time for fetching steps
                [components setHour:hour];
                NSDate *startTime = [[NSCalendar currentCalendar] dateFromComponents:components];
                
                [components setHour:lastHour];
                NSDate *endTime = [[NSCalendar currentCalendar] dateFromComponents:components];
                
                CMStepCounter *stepCounter = [[CMStepCounter alloc] init];
                
                [stepCounter queryStepCountStartingFrom:startTime to:endTime toQueue:[NSOperationQueue mainQueue] withHandler:^(NSInteger numberOfSteps, NSError *error){
                    
                    
                    DailySteps* ds = [[DailySteps alloc] init];
                    [ds setDate:startTime];
                    [ds setSteps:[NSNumber numberWithInt:(int)numberOfSteps]];
                    [dailyStepsArray addObject:ds];
                    
                    if ( dailyStepsArray.count >= 7 ){
                        
                        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
                        NSMutableArray *sortedArray = [[dailyStepsArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]]mutableCopy];
                        
                       // self.day1.text = [NSString stringWithFormat:@"%d", [[[sortedArray objectAtIndex:0] steps] intValue]];
                        self.day2.text = [NSString stringWithFormat:@"%d", [[[sortedArray objectAtIndex:1] steps] intValue]];
                        self.day3.text = [NSString stringWithFormat:@"%d", [[[sortedArray objectAtIndex:2] steps] intValue]];
                        self.day4.text = [NSString stringWithFormat:@"%d", [[[sortedArray objectAtIndex:3] steps] intValue]];
                        self.day5.text = [NSString stringWithFormat:@"%d", [[[sortedArray objectAtIndex:4] steps] intValue]];
                        self.day6.text = [NSString stringWithFormat:@"%d", [[[sortedArray objectAtIndex:5] steps] intValue]];
                        self.day7.text = [NSString stringWithFormat:@"%d", [[[sortedArray objectAtIndex:6] steps] intValue]];

                        
                    }
                    
                }];
                
            }
        }
    }
    
    
    
}









- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
