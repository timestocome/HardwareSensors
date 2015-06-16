//
//  AccelerometerViewController.h
//  TestHardware
//
//  Created by Linda Cobb on 9/20/12.
//  Copyright (c) 2012 Linda Cobb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleGraphView.h"
#import <CoreMotion/CoreMotion.h>


@interface AccelerometerViewController : UIViewController <UIAccelerometerDelegate>


@property (strong, nonatomic) IBOutlet SimpleGraphView *simpleGraphView;

@property (strong, nonatomic) IBOutlet UILabel *xLabel;
@property (strong, nonatomic) IBOutlet UILabel *yLabel;
@property (strong, nonatomic) IBOutlet UILabel *zLabel;

@property (strong, nonatomic) IBOutlet UISlider *updateIntervalSlider;
@property (strong, nonatomic) IBOutlet UILabel *updateIntervalLabel;
@property (strong, nonatomic) IBOutlet UISlider *scaleSlider;
@property (strong, nonatomic) IBOutlet UILabel *scaleLabel;

@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UIButton *startButton;

@property (strong, nonatomic) CMMotionManager *motionManager;


- (IBAction)intervalChanged:(id)sender;
- (IBAction)scaleChanged:(id)sender;

- (IBAction)stop:(id)sender;
- (IBAction)start:(id)sender;
- (void)startUpdatesWithSliderValue:(int)sliderValue;

@end
