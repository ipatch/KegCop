//
//  ViewControllerForgot.h
//  KegCop
//
//  Created by capin on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerForgot : UIViewController

// Forgot Email
@property (weak, nonatomic) IBOutlet UILabel *forgotEmailInvalid;
@property (weak, nonatomic) IBOutlet UILabel *forgotEmailSent;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmailReset;

// end Forgot

- (IBAction)dismissKeyboard:(id)sender;

@end

