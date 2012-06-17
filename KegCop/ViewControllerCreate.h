//
//  ViewControllerCreate.h
//  KegCop
//
//  Created by capin on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"

@interface ViewControllerCreate : UIViewController <UITextFieldDelegate>
{
    
}

// Create new account
@property (weak, nonatomic) IBOutlet UITextField *createUserTextField;
@property (weak, nonatomic) IBOutlet UITextField *createPinTextField;
@property (weak, nonatomic) IBOutlet UITextField *createPinReTextField;
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


// Core Data
//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


// Create new account - methods
- (IBAction)createAccount:(id)sender;

// end Create

@end

