//
//  GPSViewController.h
//  TestHardware
//
//  Created by Linda Cobb on 9/22/12.
//  Copyright (c) 2012 Linda Cobb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SimpleGraphView.h"


@interface GPSViewController : UIViewController <CLLocationManagerDelegate>


@property (strong, nonatomic) IBOutlet SimpleGraphView *simpleGraphView;

@property (strong, nonatomic) IBOutlet UILabel *xLabel;
@property (strong, nonatomic) IBOutlet UILabel *yLabel;
@property (strong, nonatomic) IBOutlet UILabel *zLabel;

@property (strong, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *longitudeLabel;

@property (strong, nonatomic) IBOutlet UILabel *speedLabel;
@property (strong, nonatomic) IBOutlet UILabel *headingLabel;
@property (strong, nonatomic) IBOutlet UILabel *altitudeLabel;

@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UIButton *startButton;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UISlider *scaleSlider;
@property (strong, nonatomic) IBOutlet UILabel *scaleLabel;


@property (strong, nonatomic) CLLocationManager *locationManager;



- (IBAction)segmentedControlChanged:(id)sender;
- (IBAction)scaleChanged:(id)sender;


- (IBAction)stop:(id)sender;
- (IBAction)start:(id)sender;

- (void)stopUpdates;






@end
