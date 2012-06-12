//
//  ViewControllerCreate.m
//  KegCop
//
//  Created by capin on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewControllerCreate.h"

@interface ViewControllerCreate ()

@end




@implementation ViewControllerCreate

// create new account
@synthesize createScroller = _createScroller;
@synthesize createUserTextField = _createUserTextField;
@synthesize createPinTextField = _createPinTextField;
@synthesize createEmailTextField = _createEmailTextField;
@synthesize createPhoneNumber = _createPhoneNumber;
@synthesize createSubmit = _createSubmit;
@synthesize createUNnotValid = _createUNnotValid;
@synthesize createPinNotValid = _createPinNotValid;
@synthesize createEmailNotValid = _createEmailNotValid;
@synthesize createPhoneNumberNotValid = _createPhoneNumberNotValid;
@synthesize createAccountSuccess = _createAccountSuccess;
// end create new account


- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    // create new account
    [_createUNnotValid setHidden:YES];
    [_createPinNotValid setHidden:YES];
    [_createEmailNotValid setHidden:YES];
    [_createPhoneNumberNotValid setHidden:YES];
    [_createAccountSuccess setHidden:YES];
    
    
    
    
    // create account - scrollview
    [_createScroller setScrollEnabled:YES];
    [_createScroller setContentSize:CGSizeMake(320, 1000)];
    // create account disable submit button on launch
    [_createSubmit setEnabled:NO];
}

- (void)viewDidUnload
{
    [self setCreateScroller:nil];
    [self setCreateUserTextField:nil];
    [self setCreatePinTextField:nil];
    [self setCreateEmailTextField:nil];
    [self setCreatePhoneNumber:nil];
    [self setCreateSubmit:nil];
    
    [self setCreateUNnotValid:nil];
    [self setCreatePinNotValid:nil];
    [self setCreateEmailNotValid:nil];
    [self setCreatePhoneNumberNotValid:nil];
    [self setCreateAccountSuccess:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)dismissKeyboard:(id)sender {
// create new account
[_createUserTextField resignFirstResponder];
[_createPinTextField resignFirstResponder];
[_createEmailTextField resignFirstResponder];
[_createPhoneNumber resignFirstResponder];
}

- (IBAction)createAccount:(id)sender {
    
    // insert code here.
    // check if create textfields are empty - WRONG
    //if ([createUserTextField is
    // on second thought, disable submit button until textfields are filled.
    //if ([createUserTextField isEqual:
    if ([_createUserTextField.text length] > 0 || _createUserTextField.text != nil || [_createUserTextField.text isEqual:@""] == FALSE) {
        [_createUNnotValid setHidden:NO];
    }
    else {
        
    }
    
}

// code to dismiss numpad after 10 digits have been entered
- (BOOL) createPhoneNumber:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    int count = [_createPhoneNumber.text length];
    if(count>=10){
        [textField resignFirstResponder];
    }
    return YES;
}

// implement method to validate username - createUserTextField, creatPinTextField, createEmailTextField,
// createPhoneTextField
//- (BOOL) validateCreateTextFields


// reg expression to validate phone number @"^\\+?[0-9]*$"


// method to validate createUserTextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField==_createUserTextField){
        if ([newString length]>4 &&[newString length]<10 ) {
            // check here your character is lowercase he ya nahi
        }
        else {
            [_createUNnotValid setHidden:NO];
        }
        
    }
    return YES;
}

// method to validate email
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:email];
}



@end
