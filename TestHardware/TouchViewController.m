//
//  TouchViewController.m
//  TestHardware
//
//  Created by Linda Cobb on 9/23/12.
//  Copyright (c) 2012 Linda Cobb. All rights reserved.
//

#import "TouchViewController.h"


@implementation TouchViewController





- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}

    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIGestureRecognizer* tapGesture = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGesture];
    
    UIGestureRecognizer* pinchGesture = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.view addGestureRecognizer:pinchGesture];
    
    UIGestureRecognizer* rotationGesture = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    [self.view addGestureRecognizer:rotationGesture];
    
    UIGestureRecognizer* swipeGesture = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [self.view addGestureRecognizer:swipeGesture];
    
    UIGestureRecognizer* longTapGesture = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongTap:)];
    [self.view addGestureRecognizer:longTapGesture];
    
    UIGestureRecognizer* panGesture = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:panGesture];

    
}



- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    [self.xStart setText:[NSString stringWithFormat:@"Scale: %lf", recognizer.scale]];
    [self.yStart setText:[NSString stringWithFormat:@"Velocity: %lf", recognizer.velocity]];
    
    [self.gestureType setText:@"Pinch"];
}





- (IBAction)handleTap: (UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.view];
    
    [self.xStart setText:[NSString stringWithFormat:@"X: %lf", location.x]];
    [self.yStart setText:[NSString stringWithFormat:@"Y: %lf", location.y]];
    
    [self.gestureType setText:@"Tap"];
}




- (IBAction)handleRotation:(UIRotationGestureRecognizer *)recognizer
{
    [self.xStart setText:[NSString stringWithFormat:@"rotation: %lf", recognizer.rotation]];
    [self.yStart setText:[NSString stringWithFormat:@"velocity: %lf", recognizer.velocity]];
    
    
    [self.gestureType setText:@"Rotation"];
}




- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)recognizer
{
    if ( recognizer.direction == UISwipeGestureRecognizerDirectionUp){
        [self.xStart setText:@"Up"];
    }else if ( recognizer.direction == UISwipeGestureRecognizerDirectionDown){
        [self.xStart setText:@"Down"];
    }else if ( recognizer.direction == UISwipeGestureRecognizerDirectionRight){
        [self.xStart setText:@"Right"];
    }else if ( recognizer.direction == UISwipeGestureRecognizerDirectionLeft){
        [self.xStart setText:@"Left"];
    }
    
    [self.gestureType setText:@"Swipe"];

}




- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation =  [recognizer translationInView:self.view];
    CGPoint velocity = [recognizer velocityInView:self.view];
    
    [self.xStart setText:[NSString stringWithFormat:@"translation: %lf %lf", translation.x, translation.y]];
    [self.yStart setText:[NSString stringWithFormat:@"velocity: %lf %lf", velocity.x, velocity.y]];
    
    [self.gestureType setText:@"Pan"];
}




- (IBAction)handleLongTap:(UILongPressGestureRecognizer *)recognizer
{
    [self.gestureType setText:@"Long press"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
