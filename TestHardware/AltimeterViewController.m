//
//  AltimeterViewController.m
//  TestHardware
//
//  Created by Linda Cobb on 9/22/14.
//  Copyright (c) 2014 Linda Cobb. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AltimeterViewController.h"
#import "AppDelegate.h"



@implementation AltimeterViewController





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _altimeter = [[CMAltimeter alloc] init];
    
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
        [self.altimeter stopRelativeAltitudeUpdates];
}



- (void)startUpdatesWithSliderValue:(int)sliderValue
{
    
    if ( [CMAltimeter isRelativeAltitudeAvailable] ){
        
        [self.altimeter startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData *data, NSError *error){
            
            [self.simpleGraphView addX:data.relativeAltitude y:data.pressure z:[NSNumber numberWithDouble:0.0]];
            
            
            [self.xLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"X: %@ meters", data.relativeAltitude] waitUntilDone:NO];
            [self.yLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"Y: %@ kilopascals", data.pressure] waitUntilDone:NO];
           
            
        }];
    }
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
