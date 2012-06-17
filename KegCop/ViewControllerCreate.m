//
//  ViewControllerCreate.m
//  KegCop
//
//  Created by capin on 6/11/12.
//

#import "ViewControllerCreate.h"


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
    [_createScroller setContentSize:CGSizeMake(320, 750)];
    
    // set delegate of pin textfields
    _createUserTextField.delegate =self;
    _createPinTextField.delegate = self;
    _createPinReTextField.delegate = self;
    _createPhoneNumber.delegate = self;
    
    // Core Data
    if (_managedObjectContext == nil)
    {
        _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSLog(@"After _managedObjectContext: %@", _managedObjectContext);
    }
        
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
    if(textField == _createUserTextField) return (_createUserTextField.text.length + string.length <=16);
    if(textField == _createPinTextField) return (_createPinTextField.text.length + string.length <= 4);
    if(textField == _createPinReTextField) return (_createPinReTextField.text.length + string.length <=4);
    if(textField == _createPhoneNumber) return (_createPhoneNumber.text.length + string.length <=10);
    return YES;
}

// method to determine values in text fields - compare pins, 
// implement method to validate - createUserTextField, creatPinTextField, createEmailTextField, createPhoneTextField

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
    
    // check _createUserTextField against regular expression
    //NSString *user = _createUserTextField.text;
    
    
    // var regexp = /^[a-zA-Z0-9-_]+$/;

    
    // ?:[a-z][a-z]*[0-9]+[a-z0-9]*
    
    // check _createEmailTextField
    if([self validateEmail:[_createEmailTextField text]] ==1)
	{
        [_createEmailNotValid setHidden:YES];
        NSLog(@"code executed");
    }
    else {
        [_createEmailNotValid setHidden:NO];
    }
    
    // reg expression to validate phone number @"^\\+?[0-9]*$"
    
    
   
}

// method to determine screen layout

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)dismissKeyboard:(id)sender {
[_createUserTextField resignFirstResponder];
[_createPinTextField resignFirstResponder];
[_createPinReTextField resignFirstResponder];
[_createEmailTextField resignFirstResponder];
[_createPhoneNumber resignFirstResponder];
}


// method to pull code from text fields and store in keychain and account database

- (IBAction)createAccount:(id)sender {
    
    // check if create textfields are empty - WRONG
  
    [self checkTextFieldCharLength];
    
    // check if boolean is true / false
    if([self checkTextFieldEmpty] == TRUE ) // empty text fields
    {
        NSLog(@"Please fill in text fields");
    }
    
    else {
        NSLog(@"Thanks for filling out the text fields.");
        // Core Data - retrieve values from text fields and store in database.
        NSManagedObject *newAccount;
        newAccount = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:_managedObjectContext];
        [newAccount setValue:_createUserTextField forKey:@"username"];
        [newAccount setValue:_createEmailTextField forKey:@"email"];
        [newAccount setValue:_createPhoneNumber forKey:@"phoneNumber"];
        _createUserTextField.text = @"";
        _createEmailTextField.text = @"";
        _createPhoneNumber.text = @"";
        NSError *error;
        [_managedObjectContext save:&error];
        [_createAccountSuccess setHidden:NO];
        NSLog(@"Succefully created account.");
    }
}

- (void)checkTextFieldCharLength
{
    // Check text fields for values
    if ([_createUserTextField.text length] >= 4 ) {
        ([_createUNnotValid setHidden:YES]);
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
    NSLog(@"Passed text field char length.");

}

- (BOOL) checkTextFieldEmpty
{
    int i = 0;

    if (_createUserTextField.text.length == 0) 
    {
        [_createUNnotValid setHidden:NO]; i++;
    }
    if (_createPinTextField.text.length == 0) 
    {
        [_createPinNotValid setHidden:NO]; i++;
    }
    if (_createPinReTextField.text.length == 0)
    {
        [_createPinNotValid setHidden:NO]; i++;
    }
    if (_createEmailTextField.text.length == 0)
    {
        [_createEmailNotValid setHidden:NO]; i++;
    }
    if (_createPhoneNumber.text.length == 0)
    {
        [_createPhoneNumberNotValid setHidden:NO]; i++;
    }
if (i >= 1) return YES; else return NO;
}


// method to validate email

- (BOOL) validateEmail: (NSString *) candidate 
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    //	return 0;
    return [emailTest evaluateWithObject:candidate];
}

@end
