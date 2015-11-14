//
//  ViewControllerAvatar4.m
//  KegCop
//
//  Created by capin on 3/21/15.
//
//

#import "ViewControllerAvatar4.h"
#import <ImageIO/CGImageProperties.h>
#import "AccountsDataModel.h"
#import "Account.h"
@import AVFoundation;

@interface ViewControllerAvatar4 ()

@property(nonatomic, retain) IBOutlet UIView *vImagePreview;
@property(nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic, retain) IBOutlet UIImageView *vImage;
@property(nonatomic, retain) NSData *dataImage;
@property(nonatomic, retain) UIImage *image;
@property(nonatomic, retain) UIImage *croppedImage;
// Core Data
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
    
@implementation ViewControllerAvatar4

# pragma mark - view Did Load
-(void)viewDidLoad {
    // Core Data
    if (_managedObjectContext == nil)
    {
        _managedObjectContext = [[AccountsDataModel sharedDataModel]mainContext];
#ifdef DEBUG
        NSLog(@"After _managedObjectContext: %@",  _managedObjectContext);
#endif
    }
    // Core Data END
    
    // retreive parent vc data
    NSDictionary *dataFromParent = [self.delegate giveMeData];
#ifdef DEBUG
    NSLog(@"dataFromParent = %@",dataFromParent);
    NSLog(@"Value for arrayKey: %@", [dataFromParent objectForKey:@"username"]);
#endif
    NSArray *values = [dataFromParent allValues];

    NSLog(@"Values: %@", values);

    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    CALayer *viewLayer = self.vImagePreview.layer;

    NSLog(@"viewLayer = %@", viewLayer);

    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
    
    captureVideoPreviewLayer.frame = self.vImagePreview.bounds;
    [self.vImagePreview.layer addSublayer:captureVideoPreviewLayer];
    
    AVCaptureDevice *device = [self frontCamera];
    
    if (!device) {
#ifdef DEBUG
        NSLog(@"Couldn't get a camera.");
#endif
        return;
    }
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        // handle the error
#ifdef DEBUG
        NSLog(@"ERROR: trying to open camera: %@", error);
#endif
    }
    [session addInput:input];
    
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    // add Dictionary to store PixelXDimension / PixelYDimension
    double width = 480;
    double height = 480;
    NSDictionary *pixelBufferOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithDouble:width], (id)kCVPixelBufferWidthKey,
                                        [NSNumber numberWithDouble:height], (id)kCVPixelBufferHeightKey,
                                        [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA], (id)kCVPixelBufferPixelFormatTypeKey,
                                        nil];
    
//    NSDictionary *options = @{(id)kCVPixelBufferPixelFormatTypeKey : kCVPixelFormatType_32BGRA,
//                              (id)kCVPixelBufferWidthKey : width,
//                              (id)kCVPixelBufferHeightKey : height };

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
    
    // the below line should make the "done" button selectable
    self.vImage.userInteractionEnabled = YES;
    [self.vImage bringSubviewToFront:toolbar];
    // more tshooting
    toolbar.userInteractionEnabled = YES;
    
}
# pragma mark - front camera
- (AVCaptureDevice *)frontCamera {
    for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
        
    }
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}

# pragma mark - capture Now
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
#ifdef DEBUG
    NSLog(@"about to request a capture from %@", _stillImageOutput);
#endif
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
         if (exifAttachments)
         {
             // do something with the attachments.
#ifdef DEBUG
             NSLog(@"attachments: %@", exifAttachments);
#endif
         } else {
#ifdef DEBUG
             NSLog(@"no attachments");
#endif
         }
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         _image = [[UIImage alloc] initWithData:imageData];
         
         self.vImage.image = _image;
         
         // the below line will save the image to the PhotoAlbum
//         UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
         float width = 360;
         float height = 360;
         CGSize squareSize = CGSizeMake(width, height);
         
         [self squareImageWithImage:_image scaledToSize:squareSize];
         
         NSLog(@"_croppedImage = %@",_croppedImage);
         
         _dataImage = UIImageJPEGRepresentation(_croppedImage, 0.0);
         
         
         
         // save to Core Data moc
         // save picture / avatar to CoreData entity specific to username
         [self saveAvatar];
     }];
}


#pragma mark - Square Image With Image
- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    
    // see http://stackoverflow.com/questions/158914/cropping-an-uiimage
    // see http://stackoverflow.com/a/28085176/708807
    
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSLog(@"newImage = %@",newImage);
    
    _croppedImage = newImage;
    
    return newImage;
    
}

# pragma mark - save Avatar
-(void)saveAvatar {
#ifdef DEBUG
    NSLog(@"saveAvatar method reached");
#endif
    
    // retreive parent vc data
    NSDictionary *dataFromParent = [self.delegate giveMeData];
    // put the username in a String for comparison
    NSString *userName = [[NSString alloc] init];
    userName = [dataFromParent objectForKey:@"username"];
#ifdef DEBUG
    NSLog(@"username = %@",userName);
#endif
        
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
    // define table / entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account"inManagedObjectContext:_managedObjectContext];
    [request setEntity:entity];
        
    // fetch records and handle error
    NSError *error;
    NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
    if (!mutableFetchResults) {
        // handle error
    }
    for (Account *anAccount in mutableFetchResults) {
        if ([anAccount.username isEqualToString:userName]) {
#ifdef DEBUG
            NSLog(@"username found.");
#endif
            
            // save picture
            [anAccount setValue:self.dataImage forKey:@"avatar"];

            // save to DB
            NSError *error = nil;
            if (![_managedObjectContext save:&error]) {
#ifdef DEBUG
                NSLog(@"error %@", error);
#endif
            }
        }
    }
    [self done];
}
# pragma mark - dismiss Scene
-(void)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}
# pragma mark - device orientation

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
#endif        
}
@end