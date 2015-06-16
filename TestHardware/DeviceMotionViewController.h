//
//  DeviceMotionViewController.h
//  TestHardware
//
//  Created by Linda Cobb on 9/20/12.
//  Copyright (c) 2012 Linda Cobb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "SimpleGraphView.h"


@interface DeviceMotionViewController : UIViewController


@property (strong, nonatomic) IBOutlet UILabel *xLabel;
@property (strong, nonatomic) IBOutlet UILabel *yLabel;
@property (strong, nonatomic) IBOutlet UILabel *zLabel;

@property (strong, nonatomic) IBOutlet UISlider *updateIntervalSlider;
@property (strong, nonatomic) IBOutlet UILabel *updateIntervalLabel;
@property (strong, nonatomic) IBOutlet UISlider *scaleSlider;
@property (strong, nonatomic) IBOutlet UILabel *scaleLabel;

@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UIButton *startButton;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) IBOutlet SimpleGraphView *simpleGraphView;


- (IBAction)intervalChanged:(id)sender;
- (IBAction)scaleChanged:(id)sender;
- (IBAction)segmentedControlChanged:(id)sender;


- (IBAction)stop:(id)sender;
- (IBAction)start:(id)sender;

- (void)startUpdatesWithSliderValue:(int)sliderValue;
- (void)stopUpdates;


typedef enum {
    DeviceMotionGraphTypeAttitude = 0,
    DeviceMotionGraphTypeRotationRate = 1,
    DeviceMotionGraphTypeGravity = 2,
    DeviceMotionGraphTypeUserAcceleration = 3
} DeviceMotionGraphType;



@end
