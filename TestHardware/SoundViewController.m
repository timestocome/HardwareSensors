//
//  SoundViewController.m
//  TestHardware
//
//  Created by Linda Cobb on 9/22/12.
//  Copyright (c) 2012 Linda Cobb. All rights reserved.
//

#import "SoundViewController.h"
#import <CoreMedia/CoreMedia.h>



@implementation SoundViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    scale = 1.0;
    [self.scaleSlider setValue:scale];
    self.scaleLabel.text = [NSString stringWithFormat:@"%.2lf", scale];
    [self.simpleGraphView setScale:self.scaleSlider.value];
}





- (void)setupCaptureSession
{
    
    // set up session
    self.captureSession = [[AVCaptureSession alloc] init];
    
    // add inputs and outputs
    NSError *error = nil;
    
    //inputs
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    NSLog(@"setup sound error? %@", error.userInfo);
    
    if ( [self.captureSession canAddInput:captureDeviceInput] ){
        [self.captureSession addInput:captureDeviceInput];
        NSLog(@"added capture device");
    }
    
    // outputs
    AVCaptureAudioDataOutput *captureAudioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
    [self.captureSession addOutput:captureAudioDataOutput];
    
    dispatch_queue_t queue = dispatch_queue_create("com.timestocomemobile.queue", NULL);
    [captureAudioDataOutput setSampleBufferDelegate:self queue:queue];
    
}



- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    NSLog(@"capturing output");
    
    CMFormatDescriptionRef item = CMSampleBufferGetFormatDescription(sampleBuffer);
    const AudioStreamBasicDescription *formatDescription = CMAudioFormatDescriptionGetStreamBasicDescription(item);
    UInt32 sampleRate;
    UInt32 channelCount;
    
    
    if ( formatDescription){
        sampleRate = formatDescription->mSampleRate;
        channelCount = formatDescription->mChannelsPerFrame;
    }
    
    UInt64 totalBytes = 0;
    
    
    if (sampleBuffer){
        
        CMBlockBufferRef blockBufferRef = CMSampleBufferGetDataBuffer(sampleBuffer);
        size_t length = CMBlockBufferGetDataLength(blockBufferRef);
        totalBytes += length;
        NSMutableData *data = [NSMutableData dataWithLength:length];
        CMBlockBufferCopyDataBytes(blockBufferRef, 0, length, data.mutableBytes);
        SInt16 *samples = (SInt16 *)data.mutableBytes;
        
        
        // data for graph
        double soundData = *samples;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.simpleGraphView addX:[NSNumber numberWithDouble:soundData] y:[NSNumber numberWithDouble:0.0] z:[NSNumber numberWithDouble:0.0]];
            [self.xLabel setText:[NSString stringWithFormat:@"X: %d", *samples]];
            
        });
    }
}






- (IBAction)changeScale:(id)sender
{
    [self stop:self];

    scale = [self.scaleSlider value];
    self.scaleLabel.text = [NSString stringWithFormat:@"%.2lf", scale];
    [self.simpleGraphView setScale:self.scaleSlider.value];

    
    [self start:self];
}







- (IBAction)start:(id)sender
{
    //  handle setup
    [self setupCaptureSession];
    [self.captureSession startRunning];
}





- (IBAction)stop:(id)sender
{
    [self.captureSession stopRunning];
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
