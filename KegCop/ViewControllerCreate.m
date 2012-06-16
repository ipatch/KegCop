//
//  ViewControllerCreate.m
//  KegCop
//
//  Created by capin on 6/11/12.
//

#import "ViewControllerCreate.h"
#import "AppDelegate.h"

@interface ViewControllerCreate()

@end


@implementation ViewControllerCreate


// create new account
@synthesize createScroller = _createScroller;
@synthesize createUserTextField = _createUserTextField;
@synthesize createPinTextField = _createPinTextField;
@synthesize createPinReTextField = _createPinReTextField;
@synthesize createEmailTextField = _createEmailTextField;
@synthesize createPhoneNumber = _createPhoneNumber;
@synthesize createSubmit = _createSubmit;
@synthesize createUNnotValid = _createUNnotValid;
@synthesize createPinNotValid = _createPinNotValid;
@synthesize createEmailNotValid = _createEmailNotValid;
@synthesize createPhoneNumberNotValid = _createPhoneNumberNotValid;
@synthesize createAccountSuccess = _createAccountSuccess;

// end create new account

// Core Data
@synthesize managedObjectContext = _managedObjectContext;


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
    
    // set delegate of pin textfields
    _createPinTextField.delegate = self;
    _createPinReTextField.delegate = self;
    _createPhoneNumber.delegate = self;
    
        
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
    
    [self setCreatePinReTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

// method to limit character input in certain text fields

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == _createPinTextField) return (_createPinTextField.text.length + string.length <= 4);
    if(textField == _createPinReTextField) return (_createPinReTextField.text.length + string.length <=4);
    if(textField == _createPhoneNumber) return (_createPhoneNumber.text.length + string.length <=10);
}

// method to determine values in text fields - compare pins, 

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *pin = _createPinTextField.text;
    NSString *repin = _createPinReTextField.text;
    // TODO - figure out how to check for equality after both pins are entered
    if ([pin isEqualToString: repin])
    {
        NSLog(@"Pins are equal.");
        [_createPinNotValid setHidden:YES];
    }
    else {
        [_createPinNotValid setHidden:NO];
    }
}

// method to determine screen layout

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)dismissKeyboard:(id)sender {
// create new account
[_createUserTextField resignFirstResponder];
[_createPinTextField resignFirstResponder];
[_createPinReTextField resignFirstResponder];
[_createEmailTextField resignFirstResponder];
[_createPhoneNumber resignFirstResponder];
}

// method to check if text fields have been populated
/*
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([_createUserTextField.text length] != 0 && [_createPinTextField.text length] != 0 && [_createEmailTextField.text length] != 0 && [_createPhoneNumber.text length] != 0 ) 
    {
        [_createSubmit setEnabled:YES];
    }
}
*/


// method to pull code from text fields and store in keychain and account database

- (IBAction)createAccount:(id)sender {
    
    // insert code here.
    // check if create textfields are empty - WRONG
    //if ([createUserTextField is
    // on second thought, disable submit button until textfields are filled.
    //if ([createUserTextField isEqual:
    /*
    if ([_createUserTextField.text length] > 0 || _createUserTextField.text != nil || [_createUserTextField.text isEqual:@""] == FALSE) {
        [_createUNnotValid setHidden:NO];
    }
    else {
        
    }
    */
    // Check text fields for values
    if ([_createUserTextField.text length] >= 4 ) {
        [_createUNnotValid setHidden:YES];
    }
    
    if ([_createPinTextField.text length] == 4) {
        [_createPinNotValid setHidden:YES];
    }
    if ([_createEmailTextField.text length] >= 4 ) {
        [_createEmailNotValid setHidden:YES];
    }
    if ([_createPhoneNumber.text length] == 10) {
        [_createPhoneNumberNotValid setHidden:YES];
    }
    
    
    
    // Core Data - retrieve values from text fields and store in database.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *newAccount;
    newAccount = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:context];
    [newAccount setValue:_createUserTextField forKey:@"username"];
    [newAccount setValue:_createEmailTextField forKey:@"email"];
    [newAccount setValue:_createPhoneNumber forKey:@"phoneNumber"];
    _createUserTextField.text = @"";
    _createEmailTextField.text = @"";
    _createPhoneNumber.text = @"";
    NSError *error;
    [context save:&error];
    [_createAccountSuccess setHidden:NO];
    NSLog(@"Succefully created account.");
}

// code to dismiss numpad after 10 digits have been entered
/*
- (BOOL) createPhoneNumber:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    int count = [_createPhoneNumber.text length];
    if(count>=10){
        [textField resignFirstResponder];
    }
    return YES;
}
*/
// implement method to validate username - createUserTextField, creatPinTextField, createEmailTextField,
// createPhoneTextField
//- (BOOL) validateCreateTextFields


// reg expression to validate phone number @"^\\+?[0-9]*$"


// method to validate createUserTextField
/*
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
*/

// method to validate email
/*
- (BOOL)validateTextfiels
{

}
*/
/*
- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:email];
}
*/

@end
