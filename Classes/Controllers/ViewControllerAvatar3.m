//
//  ViewControllerAvatar3.m
//  KegCop
//
//  Created by capin on 11/13/14.
//
//

#import "ViewControllerAvatar3.h"
@import AVFoundation;

@interface ViewControllerAvatar3 () <AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) dispatch_queue_t sampleQueue;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation ViewControllerAvatar3;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"reach ViewControllerAvatar3 viewDidLoad method");
    
    self.session = [[AVCaptureSession alloc] init];
    
    AVCaptureDevice *device = [self frontCamera];
    
    if (!device) {
        NSLog(@"Couldn't get a camera.");
        return;
    }
    
    NSError *error;
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    
    if (input) {
        [self.session addInput:input];
        
        AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
        
        self.sampleQueue = dispatch_queue_create("VideoSampleQueue", DISPATCH_QUEUE_SERIAL);
        
        [output setSampleBufferDelegate:self queue:self.sampleQueue];
        [self.session addOutput:output];
        
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        self.previewLayer.frame = self.view.layer.bounds;
        self.view.layer.masksToBounds = YES;
        self.view.layer.backgroundColor = [[UIColor blackColor] CGColor];
        [self.view.layer addSublayer:self.previewLayer];
        
        [self.session startRunning];
    } else {
        NSLog(@"Couldn't init device input: %@", error);
    }
}

- (AVCaptureDevice *)frontCamera {
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
    
    }
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
  didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
}

@end