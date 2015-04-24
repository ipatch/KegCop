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
// Core Data
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
    
@implementation ViewControllerAvatar4

-(void)viewDidLoad {
#ifdef DEBUG
    NSLog(@"inside viewDidLoad of ViewControllerAvatar4");
#endif
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
    NSMutableDictionary *dataFromParent = [self.delegate giveMeData];
#ifdef DEBUG
    NSLog(@"dataFromParent = %@",dataFromParent);
    NSLog(@"Value for arrayKey: %@", [dataFromParent objectForKey:@"username"]);
#endif
    NSArray *values = [dataFromParent allValues];
#ifdef DEBUG
    NSLog(@"Values: %@", values);
#endif
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    CALayer *viewLayer = self.vImagePreview.layer;
#ifdef DEBUG
    NSLog(@"viewLayer = %@", viewLayer);
#endif
    
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
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         
         self.vImage.image = image;
         
         // the below line will save the image to the PhotoAlbum
//         UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
         
         _dataImage = UIImageJPEGRepresentation(image, 0.0);
         
         
         // figure out how to save pic for a particular account entity
         
         // save to Core Data moc
//         [_managedObjectContext setValue:dataImage forKey:@"Account"];
         // save picture / avatar to CoreData entity specific to username
         [self saveAvatar];
         
         
     }];
}

-(void)saveAvatar {
#ifdef DEBUG
    NSLog(@"saveAvatar method reached");
#endif
    
    // retreive parent vc data
    NSMutableDictionary *dataFromParent = [self.delegate giveMeData];
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
}
-(void)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end