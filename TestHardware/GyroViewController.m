//
//  GyroViewController.m
//  TestHardware
//
//  Created by Linda Cobb on 9/20/12.
//  Copyright (c) 2012 Linda Cobb. All rights reserved.
//

#import "GyroViewController.h"
#import "AppDelegate.h"

static const NSTimeInterval gyroMin = 0.01;



@implementation GyroViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _motionManager = [(AppDelegate *)[[UIApplication sharedApplication] delegate] sharedManager];
    
    self.updateIntervalSlider.value = 10.0;
    self.updateIntervalLabel.text = [NSString stringWithFormat:@"%d", (int)(self.updateIntervalSlider.value)];
    
    self.scaleSlider.value = 1.0;
    self.scaleLabel.text = [NSString stringWithFormat:@"%d", (int)(self.scaleSlider.value)];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
}


- (IBAction)intervalChanged:(id)sender
{
    [self startUpdatesWithSliderValue:(int)(self.updateIntervalSlider.value)];
    
    [self.updateIntervalLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%d", (int)(self.updateIntervalSlider.value)] waitUntilDone:NO];
}


- (IBAction)scaleChanged:(id)sender
{
    [self.simpleGraphView setScale:self.scaleSlider.value];
    [self.scaleLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%d", (int)(self.scaleSlider.value)] waitUntilDone:NO];
    
}



- (IBAction)start:(id)sender
{
    [self startUpdatesWithSliderValue:(int)(self.updateIntervalSlider.value)];
}



- (IBAction)stop:(id)sender
{
    [self stopUpdates];
}


- (void)stopUpdates
{
    if ( [self.motionManager isGyroActive] == YES ){
        [self.motionManager stopGyroUpdates];
    }
}



- (void)startUpdatesWithSliderValue:(int)sliderValue
{
    
    NSTimeInterval updateInterval = gyroMin + 1.0/sliderValue;

    if ([self.motionManager isGyroAvailable] == YES)
    {
        [self.motionManager setGyroUpdateInterval:updateInterval];
    
        [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData *gyroData, NSError *error)
        {
            [self.simpleGraphView addX:[NSNumber numberWithDouble:gyroData.rotationRate.x] y:[NSNumber numberWithDouble: gyroData.rotationRate.y] z:[NSNumber numberWithDouble: gyroData.rotationRate.z]];
            
            [self.xLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"X: %.6lf rads/sec", gyroData.rotationRate.x] waitUntilDone:NO];
            [self.yLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"Y: %.6lf rads/sec", gyroData.rotationRate.y] waitUntilDone:NO];
            [self.zLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"Z: %.6lf rads/sec", gyroData.rotationRate.z] waitUntilDone:NO];
        
        }];
    }

}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
