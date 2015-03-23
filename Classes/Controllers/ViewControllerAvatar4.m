//
//  ViewControllerAvatar4.m
//  KegCop
//
//  Created by capin on 3/21/15.
//
//

#import "ViewControllerAvatar4.h"
#import <ImageIO/CGImageProperties.h>
@import AVFoundation;

@interface ViewControllerAvatar4 ()

@property(nonatomic, retain) IBOutlet UIView *vImagePreview;
@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic, retain) IBOutlet UIImageView *vImage;

@end
    
@implementation ViewControllerAvatar4

-(void)viewDidLoad {
    NSLog(@"inside viewDidLoad of ViewControllerAvatar4");
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    CALayer *viewLayer = self.vImagePreview.layer;
    NSLog(@"viewLayer = %@", viewLayer);
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
    
    captureVideoPreviewLayer.frame = self.vImagePreview.bounds;
    [self.vImagePreview.layer addSublayer:captureVideoPreviewLayer];
    
    AVCaptureDevice *device = [self frontCamera];
    
    if (!device) {
        NSLog(@"Couldn't get a camera.");
        return;
    }
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        // handle the error
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    [session addInput:input];
    
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [_stillImageOutput setOutputSettings:outputSettings];
    [session addOutput:_stillImageOutput];
    
    [session startRunning];
    
    
    // add UIToolbar to imageView
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, self.vImage.frame.size.width, 44);
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                             style:UIBarButtonItemStyleDone
                                                            target:self
                                                            action:@selector(done)];
    [toolbar setItems:[[NSArray alloc] initWithObjects:done, nil]];
    
    [self.vImage addSubview:toolbar];
    // the below line will hopefully make the toolbar selectable
    [self.vImage bringSubviewToFront:toolbar];
    // more tshooting
    toolbar.userInteractionEnabled = YES;
    
}

- (AVCaptureDevice *)frontCamera {
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
        
    }
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}

-(IBAction)captureNow {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo])
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection)
        {
            break;
        }
    }
    
    NSLog(@"about to request a capture from %@", _stillImageOutput);
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments)
         {
             // do something with the attachments.
             NSLog(@"attachments: %@", exifAttachments);
         } else {
             NSLog(@"no attachments");
         }
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         
         self.vImage.image = image;
         
         UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
     }];
}

-(void)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
