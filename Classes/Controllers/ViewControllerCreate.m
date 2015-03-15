//
//  ViewControllerCreate.m
//  KegCop
//
//  Created by capin on 6/11/12.
//

#import "ViewControllerCreate.h"
#import "NSData+AES256.h"
#import "AccountsDataModel.h"

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

// keyboard toolbar
@synthesize doneButton = _doneButton;

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
    
    // enable clear button for text fields
    _createUserTextField.clearButtonMode = YES;
    _createPinTextField.clearButtonMode = YES;
    _createPinReTextField.clearButtonMode = YES;
    _createEmailTextField.clearButtonMode = YES;
    _createPhoneNumber.clearButtonMode = YES;
    
    // Core Data
    if (_managedObjectContext == nil)
    {
//        _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSLog(@"After _managedObjectContext: %@", _managedObjectContext);
    }
    
    // keyboard behavior
    [self registerForKeyboardNotifications];
    
    
    // Added 5AUG13 - trying to figure out how to dismiss view controller based upon view property / id
    NSLog(@"The currently loaded view:%c",[self.view isKindOfClass:[ViewControllerCreate class]]);
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
    [self setBtnCancel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

// method to limit character input in text fields

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == _createUserTextField) return (_createUserTextField.text.length + string.length <=16);
    if(textField == _createPinTextField) return (_createPinTextField.text.length + string.length <= 4);
    if(textField == _createPinReTextField) return (_createPinReTextField.text.length + string.length <=4);
    if(textField == _createPhoneNumber) return (_createPhoneNumber.text.length + string.length <=10);
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textFieldView
{
    currentTextField = textFieldView;
    [currentTextField setInputAccessoryView:toolBar];
    
}

// method to determine values in text fields - compare pins, 
// implement method to validate - createUserTextField, creatPinTextField, createEmailTextField, createPhoneTextField

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    currentTextField = nil;
    
    NSString *pin = _createPinTextField.text;
    NSString *repin = _createPinReTextField.text;
   
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


// method - CREATE - to pull text from text fields and store in account database
- (IBAction)createAccount:(id)sender {
    
    [self checkTextFieldCharLength];
    
    // check if create textfields are empty, check if boolean is YES / NO
    if([self checkTextFieldEmpty] == YES ) // empty text fields
    {
        NSLog(@"Please fill in text fields");
    }
    
    else {
        NSLog(@"Thanks for filling out the text fields.");
        
        
        // query Core Data DB to see if username is already created
        
        // define table/entity to use
        NSEntityDescription *entity =[NSEntityDescription entityForName:@"Account" inManagedObjectContext:_managedObjectContext];
        
        // setup fetch request
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        // sort the records
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"username" ascending:NO];
        NSArray *records = [NSArray arrayWithObject:sort];
        
        [request setSortDescriptors:records];
        
        // fetch the records and handle an error
        NSError *fetchError;
        NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&fetchError] mutableCopy];
        
        if (!mutableFetchResults) {
            // handle error.
            // serious error
        }
        
        // compare tf with fetched results
        if ([[mutableFetchResults valueForKey:@"username"] containsObject:_createUserTextField.text]) {
            
            // let user know username already taken
            _createUNnotValid.text=@"Username taken.";
            [_createUNnotValid setHidden:NO];
            return;
        }

        // Core Data - retrieve values from text fields and store in database.
        Account *newAccount;
        newAccount = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:_managedObjectContext];
        [newAccount setValue:_createUserTextField.text forKey:@"username"];
        
                [newAccount setValue:_createEmailTextField.text forKey:@"email"];
        [newAccount setValue:_createPhoneNumber.text forKey:@"phoneNumber"];
        
        // store pin in keychain - OBSOLETE
        // [newAccount setPassword:_createPinTextField.text];
        
        
        // password - set key
        NSString *key = @"donkey balls";
        
        // password - get text from pin textfield
        NSString *secret;
        secret = _createPinTextField.text;
        
        // password - convert string to NSData
        NSData *plain = [secret dataUsingEncoding:NSUTF8StringEncoding];
        
        // password - encrypt string
        NSData *cipher = [plain AES256EncryptWithKey:key];
        printf("%s\n", [[cipher description] UTF8String]);
        
        // convert NSData to Base64 encoded NSString
        NSString *cipherB64 = [self base64forData:cipher];
        
        [newAccount setValue:cipherB64 forKey:@"pin"];        
        
        
        // NSLog(@"Pin saved is %@", [newAccount password]);
        
        
        _createUserTextField.text = @"";
        _createEmailTextField.text = @"";
        _createPhoneNumber.text = @"";
        _createPinTextField.text = @"";
        _createPinReTextField.text = @"";
        
        NSError *error;
        [_managedObjectContext save:&error];
        
        [_createAccountSuccess setHidden:NO];
        NSLog(@"Succefully created account.");
        
        // Load ViewControllerHome
       // UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
        //ViewControllerHome *home = (ViewControllerHome *)[storyboard instantiateViewControllerWithIdentifier:@"Home"];
        
        UIViewController *home = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
        
        
        // pass user tf text to home screen
        username = _createUserTextField.text;
        
        [self passValues];
        
        [self presentViewController:home animated:YES completion:nil];

    }
}

- (IBAction)dismissCreateScene:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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


// method - validate email

- (BOOL) validateEmail: (NSString *) candidate 
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    //	return 0;
    return [emailTest evaluateWithObject:candidate];
}

// method - keyboard behavior

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification

{
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _createScroller.contentInset = contentInsets;
    _createScroller.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, currentTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, currentTextField.frame.origin.y-kbSize.height);
        [_createScroller setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification

{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _createScroller.contentInset = contentInsets;
    _createScroller.scrollIndicatorInsets = contentInsets;
    
}

// methods - keyboard behavior

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    NSLog(@"method was loaded at startup");
    NSLog(@"for the love of all that is free"); 
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = self->toolBar.frame;
    frame.origin.y = self.view.frame.size.height;
    self->toolBar.frame = frame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = self->toolBar.frame;
    frame.origin.y = self.view.frame.size.height - 260.0;
    self->toolBar.frame = frame;
    
    [UIView commitAnimations];
}

- (IBAction) next:(id)sender
{
    if([self.createUserTextField isFirstResponder]) [self.createPinTextField becomeFirstResponder];
    
    else if ([self.createPinTextField isFirstResponder]) [self.createPinReTextField becomeFirstResponder];
    
    else if ([self.createPinReTextField isFirstResponder]) [self.createEmailTextField becomeFirstResponder];
    
    else if ([self.createEmailTextField isFirstResponder]) [self.createPhoneNumber becomeFirstResponder];
    
    else if ([self.createPhoneNumber isFirstResponder]) [self.createUserTextField becomeFirstResponder];
}

- (IBAction) prev: (id)sender
{
    if([self.createUserTextField isFirstResponder]) [self.createPhoneNumber becomeFirstResponder];
    
    else if ([_createPinTextField isFirstResponder]) [self.createUserTextField becomeFirstResponder];
    
    else if ([_createPinReTextField isFirstResponder]) [self.createPinTextField becomeFirstResponder];
    
    else if ([_createEmailTextField isFirstResponder]) [self.createPinReTextField becomeFirstResponder];
    
    else if ([_createPhoneNumber isFirstResponder]) [self.createEmailTextField becomeFirstResponder];
    
}

-(void) passValues {
    ModelWelcome *modelwelcome = [ModelWelcome sharedModelWelcome];
    modelwelcome.passedText = username;
}


//from: http://www.cocoadev.com/index.pl?BaseSixtyFour
- (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}


@end
