//
//  ViewControllerAvatar2.h
//  KegCop
//
//  Created by capin on 11/12/14.
//
//

#import <UIKit/UIKit.h>

@interface ViewControllerAvatar2 : UIViewController

@property (weak, nonatomic) IBOutlet UIView *frameForCapture;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)takePhoto:(id)sender;



@end
