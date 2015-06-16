//
//  VideoViewController.m
//  TestHardware
//
//  Created by Linda Cobb on 9/22/12.
//  Copyright (c) 2012 Linda Cobb. All rights reserved.
//

#import "VideoViewController.h"


@implementation VideoViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    lightOn = NO;
    quality = 0;
}


- (IBAction)start:(id)sender
{
    [self setupCameraSession];
    cameraOn = YES;
}


- (IBAction)stop:(id)sender
{
    [self.session stopRunning];
    [self.previewLayer removeFromSuperlayer];
    self.previewLayer = nil;

    cameraOn = NO;
}





// grab the images from the camera and crop them
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    self.ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    
    
    // get the image from the camera
    CGImageRef ref = [self.context createCGImage:self.ciImage fromRect:self.ciImage.extent];
    
    // crop the image to cut down on data processing
    cropRect = CGRectMake(90.0, 90.0, IMAGE_SIZE, IMAGE_SIZE );  // grab center of image
    croppedRef = CGImageCreateWithImageInRect(ref, cropRect);
    CIImage *croppedImage = [[CIImage alloc] initWithCGImage:croppedRef];
    
    
    // send the cropped image out to device screen
    self.unfilteredView.image = [UIImage imageWithCGImage:croppedRef scale:1.0 orientation:UIImageOrientationRight];
    
    // get pixel data
    // ***** need to put this in a separate thread
    [self grabRedGreenBlue:croppedImage];
    
    // clean up
    CGImageRelease(ref);
}




// grab rgb values for each pixel and pass off data to FFT and graph functions
- (void)grabRedGreenBlue:(CIImage *)image
{
    // First get the image into your data buffer
    int byteSize = 8;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 8;
    unsigned char rawData[NUMBER_OF_PIXELS * bytesPerPixel];
    NSUInteger bytesPerRow = bytesPerPixel * IMAGE_SIZE;
    NSUInteger bitsPerComponent = byteSize;
    
    CGContextRef context = CGBitmapContextCreate(rawData, IMAGE_SIZE, IMAGE_SIZE,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    
    
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = 0;
    r = 0;
    g = 0;
    b = 0;
    a = 0;
    for (int i=0; i < NUMBER_OF_PIXELS; i++)
    {
        // scale is 0-255 for rgb color
        r += rawData[byteIndex];
        b += rawData[byteIndex + 1];
        g += rawData[byteIndex + 2];
        a += rawData[byteIndex + 3];

        
       // NSLog(@"rgba %d %d %d %d", rawData[byteIndex], rawData[byteIndex + 1], rawData[byteIndex + 2], rawData[byteIndex + 3]);
        
        //byteIndex += byteSize;
        byteIndex += 8;
    }
    
    float totalPixels = (float)NUMBER_OF_PIXELS;
    
    NSLog(@"total argb %d %d  %d  %d  ", a,  r, g, b );
    
    // one number averaged color per frame
    averageRed = r / totalPixels;
    averageGreen = g / totalPixels;
    averageBlue = b / totalPixels;
    
    
    [self.redLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%lf", averageRed] waitUntilDone:NO];
    [self.greenLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%lf", averageGreen] waitUntilDone:NO];
    [self.blueLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%lf", averageBlue] waitUntilDone:NO];

    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
}






- (IBAction)light:(id)sender
{
    
    NSError *error;
    
    if ( lightOn == NO ){
        
        [self.session beginConfiguration];
        [self.videoDevice lockForConfiguration:&error];
        [self.videoDevice setTorchMode:AVCaptureTorchModeOn];
        [self.videoDevice unlockForConfiguration];
        [self.session commitConfiguration];
        
        lightOn = YES;
        
    }else{
        
        [self.session beginConfiguration];
        [self.videoDevice lockForConfiguration:&error];
        [self.videoDevice setTorchMode:AVCaptureTorchModeOff];
        [self.videoDevice unlockForConfiguration];
        [self.session commitConfiguration];
        
        lightOn = NO;
    }
}









- (IBAction)qualityChange:(id)sender
{
    [self stop:self];
    quality = [self.segmentedControl selectedSegmentIndex];
    [self start:self];
}


- (void)setupCameraSession
{
    
    // Session
    self.session = [AVCaptureSession new];
    
    
    // recording quality
    quality = [self.segmentedControl selectedSegmentIndex];

    if ( quality <= 0 ){
        [self.session setSessionPreset:AVCaptureSessionPresetLow];
    }else if ( quality == 1 ){
        [self.session setSessionPreset:AVCaptureSessionPresetMedium];
    }else if ( quality == 2 ){
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    }else if ( quality == 3 ){
        [self.session setSessionPreset:AVCaptureSessionPreset640x480];
    }else{
        [self.session setSessionPreset:AVCaptureSessionPresetiFrame1280x720];
    }
        
        
    
    // find and use back facing camera
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in videoDevices){
        if ( device.position == AVCaptureDevicePositionBack){
            self.videoDevice = device;
            break;
        }
    }
    
    
    NSError *error;
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:&error];
    self.dataOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.dataOutput.videoSettings = [NSDictionary dictionaryWithObject:
                                     [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]
                                                                forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    [self.session addInput:self.videoInput];
    [self.session addOutput:self.dataOutput];
    
    
    [self.dataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    [self.session startRunning];
    
}



-(CIContext *)context
{
    if (!_context) _context = [CIContext contextWithOptions:nil];
    return _context;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
