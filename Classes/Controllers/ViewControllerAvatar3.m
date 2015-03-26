//
//  ViewControllerAvatar3.m
//  KegCop
//
//  Created by capin on 11/13/14.
//
//

#import "ViewControllerAvatar3.h"

@interface ViewControllerAvatar3 () <AVCaptureVideoDataOutputSampleBufferDelegate>
@property (strong, nonatomic) IBOutlet UIView *frameForCapture;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) dispatch_queue_t sampleQueue;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
- (IBAction)dismissScene:(id)sender;

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
//        self.previewLayer.frame = self.view.layer.bounds;
    
        // replaced view with frameForCapture
        
        self.previewLayer.frame = self.frameForCapture.layer.bounds;
        self.frameForCapture.layer.masksToBounds = YES;
        self.frameForCapture.layer.backgroundColor = [[UIColor blackColor] CGColor];
        [self.frameForCapture.layer addSublayer:self.previewLayer];
        
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

- (IBAction)dismissScene:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end