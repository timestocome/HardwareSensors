//
//  DeviceMotionViewController.m
//  TestHardware
//
//  Created by Linda Cobb on 9/20/12.
//  Copyright (c) 2012 Linda Cobb. All rights reserved.
//

#import "DeviceMotionViewController.h"
#import "AppDelegate.h"


static const NSTimeInterval deviceMotionMin = 0.01;



@implementation DeviceMotionViewController



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
    
    [self.updateIntervalSlider setValue:10.0];
    self.updateIntervalLabel.text = [NSString stringWithFormat:@"%d", (int)self.updateIntervalSlider.value];
    
    [self.scaleSlider setValue:10.0];
    self.scaleLabel.text = [NSString stringWithFormat:@"%d", (int)self.scaleSlider.value];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
}


- (IBAction)intervalChanged:(id)sender
{
    [self startUpdatesWithSliderValue:(int)self.updateIntervalSlider.value];
    
    [self.updateIntervalLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%d", (int)self.updateIntervalSlider.value] waitUntilDone:NO];
}




- (IBAction)scaleChanged:(id)sender
{
    [self.simpleGraphView setScale:self.scaleSlider.value];
    [self.scaleLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%d", (int)self.scaleSlider.value] waitUntilDone:NO];    
}



- (IBAction)segmentedControlChanged:(id)sender
{    
    [self startUpdatesWithSliderValue:(int)(self.updateIntervalSlider.value)];
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
    if ( [self.motionManager isDeviceMotionActive] == YES ){
        [self.motionManager stopDeviceMotionUpdates];
    }
    
    if ( [self.motionManager isAccelerometerActive] == YES){
        [self.motionManager stopAccelerometerUpdates];
    }
    
    if ( [self.motionManager isGyroActive] == YES){
        [self.motionManager stopGyroUpdates];
    }
    
}



- (void)startUpdatesWithSliderValue:(int)sliderValue
{
    
    NSTimeInterval updateInterval = deviceMotionMin + 1.0/sliderValue;
    
    if ([self.motionManager isDeviceMotionAvailable] == YES) {
        
        [self.motionManager setDeviceMotionUpdateInterval:updateInterval];
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            
                      
            switch (self.segmentedControl.selectedSegmentIndex) {
                    
                case DeviceMotionGraphTypeAttitude:
                                        
                    // attitude
                    [self.simpleGraphView addX:[NSNumber numberWithDouble:motion.attitude.roll] y:[NSNumber numberWithDouble:motion.attitude.pitch] z:[NSNumber numberWithDouble:motion.attitude.yaw]];
                                        
                    [self.xLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"X: %.6lf roll", motion.attitude.roll] waitUntilDone:NO];
                    [self.yLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"Y: %.6lf pitch", motion.attitude.pitch] waitUntilDone:NO];
                    [self.zLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"Z: %.6lf yaw", motion.attitude.yaw] waitUntilDone:NO];

                    break;
                    
                case DeviceMotionGraphTypeRotationRate:
                                        
                    // rotationRate
                    [self.simpleGraphView addX:[NSNumber numberWithDouble:motion.rotationRate.x] y:[NSNumber numberWithDouble:motion.rotationRate.y] z:[NSNumber numberWithDouble:motion.rotationRate.z]];
                    
                    [self.xLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"X: %.6lf rotation", motion.rotationRate.x] waitUntilDone:NO];
                    [self.yLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"Y: %.6lf rotation", motion.rotationRate.y] waitUntilDone:NO];
                    [self.zLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"Z: %.6lf rotation", motion.rotationRate.z] waitUntilDone:NO];
                    
                    break;
                    
                    
                case DeviceMotionGraphTypeGravity:
                    
                    // gravity
                    [self.simpleGraphView addX:[NSNumber numberWithDouble:motion.gravity.x] y:[NSNumber numberWithDouble:motion.gravity.y] z:[NSNumber numberWithDouble:motion.gravity.z]];
                    
                    [self.xLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"X: %.6lf gravity", motion.gravity.x] waitUntilDone:NO];
                    [self.yLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"Y: %.6lf gravity", motion.gravity.y] waitUntilDone:NO];
                    [self.zLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"Z: %.6lf gravity", motion.gravity.z] waitUntilDone:NO];
                    
                    break;
                    
                    
                case DeviceMotionGraphTypeUserAcceleration:
                    
                    // userAcceleration
                    [self.simpleGraphView addX:[NSNumber numberWithDouble:motion.userAcceleration.x] y:[NSNumber numberWithDouble:motion.userAcceleration.y] z:[NSNumber numberWithDouble:motion.userAcceleration.z]];

                    
                    [self.xLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"X: %.6lf acceleration", motion.userAcceleration.x] waitUntilDone:NO];
                    [self.yLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"Y: %.6lf acceleration", motion.userAcceleration.y] waitUntilDone:NO];
                    [self.zLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"Z: %.6lf acceleration", motion.userAcceleration.z] waitUntilDone:NO];
                    
                    break;
                    
                    
                default:
                    
                    break;
            }
        }];
    }
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
