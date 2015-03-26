//
//  ViewControllerCreate.h
//  KegCop
//
//  Created by capin on 6/11/12.
//

#import "ViewControllerHome.h"
#import <CommonCrypto/CommonCryptor.h>

@interface ViewControllerCreate : UIViewController <UITextFieldDelegate>
{
    BOOL keyboardIsShown;
    UITextField *currentTextField;
    // keyboard toolbar
    IBOutlet UIToolbar *toolBar;
    NSString *username;
}

// Create new account
@property (weak, nonatomic) IBOutlet UITextField *createUserTextField;
@property (weak, nonatomic) IBOutlet UITextField *createPinTextField;
@property (weak, nonatomic) IBOutlet UITextField *createPinReTextField;
@property (weak, nonatomic) IBOutlet UITextField *createEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *createPhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *createSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIScrollView *createScroller;
@property (weak, nonatomic) IBOutlet UILabel *createUNnotValid;
@property (weak, nonatomic) IBOutlet UILabel *createPinNotValid;
@property (weak, nonatomic) IBOutlet UILabel *createEmailNotValid;
@property (weak, nonatomic) IBOutlet UILabel *createPhoneNumberNotValid;
@property (weak, nonatomic) IBOutlet UILabel *createAccountSuccess;
// keyboard toolbar
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
// Core Data
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// Create new account - methods
- (IBAction)createAccount:(id)sender;
- (IBAction)dismissCreateScene:(id)sender;

- (IBAction)dismissKeyboard:(id)sender;

- (IBAction) next:(id)sender;
- (IBAction) prev:(id)sender;

@end