//
//  AltimeterViewController.h
//  TestHardware
//
//  Created by Linda Cobb on 9/22/14.
//  Copyright (c) 2014 Linda Cobb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "SimpleGraphView.h"



@interface AltimeterViewController : UIViewController



@property (weak, nonatomic) IBOutlet UILabel *xLabel;
@property (weak, nonatomic) IBOutlet UILabel *yLabel;
@property (weak, nonatomic) IBOutlet UILabel *zLabel;

@property (weak, nonatomic) IBOutlet UILabel *updateIntervalLabel;
@property (weak, nonatomic) IBOutlet UISlider *updateIntervalSlider;
@property (weak, nonatomic) IBOutlet UILabel *scaleLabel;
@property (weak, nonatomic) IBOutlet UISlider *scaleSlider;

@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UIButton *startButton;

@property (strong, nonatomic) CMAltimeter *altimeter;
@property (strong, nonatomic) IBOutlet SimpleGraphView *simpleGraphView;



- (IBAction)intervalChanged:(id)sender;
- (IBAction)scaleChanged:(id)sender;

- (IBAction)stop:(id)sender;
- (IBAction)start:(id)sender;
- (void)startUpdatesWithSliderValue:(int)sliderValue;
- (void)stopUpdates;


@end
