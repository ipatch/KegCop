//
//  ViewController.m
//  KegCop
//
//  Created by capin on 6/3/12.
//

// think of the controller is how your model is presented to the user

#import "ViewControllerWelcome.h"

@interface ViewController ()

// declare private methods here

@end

@implementation ViewController

//
// Notes
//
// it's bad not to use the "= _" SO USE IT! (-.-)
// synthesize allocates room for the pointer (o.O)
// synthesize creates the setter and the getter
// use the "getter" whenever we want to talk to a UI element.
// all synthesize does is make the instance variable for the pointer
//
//
//

// Welcome screen
@synthesize welcomeScroller = _welcomeScroller;
@synthesize textFieldUsername = _textFieldUsername;
@synthesize textFieldPin = _textFieldPin;
@synthesize textFieldEmailReset = _textFieldEmailReset;
@synthesize wrongUserPin = _wrongUserPin;
@synthesize welcomeLogin = _welcomeLogin;
@synthesize welcomeActivityIndicator = _welcomeActivityIndicator;
@synthesize welcomeAbout = _welcomeAbout;
// end welcome

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

// forgot email screen
@synthesize forgotEmailInvalid = _forgotEmailInvalid;
@synthesize forgotEmailSent = _forgotEmailSent;
// end forgot email



// You can make use of zeroing weak pointer here in case targeting iOS 5.0 and later.
__unsafe_unretained UITextField *activeField;


//
// Controller Methods
//

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // load Welcome Scrollview
    //[_welcomeScroller setScrollerEnabled:YES];
    [_welcomeScroller setContentSize:CGSizeMake(320,1000)];
    
    
    
    
    // hidden at load
    [_wrongUserPin setHidden:YES];
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
    
    // create - move content for keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)viewDidUnload {
    [self setTextFieldUsername:nil];
    [self setTextFieldPin:nil];
    [self setTextFieldEmailReset:nil];
    [self setWrongUserPin:nil];
    [self setCreateUserTextField:nil];
    [self setCreatePinTextField:nil];
    [self setCreateEmailTextField:nil];
    [self setCreatePhoneNumber:nil];
    [self setCreateSubmit:nil];
    [self setWelcomeLogin:nil];
    [self setWelcomeActivityIndicator:nil];
    [self setCreateScroller:nil];
    [self setForgotEmailInvalid:nil];
    [self setForgotEmailSent:nil];
    [self setCreateUNnotValid:nil];
    [self setCreatePinNotValid:nil];
    [self setCreateEmailNotValid:nil];
    [self setCreatePhoneNumberNotValid:nil];
    [self setCreateAccountSuccess:nil];
    [self setWelcomeScroller:nil];
    [self setWelcomeAbout:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    // create - release observer for content move
    //[[NSNotificationCenter defaultCenter] removeObserver:self]; // tutsplus sample code
}

// Call this method somewhere in your view controller setup code.

- (void)registerForKeyboardNotifications

{
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.

- (void)keyboardWasShown:(NSNotification*)aNotification

{
    
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    
    _createScroller.contentInset = contentInsets;
    
    _createScroller.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    
    // Your application might not need or want this behavior.
    
    CGRect aRect = self.view.frame;
    
    aRect.size.height -= kbSize.height;
    
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
        
        [_createScroller setContentOffset:scrollPoint animated:YES];
    }
    
}

// Called when the UIKeyboardWillHideNotification is sent

- (void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    _createScroller.contentInset = contentInsets;
    
    _createScroller.scrollIndicatorInsets = contentInsets;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField

{
    
    activeField = textField;
    
}



- (void)textFieldDidEndEditing:(UITextField *)textField

{
    
    activeField = nil;
    
}






/*
// method - create - move content for keyboard
// http://mobile.tutsplus.com/tutorials/iphone/ios-sdk-keeping-content-from-underneath-the-keyboard/

- (void)keyboardWasShown:(NSNotification *)notification {
    
    // Step 1: Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Step 2: Adjust the bottom content inset of your scroll view by the keyboard height.
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    _createScroller.contentInset = contentInsets;
    _createScroller.scrollIndicatorInsets = contentInsets;
    
    // Step 3: Scroll the target text field into view.
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    if (!CGRectContainsPoint(aRect, _createPhoneNumber.frame.origin) ) {
        // change value to adjust keyboard height
        CGPoint scrollPoint = CGPointMake(0.0, _createPhoneNumber.frame.origin.y - (keyboardSize.height-50));
        [_createScroller setContentOffset:scrollPoint animated:YES];
    }
}
*/

/*
// method - create - move content for keyboard - dismiss keyboard
// http://mobile.tutsplus.com/tutorials/iphone/ios-sdk-keeping-content-from-underneath-the-keyboard/

- (void) keyboardWillHide:(NSNotification *)notification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _createScroller.contentInset = contentInsets;
    _createScroller.scrollIndicatorInsets = contentInsets;
}
*/


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {  return YES; }

// "id" is a pointer to ANY type of object.

- (IBAction)dismissKeyboard:(id)sender {
    // welcome
    [_textFieldUsername resignFirstResponder];
    [_textFieldPin resignFirstResponder];
    // forgot
    [_textFieldEmailReset resignFirstResponder];
    // create new account
    [_createUserTextField resignFirstResponder];
    [_createPinTextField resignFirstResponder];
    [_createEmailTextField resignFirstResponder];
    [_createPhoneNumber resignFirstResponder];
    

}



- (IBAction) textFieldDoneEditing : (id) sender {
    [sender resignFirstResponder];
}



- (IBAction)processLogin:(id)sender {
    
    //http://www.riccomini.name/Topics/Mobile/iPhone/SimpleLoginScreen/
    // TODO: spawn a login thread
    
    
    NSString *string = @"root";
    // get the value inputted in textFieldUsername and put it in a string object.
    NSString *tf_Username = [_textFieldUsername text ];
    
    // compare "admin" with tf_Username
    if ([string isEqualToString: tf_Username])  {
        // do my bidding!!!
        [self performSegueWithIdentifier:@"AdminSegue" sender:sender];
    }
    else {
        [self performSegueWithIdentifier:@"UserSegue" sender: sender];
    }
    
	
	_welcomeActivityIndicator.hidden = FALSE;
	[_welcomeActivityIndicator startAnimating];
	
	_welcomeLogin.enabled = FALSE;
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
