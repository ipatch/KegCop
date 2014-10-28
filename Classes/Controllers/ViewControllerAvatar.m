//
//  ViewControllerAvatar.m
//  KegCop
//
//  Created by capin on 10/28/14.
//
//

#import "ViewControllerAvatar.h"

@implementation ViewControllerAvatar

// AV camera variables / settings
@synthesize captureSession = _captureSession;
@synthesize imageView = _imageView;
@synthesize customLayer = _customLayer;
@synthesize prevLayer = _prevLayer;


#pragma mark -
#pragma mark Initialization
- (id)init {
    self = [super init];
    if (self) {
        /* We initialize some variables (they might be not initialized depending on what is commented or not)*/
        self.imageView = nil;
        self.prevLayer = nil;
        self.customLayer = nil;
    }
    return self;
}

- (void)initCapture {
    /*We setup the input*/
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] error:nil];
    
    /* we setup the output */
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    // while a frame is proccess in -captureOutput:didOutputSampleBuffer:fromConnection: delegate methods no other frames are added in the queue.
    // If you don't want this behavior set the property to NO.
    
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    /* we specify a minimum duration for each frame (play with this settings
     to avoid having too many frames waiting in the queue because it can cause memory issues).  It is similar to the inverse of the maximum framerate.
     In this example we set a min frame duration of 1/10 seconds so a maximum
     framerate of 10fps. We say that we are not able to process more than 10 frames per second. */
    //captureOutput.minFrameDuration = CMTimeMake(1, 10);
    
    /*We create a serial queue to handle the processing of our frames*/
    dispatch_queue_t queue;
    queue = dispatch_queue_create("cameraQueue", NULL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    
    // comment the below line because project is using ARC
    
    // dispatch_release(queue);
    
    
     // set the video output to store frame in BGRA (It is supposed to be faster)
     NSDictionary* videoSettings = @{(__bridge NSString*)kCVPixelBufferPixelFormatTypeKey: [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA]};
     [captureOutput setVideoSettings:videoSettings];
     // and we create a capture session
     self.captureSession = [[AVCaptureSession alloc] init];
     // we add input and ouput
     [self.captureSession addInput:captureInput];
     [self.captureSession addOutput:captureOutput];
    /* we use medium quality, on the iPhone 4 this demo would be laging too much,
     the conversion in UIImage and CGImage demands too much resources for a 720p resolution. */
     [self.captureSession setSessionPreset:AVCaptureSessionPresetMedium];
     // we add custom layer (we need to change the orientation of the layer so that video is displayed correctly.
     self.customLayer = [CALayer layer];
     self.customLayer.frame = self.view.bounds;
     self.customLayer.transform = CATransform3DRotate(CATransform3DIdentity, M_PI/2.0f, 0, 0,1);
     self.customLayer.contentsGravity = kCAGravityResizeAspectFill;
     [self.view.layer addSublayer:self.customLayer];
     // we add the imageview
     self.imageView = [[UIImageView alloc] init];
     self.imageView.frame = CGRectMake(0, 0, 100, 100);
     [self.view addSubview:self.imageView];
     // we add the preview layer
     self.prevLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.captureSession];
     self.prevLayer.frame = CGRectMake(100, 0, 100, 100);
     self.prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
     [self.view.layer addSublayer: self.prevLayer];
     // we start the capture
     [self.captureSession startRunning];
}

#pragma mark -
#pragma mark AVCaptureSession delegate
     - (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
    {
     
     /* we create an autorelease pool because we are not in the main_queue our code is not executed in the main thread.  So we have to create an autorelease pool for the thread we are in */
        
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        // lock the image buffer
        CVPixelBufferLockBaseAddress(imageBuffer,0);
        // get information about the image
        uint8_t *baseAddress = (uint8_t *)CVPixelGetBaseAddress(imageBuffer);
        size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
        size_t width = CVPixelBufferGetWidth(imageBuffer);
        size_t height = CVPixelBufferGetHeight(imageBuffer);
        
        /*Create a CGImageRef from the CVImageBufferRef*/
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
        CGImageRef newImage = CGBitmapContextCreateImage(newContext);
        // the below line from the tut does not work!
        // CGImageRef newImage = CGBitmapContextCreate(newContext);
        
        // we release some components
        CGContextRelease(newContext);
        CGColorSpaceRelease(colorSpace);
        
    
  //      [self.customLayer performOnMainThread:@selector(setContents:)withObject: (id) newImage waitUntilDone:YES];
        
        
        dispatch_sync(dispatch_get_main_queue(),^{
            [self.customLayer setContents:(__bridge id)newImage];
        });
    
        /* we display the result on the image view (we need to change the orientation of the image so that the video is displayed correctly.)
         same thing as for the CALayer we are not in the main thread so ... */
        
        UIImage *image = [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight];
        
        // we release the CGImageRef
        CGImageRelease(newImage);
        
        // the below line from the tut is obsolete
        
        // [self.imageView performSelectorOnMainThread:@selector(setImage:)withObject:image waitUntilDone:YES];
        
        dispatch_sync(dispatch_get_main_queue(),^{
            [self.imageView setImage:image];
        });
        
        // we unlock the image buffer
        CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    }

@end
