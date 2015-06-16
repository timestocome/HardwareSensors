//
//  MagnometerViewController.m
//  TestHardware
//
//  Created by Linda Cobb on 1/3/14.
//  Copyright (c) 2014 Linda Cobb. All rights reserved.
//

#import "MagnometerViewController.h"
#import "AppDelegate.h"



@implementation MagnometerViewController





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
    self.updateIntervalLabel.text = [NSString stringWithFormat:@"%.3lf", (self.updateIntervalSlider.value)];
    
    self.scaleSlider.value = 1.0;
    self.scaleLabel.text = [NSString stringWithFormat:@"%.3lf", (self.scaleSlider.value)];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (IBAction)intervalChanged:(id)sender
{
    [self startUpdatesWithSliderValue:(int)(self.updateIntervalSlider.value)];
    [self.updateIntervalLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%.3lf", (self.updateIntervalSlider.value)] waitUntilDone:NO];
}


- (IBAction)scaleChanged:(id)sender
{
    [self.simpleGraphView setScale:self.scaleSlider.value];
    [self.scaleLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%.3lf", (self.scaleSlider.value)] waitUntilDone:NO];
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
    if ( [self.motionManager isMagnetometerActive] == YES ){
        [self.motionManager stopMagnetometerUpdates];
    }
}



- (void)startUpdatesWithSliderValue:(int)sliderValue
{
    
    NSTimeInterval updateInterval = 0.01 + 1.0/sliderValue;
    
    if ( [self.motionManager isDeviceMotionAvailable] &&  ![self.motionManager isMagnetometerActive] ){
        
        [self.motionManager setMagnetometerUpdateInterval:updateInterval];
        [self.motionManager startMagnetometerUpdates];
        
        [self.motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMagnetometerData *data, NSError *error){
        
            
            [self.simpleGraphView addX:[NSNumber numberWithDouble:data.magneticField.x] y:[NSNumber numberWithDouble:data.magneticField.y] z:[NSNumber numberWithDouble:data.magneticField.z]];
            
            
            [self.xLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"X: %.6lf MicroTesla", data.magneticField.x] waitUntilDone:NO];
            [self.yLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"Y: %.6lf MicroTesla", data.magneticField.y] waitUntilDone:NO];
            [self.zLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"Z: %.6lf MicroTesla", data.magneticField.z] waitUntilDone:NO];
            
         }];
    }
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
