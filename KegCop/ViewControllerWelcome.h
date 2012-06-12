//
//  ViewController.h
//  KegCop
//
//  Created by capin on 6/3/12.
//


#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

// Notes
//
// nonatomic means setter & getter are not thread safe
// not a problem, because all UI code happens on main thread of
// application.

// "strong" - memory for object will stay around as long as needed.

// All objects are always accessed via the heap. ALWAYS
// that's why a pointer is used.
//
//
//
//
// this is a sample comment to view the git commits.
// this is another sample comment to observe git commit behavior.

// End Notes

// Welcome screen
@property (weak, nonatomic) IBOutlet UIScrollView *welcomeScroller;
@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPin;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmailReset;
@property (weak, nonatomic) IBOutlet UILabel *wrongUserPin;
@property (weak, nonatomic) IBOutlet UIButton *welcomeLogin;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *welcomeActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *welcomeAbout;

// end Welcome

// Create new account
@property (weak, nonatomic) IBOutlet UITextField *createUserTextField;
@property (weak, nonatomic) IBOutlet UITextField *createPinTextField;
@property (weak, nonatomic) IBOutlet UITextField *createEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *createPhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *createSubmit;
@property (weak, nonatomic) IBOutlet UIScrollView *createScroller;
@property (weak, nonatomic) IBOutlet UILabel *createUNnotValid;
@property (weak, nonatomic) IBOutlet UILabel *createPinNotValid;
@property (weak, nonatomic) IBOutlet UILabel *createEmailNotValid;
@property (weak, nonatomic) IBOutlet UILabel *createPhoneNumberNotValid;
@property (weak, nonatomic) IBOutlet UILabel *createAccountSuccess;

// end Create

// Forgot Email
@property (weak, nonatomic) IBOutlet UILabel *forgotEmailInvalid;
@property (weak, nonatomic) IBOutlet UILabel *forgotEmailSent;

// end Forgot


// Welcome to KepCop - methods
- (IBAction)dismissKeyboard:(id)sender;

- (IBAction)textFieldDoneEditing:(id)sender;

- (IBAction)processLogin:(id)sender;
// endWelcome

// Create new account - methods
- (IBAction)createAccount:(id)sender;

// endCreate


@end
