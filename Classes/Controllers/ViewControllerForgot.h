//
//  ViewControllerForgot.h
//  KegCop
//
//  Created by capin on 6/12/12.
//

#import <UIKit/UIKit.h>

@interface ViewControllerForgot : UIViewController

// Forgot Email
@property (weak, nonatomic) IBOutlet UILabel *forgotEmailInvalid;
@property (weak, nonatomic) IBOutlet UILabel *forgotEmailSent;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmailReset;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

// end Forgot

- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)dismissScene:(id)sender;
@end

