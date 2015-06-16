//
//  GyroViewController.h
//  TestHardware
//
//  Created by Linda Cobb on 9/20/12.
//  Copyright (c) 2012 Linda Cobb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "SimpleGraphView.h"


@interface GyroViewController : UIViewController 



@property (weak, nonatomic) IBOutlet UILabel *xLabel;
@property (weak, nonatomic) IBOutlet UILabel *yLabel;
@property (weak, nonatomic) IBOutlet UILabel *zLabel;

@property (weak, nonatomic) IBOutlet UILabel *updateIntervalLabel;
@property (weak, nonatomic) IBOutlet UISlider *updateIntervalSlider;
@property (weak, nonatomic) IBOutlet UILabel *scaleLabel;
@property (weak, nonatomic) IBOutlet UISlider *scaleSlider;

@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UIButton *startButton;

@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) IBOutlet SimpleGraphView *simpleGraphView;



- (IBAction)intervalChanged:(id)sender;
- (IBAction)scaleChanged:(id)sender;

- (IBAction)stop:(id)sender;
- (IBAction)start:(id)sender;
- (void)startUpdatesWithSliderValue:(int)sliderValue;
- (void)stopUpdates;


@end
