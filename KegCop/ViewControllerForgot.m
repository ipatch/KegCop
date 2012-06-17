//
//  ViewControllerForgot.m
//  KegCop
//
//  Created by capin on 6/12/12.
//

#import "ViewControllerForgot.h"

@interface ViewControllerForgot ()



@end



@implementation ViewControllerForgot


// forgot email screen
@synthesize forgotEmailInvalid = _forgotEmailInvalid;
@synthesize forgotEmailSent = _forgotEmailSent;
@synthesize textFieldEmailReset = _textFieldEmailReset;
// end forgot email

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setForgotEmailInvalid:nil];
    [self setForgotEmailSent:nil];
    [self setTextFieldEmailReset:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)dismissKeyboard:(id)sender {
// forgot
//[_textFieldEmailReset resignFirstResponder];
}

@end
