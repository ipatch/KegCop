//
//  ViewControllerCreate.h
//  KegCop
//
//  Created by capin on 6/11/12.
//

#import "ViewControllerHome.h"
#import <CommonCrypto/CommonCryptor.h>
#import <UIKit/UIKit.h>

@interface ViewControllerCreate : UIViewController <UITextFieldDelegate>
{
    BOOL keyboardIsShown;
    UITextField *currentTextField;
    // keyboard toolbar
    NSString *username;
}

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
// toolbar - keyboard methods
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction) next:(id)sender;
- (IBAction) prev:(id)sender;

@end