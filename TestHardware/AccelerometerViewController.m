//
//  AccelerometerViewController.m
//  TestHardware
//
//  Created by Linda Cobb on 9/20/12.
//  Copyright (c) 2012 Linda Cobb. All rights reserved.
//

#import "AccelerometerViewController.h"
#import "AppDelegate.h"


static const NSTimeInterval accelerometerMin = 0.01;
//static const NSTimeInterval delta = 0.01;



@implementation AccelerometerViewController



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
    
    self.updateIntervalSlider.value = 0.5;
    self.updateIntervalLabel.text = [NSString stringWithFormat:@"%d", (int)(self.updateIntervalSlider.value)];
    
    self.scaleSlider.value = 1.0;
    self.scaleLabel.text = [NSString stringWithFormat:@"%d", (int)(self.scaleSlider.value)];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}


- (void)startUpdatesWithSliderValue:(int)sliderValue;
{
     
    NSTimeInterval updateInterval = accelerometerMin + 1.0/sliderValue;
    
    
    if ( [self.motionManager isAccelerometerAvailable] == YES){
        [self.motionManager setAccelerometerUpdateInterval:updateInterval];
        
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            [self.simpleGraphView addX:[NSNumber numberWithDouble:accelerometerData.acceleration.x]
                               y:[NSNumber numberWithDouble:accelerometerData.acceleration.y]
                               z:[NSNumber numberWithDouble:accelerometerData.acceleration.z]];
            [self.xLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"X: %.6lf g", accelerometerData.acceleration.x] waitUntilDone:NO];
            [self.yLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"Y: %.6lf g", accelerometerData.acceleration.y] waitUntilDone:NO];
            [self.zLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"Z: %.6lf g", accelerometerData.acceleration.z] waitUntilDone:NO];
            
        }];
        
    }
        
}

                   

- (IBAction)scaleChanged:(id)sender
{
    [self.simpleGraphView setScale:self.scaleSlider.value];
    [self.scaleLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%d", (int)(self.scaleSlider.value)] waitUntilDone:NO];
    
}

                   
                   
- (IBAction)intervalChanged:(id)sender
{
    [self startUpdatesWithSliderValue:(int)(self.updateIntervalSlider.value)];
 
    [self.updateIntervalLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%d", (int)(self.updateIntervalSlider.value)] waitUntilDone:NO];
    
}



- (IBAction)start:(id)sender
{
    [self startUpdatesWithSliderValue:(int)(self.updateIntervalSlider.value)];

}



- (IBAction)stop:(id)sender
{
    if ( [self.motionManager isAccelerometerActive] == YES ){
        [self.motionManager stopAccelerometerUpdates];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stop:self];
}



@end
