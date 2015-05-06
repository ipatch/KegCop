//
//  ViewControllerCreate.m
//  KegCop
//
//  Created by capin on 6/11/12.
//

#import "ViewControllerCreate.h"
#import "NSData+AES256.h"

@interface ViewControllerCreate() {
    
}

@property (nonatomic, retain) UINavigationBar *navBar;
@property (nonatomic, retain) UITextField *createUserTextField;
@property (nonatomic, retain) UITextField *createPinTextField;
@property (nonatomic, retain) UITextField *createPinReTextField;
@property (nonatomic, retain) UITextField *createEmailTextField;
@property (nonatomic, retain) UITextField *createPhoneNumber;
@property (nonatomic, retain) UIButton *createSubmit;
@property (nonatomic, retain) UIButton *btnCancel;

@end

@implementation ViewControllerCreate {
    
}
#pragma mark - View Did Load
-(void)addUIElements {
    
    _navBar = [[UINavigationBar alloc] init];
    [_navBar setFrame:CGRectMake(0,0,CGRectGetWidth(self.view.frame),60)];
    
    UINavigationItem *titleItem = [[UINavigationItem alloc] initWithTitle:@"Create Account"];
    
    _navBar.items = @[titleItem];
    
    _navBar.barTintColor = [UIColor colorWithRed:100.0f/255.0f
                                          green:83.0f/255.0f
                                           blue:0.0f/255.0f
                                          alpha:1.0f];
    _navBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:255.0f/255.0f
                        green:239.0f/255.0f
                        blue:160.0f/255.0f
                        alpha:1.0f]};
    _navBar.translucent = NO;
    
    [self.view addSubview:_navBar];
    // END navBar
    
    // create account - scrollview
    [_createScroller setScrollEnabled:YES];
    [_createScroller setContentSize:CGSizeMake(320, 750)];
    
    // setup textfields
    _createUserTextField = [[UITextField alloc] init];
    [_createUserTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    _createUserTextField.backgroundColor = [UIColor whiteColor];
    _createUserTextField.layer.cornerRadius = 5;
//    [_textFieldPin setSecureTextEntry:YES];
    [_createUserTextField setPlaceholder:@"INPUT USERNAME" ];
    _createUserTextField.delegate = self;
//    _textFieldPin.keyboardType = UIKeyboardTypeNumberPad;
     _createUserTextField.clearButtonMode = YES;
    [self.view addSubview:_createUserTextField];
    
    // setup pin tf
    _createPinTextField = [[UITextField alloc] init];
    [_createPinTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    _createPinTextField.backgroundColor = [UIColor whiteColor];
    _createPinTextField.layer.cornerRadius = 5;
    [_createPinTextField setSecureTextEntry:YES];
    [_createPinTextField setPlaceholder:@"INPUT PIN" ];
    _createPinTextField.delegate = self;
    _createPinTextField.keyboardType = UIKeyboardTypeNumberPad;
    _createPinTextField.clearButtonMode = YES;
    [self.view addSubview:_createPinTextField];
    
    // setup pinre tf
    _createPinReTextField = [[UITextField alloc] init];
    [_createPinReTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    _createPinReTextField.backgroundColor = [UIColor whiteColor];
    _createPinReTextField.layer.cornerRadius = 5;
    [_createPinReTextField setSecureTextEntry:YES];
    [_createPinReTextField setPlaceholder:@"RE-ENTER PIN" ];
    _createPinReTextField.delegate = self;
    _createPinReTextField.keyboardType = UIKeyboardTypeNumberPad;
    _createPinReTextField.clearButtonMode = YES;
    [self.view addSubview:_createPinReTextField];
    
    // setup email tf
    _createEmailTextField = [[UITextField alloc] init];
    [_createEmailTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    _createEmailTextField.backgroundColor = [UIColor whiteColor];
    _createEmailTextField.layer.cornerRadius = 5;
//    [_createEmailTextField setSecureTextEntry:YES];
    [_createEmailTextField setPlaceholder:@"INPUT EMAIL (OPTIONAL)" ];
    _createEmailTextField.delegate = self;
//    _createEmailTextField.keyboardType = UIKeyboardTypeNumberPad;
    _createEmailTextField.clearButtonMode = YES;
    [self.view addSubview:_createEmailTextField];

    // setup phoneNumbertf
    _createPhoneNumber = [[UITextField alloc] init];
    [_createPhoneNumber setTranslatesAutoresizingMaskIntoConstraints:NO];
    _createPhoneNumber.backgroundColor = [UIColor whiteColor];
    _createPhoneNumber.layer.cornerRadius = 5;
//    [_createPhoneNumber setSecureTextEntry:YES];
    [_createPhoneNumber setPlaceholder:@"INPUT PHONE NUMBER (OPTIONAL)" ];
    _createPhoneNumber.delegate = self;
//    _createPhoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    _createPhoneNumber.clearButtonMode = YES;
    [self.view addSubview:_createPhoneNumber];
    
    // change color of txt for tf's
    _createUserTextField.textColor = [UIColor colorWithRed:100.0f/255.0f
                                                     green:83.0f/255.0f
                                                      blue:0.0f/255.0f
                                                     alpha:1.0f];
    
    _createPinTextField.textColor = [UIColor colorWithRed:100.0f/255.0f
                                                    green:83.0f/255.0f
                                                     blue:0.0f/255.0f
                                                    alpha:1.0f];
    
    _createPinReTextField.textColor = [UIColor colorWithRed:100.0f/255.0f
                                                      green:83.0f/255.0f
                                                       blue:0.0f/255.0f
                                                      alpha:1.0f];
    
    _createEmailTextField.textColor = [UIColor colorWithRed:100.0f/255.0f
                                                      green:83.0f/255.0f
                                                       blue:0.0f/255.0f
                                                      alpha:1.0f];
    
    _createPhoneNumber.textColor = [UIColor colorWithRed:100.0f/255.0f
                                                   green:83.0f/255.0f
                                                    blue:0.0f/255.0f
                                                   alpha:1.0f];

    
}
-(void)addUIElementConstraints {
    
    // add constraints for _createUsernametf
    NSLayoutConstraint *pullcreatetfToTop = [NSLayoutConstraint constraintWithItem:_createUserTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_createUserTextField.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:80.0];
    
    // center horizontaly in view
    NSLayoutConstraint *centerXcreatetf = [NSLayoutConstraint constraintWithItem:_createUserTextField                                                attribute:NSLayoutAttributeCenterX                                                               relatedBy:NSLayoutRelationEqual toItem:_createUserTextField.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    
    // add constraints
    [_createUserTextField.superview addConstraints:@[pullcreatetfToTop, centerXcreatetf]];
    
    // add constraints for _createPintf
    NSLayoutConstraint *pullcreatePintfToTop = [NSLayoutConstraint constraintWithItem:_createPinTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_createPinTextField.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:120.0];
    
    // center horizontaly in view
    NSLayoutConstraint *centerXcreatePintf = [NSLayoutConstraint constraintWithItem:_createPinTextField                                                attribute:NSLayoutAttributeCenterX                                                               relatedBy:NSLayoutRelationEqual toItem:_createPinTextField.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    
    // add constraints
    [_createUserTextField.superview addConstraints:@[pullcreatePintfToTop, centerXcreatePintf]];
    
    // add constraints for _createPintf
    NSLayoutConstraint *pullcreatePinRetfToTop = [NSLayoutConstraint constraintWithItem:_createPinReTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_createPinReTextField.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:160.0];
    
    // center horizontaly in view
    NSLayoutConstraint *centerXcreatePinRetf = [NSLayoutConstraint constraintWithItem:_createPinReTextField                                                attribute:NSLayoutAttributeCenterX                                                               relatedBy:NSLayoutRelationEqual toItem:_createPinReTextField.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    
    // add constraints
    [_createUserTextField.superview addConstraints:@[pullcreatePinRetfToTop, centerXcreatePinRetf]];
    
    // add constraints for _createEmailtf
    NSLayoutConstraint *pullcreateEmailtfToTop = [NSLayoutConstraint constraintWithItem:_createEmailTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_createEmailTextField.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:200.0];
    
    // center horizontaly in view
    NSLayoutConstraint *centerXcreateEmailtf = [NSLayoutConstraint constraintWithItem:_createEmailTextField                                                attribute:NSLayoutAttributeCenterX                                                               relatedBy:NSLayoutRelationEqual toItem:_createEmailTextField.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    
    // add constraints
    [_createUserTextField.superview addConstraints:@[pullcreateEmailtfToTop, centerXcreateEmailtf]];
    
    // add constraints for _createPhoneNumbertf
    NSLayoutConstraint *pullcreatePhoneNumbertfToTop = [NSLayoutConstraint constraintWithItem:_createPhoneNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_createPhoneNumber.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:240.0];
    
    // center horizontaly in view
    NSLayoutConstraint *centerXcreatePhoneNumbertf = [NSLayoutConstraint constraintWithItem:_createPhoneNumber                                                attribute:NSLayoutAttributeCenterX                                                               relatedBy:NSLayoutRelationEqual toItem:_createPhoneNumber.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    
    // add constraints
    [_createUserTextField.superview addConstraints:@[pullcreatePhoneNumbertfToTop, centerXcreatePhoneNumbertf]];
    
    // add constraints for submit btn
    
    // add constraints for cancel btn

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addUIElements];
    [self addUIElementConstraints];
    
    // create new account
    [_createUNnotValid setHidden:YES];
    [_createPinNotValid setHidden:YES];
    [_createEmailNotValid setHidden:YES];
    [_createPhoneNumberNotValid setHidden:YES];
    [_createAccountSuccess setHidden:YES];
    
    // Core Data
    if (_managedObjectContext == nil)
    {
        _managedObjectContext = [[AccountsDataModel sharedDataModel]mainContext];
#ifdef DEBUG
        NSLog(@"After _managedObjectContext: %@", _managedObjectContext);
#endif
    }
    // keyboard behavior
    [self registerForKeyboardNotifications];
}

/*
 * method to limit character input in text fields
 */
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

/*
 * method to determine values in text fields - compare pins,
 */
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    currentTextField = nil;
    
    NSString *pin = _createPinTextField.text;
    NSString *repin = _createPinReTextField.text;
   
    if ([pin isEqualToString: repin])
    {
#ifdef DEBUG
        NSLog(@"Pins are equal.");
#endif
        [_createPinNotValid setHidden:YES];
    }
    else {
        [_createPinNotValid setHidden:NO];
    }
    // check _createEmailTextField
    if([self validateEmail:[_createEmailTextField text]] ==1)
	{
        [_createEmailNotValid setHidden:YES];
#ifdef DEBUG
        NSLog(@"code executed");
#endif
    }
    else {
//        [_createEmailNotValid setHidden:NO];
    }
}

- (IBAction)dismissKeyboard:(id)sender {
[_createUserTextField resignFirstResponder];
[_createPinTextField resignFirstResponder];
[_createPinReTextField resignFirstResponder];
[_createEmailTextField resignFirstResponder];
[_createPhoneNumber resignFirstResponder];

}

/*
 * CREATE - to pull text from text fields and store in account database
 */
- (IBAction)createAccount:(id)sender {
    
    [self checkTextFieldCharLength];
    
    // check if create textfields are empty, check if boolean is YES / NO
    if([self checkTextFieldEmpty] == YES ) // empty text fields
    {
#ifdef DEBUG
        NSLog(@"Please fill in text fields");
#endif
    }
    
    else {
#ifdef DEBUG
        NSLog(@"Thanks for filling out the text fields.");
#endif
        
        
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
        NSString *cipherB64 = [[NSData alloc] base64forData:cipher];
        
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
#ifdef DEBUG
        NSLog(@"Succefully created account.");
#endif
        
        // Load ViewControllerHome
        UIViewController *home = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
        
        // pass user tf text to home screen
        username = _createUserTextField.text;
        if ([_createUserTextField.text isEqualToString:@"root"]) {
            UIStoryboard *storyboardLocal = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
            ViewControllerRootHome *rootHome = [storyboardLocal instantiateViewControllerWithIdentifier:@"rootHome"];
            [self presentViewController:rootHome animated:YES completion:nil];
        }
        else {
            [self presentViewController:home animated:YES completion:nil];
        }
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
//    if ([_createEmailTextField.text length] >= 4 ) {
//        [_createEmailNotValid setHidden:YES];
//    }
//    if ([_createPhoneNumber.text length] == 10) {
//        [_createPhoneNumberNotValid setHidden:YES];
//    }
#ifdef DEBUG
    NSLog(@"Passed text field char length.");
#endif

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
//    if (_createEmailTextField.text.length == 0)
//    {
//        [_createEmailNotValid setHidden:NO]; i++;
//    }
//    if (_createPhoneNumber.text.length == 0)
//    {
//        [_createPhoneNumberNotValid setHidden:NO]; i++;
//    }
if (i >= 1) return YES; else return NO;
}


/*
 * method - validate email
 */
- (BOOL) validateEmail: (NSString *) candidate 
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    //	return 0;
    return [emailTest evaluateWithObject:candidate];
}

/*
 * method - keyboard behavior
 */
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    
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

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _createScroller.contentInset = contentInsets;
    _createScroller.scrollIndicatorInsets = contentInsets;
    
}

#pragma mark - view will appear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
#ifdef DEBUG
    NSLog(@"method was loaded at startup");
#endif
}
#pragma mark - view will disappear
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - keyboard methods for showing / hiding the keyboard
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
#pragma mark - Keyboard toolbar methods
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
# pragma mark - device orientation
/*
 * method to determine screen layout
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
@end