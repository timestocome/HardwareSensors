//
//  VideoViewController.h
//  TestHardware
//
//  Created by Linda Cobb on 9/22/12.
//  Copyright (c) 2012 Linda Cobb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreMedia/CoreMedia.h>

#define IMAGE_SIZE          100             // number of pixels width and height
#define NUMBER_OF_PIXELS    IMAGE_SIZE * IMAGE_SIZE



@interface VideoViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    BOOL lightOn;
    BOOL cameraOn;
    NSInteger  quality;
    
    
    CGRect          cropRect;
    CGImageRef      croppedRef;
    
    int             r, g, b, a;
    int             previousR, previousG, previousB;
    int             dr, dg, db;

    double          averageRed, averageGreen, averageBlue;
}


@property (nonatomic, retain) AVCaptureSession *session;

@property (nonatomic, strong) AVCaptureDevice *videoDevice;
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *dataOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;


@property (weak, nonatomic) IBOutlet UIImageView *unfilteredView;
@property (nonatomic, strong) CIImage *ciImage;
@property (nonatomic, strong) CIContext *context;

@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, weak) IBOutlet UILabel *redLabel;
@property (nonatomic, weak) IBOutlet UILabel *blueLabel;
@property (nonatomic, weak) IBOutlet UILabel *greenLabel;




- (IBAction)start:(id)sender;
- (IBAction)stop:(id)sender;
- (IBAction)light:(id)sender;
- (IBAction)qualityChange:(id)sender;


@end
