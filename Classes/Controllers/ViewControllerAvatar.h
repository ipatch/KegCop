//
//  ViewControllerAvatar.h
//  KegCop
//
//  Created by capin on 10/28/14.
//
//

#import <UIKit/UIKit.h>
// add support for using front facing camera
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>

@interface ViewControllerAvatar : UIViewController
<AVCaptureVideoDataOutputSampleBufferDelegate>

{
    // instance variables for using front facing camera
    AVCaptureSession *_captureSession;
    UIImageView *_imageView;
    CALayer *_customLayer;
    AVCaptureVideoPreviewLayer *_prevLayer;

}

/*
 @brief The capture session takes the input from the camera and captures it
 */
@property (nonatomic, strong) AVCaptureSession *captureSession;

/*
 @brief The UIImageView we use to display the image generated from the imageBuffer
 */
@property (nonatomic, strong) UIImageView *imageView;

/*
 @brief The CALayer customized by apple to display the video corresponding to a capture session
 */
@property (nonatomic, strong) CALayer *customLayer;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *prevLayer;

/*
 @brief This method initializes the capture session
 */
- (void)initCapture;


@end
