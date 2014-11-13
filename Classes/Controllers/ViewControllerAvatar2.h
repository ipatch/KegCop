//
//  ViewControllerAvatar2.h
//  KegCop
//
//  Created by capin on 11/12/14.
//
//

#import <UIKit/UIKit.h>

@interface ViewControllerAvatar2 : UIViewController

@property (strong, nonatomic) IBOutlet UIView *frameForCapture;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)takePhoto:(id)sender;



@end
