//
//  SoundViewController.h
//  TestHardware
//
//  Created by Linda Cobb on 9/22/12.
//  Copyright (c) 2012 Linda Cobb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioUnit/AudioUnit.h>
#import "SimpleGraphView.h"



@interface SoundViewController : UIViewController <AVCaptureAudioDataOutputSampleBufferDelegate>
{
    float scale;
}


@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureDeviceInput *inputDevice;
@property (strong, nonatomic) AVCaptureAudioDataOutput *audioDataOutput;

@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UISlider *scaleSlider;
@property (strong, nonatomic) IBOutlet UILabel *scaleLabel;

@property (weak, nonatomic) IBOutlet UILabel *xLabel;
@property (strong, nonatomic) IBOutlet SimpleGraphView *simpleGraphView;


- (IBAction)start:(id)sender;
- (IBAction)stop:(id)sender;
- (IBAction)changeScale:(id)sender;


@end
