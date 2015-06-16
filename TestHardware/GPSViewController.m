//
//  GPSViewController.m
//  TestHardware
//
//  Created by Linda Cobb on 9/22/12.
//  Copyright (c) 2012 Linda Cobb. All rights reserved.
//

#import "GPSViewController.h"



@implementation GPSViewController


dispatch_queue_t    mainQueue;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    mainQueue = dispatch_queue_create("com.timestocomemobile.walktracker.queue", nil);
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
}




- (IBAction)segmentedControlChanged:(id)sender
{
    if ( [self.segmentedControl selectedSegmentIndex] == 0 ){
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }else if ( [self.segmentedControl selectedSegmentIndex]  == 1 ){
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    }else if ( [self.segmentedControl selectedSegmentIndex] == 2 ){
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }else if ( [self.segmentedControl selectedSegmentIndex] == 3 ){
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    }
    
    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];
}




- (IBAction)scaleChanged:(id)sender
{
    [self.simpleGraphView setScale:self.scaleSlider.value];
    [self.scaleLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%d", (int)(self.scaleSlider.value)] waitUntilDone:NO];
    
}




- (IBAction)start:(id)sender
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];
}




- (IBAction)stop:(id)sender
{
    [self stopUpdates];
}


- (void)stopUpdates
{
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopUpdatingHeading];
    
    self.locationManager = nil;
}



- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    [self.headingLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"Head: %.6lf", newHeading.magneticHeading] waitUntilDone:NO];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    double distanceH = [newLocation distanceFromLocation:oldLocation];
    double distanceV = newLocation.altitude - oldLocation.altitude;
    double rotation = newLocation.course;
    
    
    [self.simpleGraphView addX:[NSNumber numberWithDouble:distanceH] y:[NSNumber numberWithDouble:distanceV] z:[NSNumber numberWithDouble:rotation]];
    
                    
    [self.xLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"distance H: %.6lf", distanceH] waitUntilDone:NO];
    [self.yLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"distance V: %.6lf", distanceV] waitUntilDone:NO];
    [self.zLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"rotation: %.6lf", newLocation.course] waitUntilDone:NO];
    
                    
    [self.latitudeLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"Lat: %.6lf", newLocation.coordinate.latitude] waitUntilDone:NO];
    [self.longitudeLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"Long: %.6lf", newLocation.coordinate.longitude] waitUntilDone:NO];
    
    [self.speedLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"Speed: %.6lf", newLocation.speed] waitUntilDone:NO];
    [self.altitudeLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"Alt: %.6lf", newLocation.altitude] waitUntilDone:NO];
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
