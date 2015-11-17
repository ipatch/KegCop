//
//  ViewControllerCreate.m
//  KegCop
//
//  Created by capin on 6/11/12.
//

#import "ViewControllerCreate.h"
#import "NSData+AES256.h"

#define TimeStamp [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]


@interface ViewControllerCreate() {
    
}
@property (nonatomic, retain) NSDate *loginTime;
@property (nonatomic, retain) UINavigationBar *navBar;
@property (nonatomic, retain) UIScrollView *createScroller;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UITextField *createUserTextField;
@property (nonatomic, retain) UITextField *createPinTextField;
@property (nonatomic, retain) UITextField *createPinReTextField;
@property (nonatomic, retain) UITextField *createEmailTextField;
@property (nonatomic, retain) UITextField *createPhoneNumber;
@property (nonatomic, retain) UIButton *createSubmit;
@property (nonatomic, retain) UIButton *btnCancel;

@property (nonatomic, weak) UITextField *previousTextField;

// keyboard toolbar
@property (nonatomic, retain) UIToolbar *toolBar;

@end

@implementation ViewControllerCreate {
    
}

- (void)doneClicked {
    [_createUserTextField resignFirstResponder];
    [_createPinTextField resignFirstResponder];
    [_createPinReTextField resignFirstResponder];
    [_createEmailTextField   resignFirstResponder];
    [_createPhoneNumber resignFirstResponder];
}

#pragma mark - Add UI Elements
-(void)addUIElements {
    
    // toolbar - displayed above keypad / keyboard
    _toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    _toolBar.barStyle = UIBarStyleBlackTranslucent;
    _toolBar.items = [NSArray arrayWithObjects:
                      [[UIBarButtonItem alloc]initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(prev:)],
                      [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(next:)],
                      [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)],
                      nil];
    [_toolBar sizeToFit];
    
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
    
    
    // END navBar
    
    // add scroller
    _createScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _createScroller.userInteractionEnabled = YES;
    _createScroller.scrollEnabled = YES;
    _createScroller.showsHorizontalScrollIndicator = YES;
    _createScroller.showsVerticalScrollIndicator = YES;
    
    [_createScroller setBackgroundColor:[UIColor colorWithRed:100.0f/255.0f
                                                         green:83.0f/255.0f
                                                          blue:0.0f/255.0f
                                                         alpha:1.0f]];
    
    [self.view addSubview:_createScroller];
    CGSize createScrollerSize = CGSizeMake(self.view.bounds.size.width, 1000);
    [_createScroller setContentSize:createScrollerSize];
    
    // add the content view (contains auto layout constraints)
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    _contentView = [[UIView alloc] initWithFrame:applicationFrame];
    _contentView.backgroundColor = [UIColor colorWithRed:(245/255.0)
                                                   green:(208/255.0)
                                                    blue:(55/255)
                                                   alpha:(1.0f) ];
    [_createScroller addSubview:_contentView];
    
    // setup username textfield
    _createUserTextField = [[UITextField alloc] init];
    [_createUserTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    _createUserTextField.backgroundColor = [UIColor whiteColor];
    _createUserTextField.layer.cornerRadius = 5;
//    [_textFieldPin setSecureTextEntry:YES];
    [_createUserTextField setPlaceholder:@"USERNAME" ];
    _createUserTextField.delegate = self;
    [_createUserTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_createUserTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
//    _textFieldPin.keyboardType = UIKeyboardTypeNumberPad;
     _createUserTextField.clearButtonMode = YES;
    [_createUserTextField setFont:[UIFont systemFontOfSize:30]];
    _createUserTextField.inputAccessoryView = _toolBar;
    [_createScroller addSubview:_createUserTextField];
    
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
    [_createPinTextField setFont:[UIFont systemFontOfSize:30]];
    _createPinTextField.inputAccessoryView = _toolBar;
    [_createScroller addSubview:_createPinTextField];
    
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
    [_createPinReTextField setFont:[UIFont systemFontOfSize:30]];
    _createPinReTextField.inputAccessoryView = _toolBar;
    [_createScroller addSubview:_createPinReTextField];
    
    // setup email tf
    _createEmailTextField = [[UITextField alloc] init];
    [_createEmailTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    _createEmailTextField.backgroundColor = [UIColor whiteColor];
    _createEmailTextField.layer.cornerRadius = 5;
//    [_createEmailTextField setSecureTextEntry:YES];
    [_createEmailTextField setPlaceholder:@"(OPTIONAL) EMAIL" ];
    [_createEmailTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_createEmailTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    _createEmailTextField.delegate = self;
//    _createEmailTextField.keyboardType = UIKeyboardTypeNumberPad;
    _createEmailTextField.clearButtonMode = YES;
    [_createEmailTextField setFont:[UIFont systemFontOfSize:25]];
    _createEmailTextField.inputAccessoryView = _toolBar;
    [_createScroller addSubview:_createEmailTextField];

    // setup phoneNumber tf
    _createPhoneNumber = [[UITextField alloc] init];
    [_createPhoneNumber setTranslatesAutoresizingMaskIntoConstraints:NO];
    _createPhoneNumber.backgroundColor = [UIColor whiteColor];
    _createPhoneNumber.layer.cornerRadius = 5;
//    [_createPhoneNumber setSecureTextEntry:YES];
    [_createPhoneNumber setPlaceholder:@"(OPTIONAL) PHONE NUMBER" ];
    [_createPhoneNumber setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_createPhoneNumber setAutocorrectionType:UITextAutocorrectionTypeNo];
    _createPhoneNumber.delegate = self;
//    _createPhoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    _createPhoneNumber.clearButtonMode = YES;
    [_createPhoneNumber setFont:[UIFont systemFontOfSize:25]];
    _createPhoneNumber.inputAccessoryView = _toolBar;
    [_createScroller addSubview:_createPhoneNumber];
    
    // add submit button
    _createSubmit = [UIButton buttonWithType:UIButtonTypeSystem];
    [_createSubmit addTarget:self action:@selector(createAccount:) forControlEvents:UIControlEventTouchUpInside];
    [_createSubmit setTitle:@"SUBMIT" forState:UIControlStateNormal];
    [_createSubmit setTranslatesAutoresizingMaskIntoConstraints:NO];
    _createSubmit.layer.borderWidth=1.0f;
    _createSubmit.layer.borderColor=[[UIColor colorWithRed: 57.0f/255.0f
                                                     green: 132.0f/255.0f
                                                      blue: 57.0f/255.0f
                                                     alpha:1.0f] CGColor];
    [_createSubmit setBackgroundColor:[UIColor colorWithRed:68.0f/255.0f
                                                      green:157.0f/255.0f
                                                       blue:68.0f/255.0f
                                                      alpha:1.0f]];
    // set btn font color
    [_createSubmit setTitleColor:[UIColor colorWithRed:255/255.0
                                                 green:255/255.0
                                                  blue:255/255.0
                                                 alpha:1.0f] forState:UIControlStateNormal];
    _createSubmit.layer.cornerRadius = 5;
    [_createScroller addSubview:_createSubmit];
    
    // add cancel button
    _btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btnCancel addTarget:self action:@selector(dismissCreateScene:) forControlEvents:UIControlEventTouchUpInside];
    [_btnCancel setTitle:@"CANCEL" forState:UIControlStateNormal];
    [_btnCancel setTranslatesAutoresizingMaskIntoConstraints:NO];
    _btnCancel.layer.borderWidth=1.0f;
    _btnCancel.layer.borderColor=[[UIColor colorWithRed: 172/255.0f
                                                  green: 41/255.0f
                                                   blue: 37/255.0f
                                                  alpha:1.0f] CGColor];
    [_btnCancel setBackgroundColor:[UIColor colorWithRed:201.0f/255.0f
                                                   green:48.0f/255.0f
                                                    blue:44.0f/255.0f
                                                   alpha:1.0f]];
    
    
    // set btn font color
    [_btnCancel setTitleColor:[UIColor colorWithRed:255/255.0
                                              green:255/255.0
                                               blue:255/255.0
                                              alpha:1.0f] forState:UIControlStateNormal];
    _btnCancel.layer.cornerRadius = 5;
    [_createScroller addSubview:_btnCancel];

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
    // navBar sits on top of scroller
    [self.view addSubview:_navBar];
}
#pragma mark - Add UI Element Constraints
-(void)addUIElementConstraints {
    
    // add constraints for _createUsernametf
    NSLayoutConstraint *pullcreatetfToTop = [NSLayoutConstraint constraintWithItem:_createUserTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:80.0];
    
    // center horizontaly in view
//    NSLayoutConstraint *centerXcreatetf = [NSLayoutConstraint constraintWithItem:_createUserTextField                                                attribute:NSLayoutAttributeCenterX                                                               relatedBy:NSLayoutRelationEqual toItem:_createUserTextField.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint *pullcreateToRight = [NSLayoutConstraint constraintWithItem:_createUserTextField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-35];
    
    NSLayoutConstraint *pullcreateToLeft = [NSLayoutConstraint constraintWithItem:_createUserTextField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:35];

    
    [_createUserTextField addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_createUserTextField(==50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_createUserTextField)]];
    
    // add constraints
    [_createUserTextField.superview addConstraints:@[pullcreatetfToTop,  pullcreateToRight, pullcreateToLeft]]; // centerXcreatetf,
    
    // add constraints for _createPintf
    NSLayoutConstraint *pullcreatePintfToTop = [NSLayoutConstraint constraintWithItem:_createPinTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:140.0];
    
    NSLayoutConstraint *pullcreatePinToRight = [NSLayoutConstraint constraintWithItem:_createPinTextField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-35];
    
    NSLayoutConstraint *pullcreatePinToLeft = [NSLayoutConstraint constraintWithItem:_createPinTextField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:35];
    
    
    [_createPinTextField addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_createPinTextField(==50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_createPinTextField)]];
    
    // center horizontaly in view
//    NSLayoutConstraint *centerXcreatePintf = [NSLayoutConstraint constraintWithItem:_createPinTextField                                                attribute:NSLayoutAttributeCenterX                                                               relatedBy:NSLayoutRelationEqual toItem:_createPinTextField.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    
    // add constraints
    [_createUserTextField.superview addConstraints:@[pullcreatePintfToTop, pullcreatePinToLeft, pullcreatePinToRight]]; //centerXcreatePintf
    
    // add constraints for _createPinRetf
    NSLayoutConstraint *pullcreatePinRetfToTop = [NSLayoutConstraint constraintWithItem:_createPinReTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:200.0];
    
    // center horizontaly in view
//    NSLayoutConstraint *centerXcreatePinRetf = [NSLayoutConstraint constraintWithItem:_createPinReTextField                                                attribute:NSLayoutAttributeCenterX                                                               relatedBy:NSLayoutRelationEqual toItem:_createPinReTextField.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint *pullcreatePinReToRight = [NSLayoutConstraint constraintWithItem:_createPinReTextField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-35];
    
    NSLayoutConstraint *pullcreatePinReToLeft = [NSLayoutConstraint constraintWithItem:_createPinReTextField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:35];

    
    [_createPinReTextField addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_createPinReTextField(==50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_createPinReTextField)]];

    // add constraints
    [_createPinReTextField.superview addConstraints:@[pullcreatePinRetfToTop, pullcreatePinReToLeft, pullcreatePinReToRight]]; // centerXcreatePinRetf
    
    // add constraints for _createEmailtf
    NSLayoutConstraint *pullcreateEmailtfToTop = [NSLayoutConstraint constraintWithItem:_createEmailTextField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:260.0];
    
    // center horizontaly in view
//    NSLayoutConstraint *centerXcreateEmailtf = [NSLayoutConstraint constraintWithItem:_createEmailTextField                                                attribute:NSLayoutAttributeCenterX                                                               relatedBy:NSLayoutRelationEqual toItem:_createEmailTextField.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    
    [_createEmailTextField addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_createEmailTextField(==50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_createEmailTextField)]];
    
    NSLayoutConstraint *pullcreateEmailToRight = [NSLayoutConstraint constraintWithItem:_createEmailTextField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-35];
    
    NSLayoutConstraint *pullcreateEmailToLeft = [NSLayoutConstraint constraintWithItem:_createEmailTextField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:35];

    // add constraints
    [_createEmailTextField.superview addConstraints:@[pullcreateEmailtfToTop, pullcreateEmailToLeft, pullcreateEmailToRight]]; // centerXcreateEmailtf
    
    // add constraints for _createPhoneNumbertf
    NSLayoutConstraint *pullcreatePhoneNumbertfToTop = [NSLayoutConstraint constraintWithItem:_createPhoneNumber attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:320.0];
    
    // center horizontaly in view
//    NSLayoutConstraint *centerXcreatePhoneNumbertf = [NSLayoutConstraint constraintWithItem:_createPhoneNumber                                                attribute:NSLayoutAttributeCenterX                                                               relatedBy:NSLayoutRelationEqual toItem:_createPhoneNumber.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    
    [_createPhoneNumber addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_createPhoneNumber(==50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_createPhoneNumber)]];
    
    NSLayoutConstraint *pullcreatePhoneNumberToRight = [NSLayoutConstraint constraintWithItem:_createPhoneNumber attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-35];
    
    NSLayoutConstraint *pullcreatePhoneNumberToLeft = [NSLayoutConstraint constraintWithItem:_createPhoneNumber attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:35];
    
    // add constraints
    [_createPhoneNumber.superview addConstraints:@[pullcreatePhoneNumbertfToTop, pullcreatePhoneNumberToLeft, pullcreatePhoneNumberToRight]]; // centerXcreatePhoneNumbertf,
    
    // add constraints for submit btn, bottom / left
    NSLayoutConstraint *pullSubmitToBottom = [NSLayoutConstraint constraintWithItem:_createSubmit attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-15.0];
    
    NSLayoutConstraint *pullSubmitToLeft = [NSLayoutConstraint constraintWithItem:_createSubmit attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15.0];
    
    [_createSubmit addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_createSubmit(==130)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_createSubmit)]];
    
    [_createSubmit addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_createSubmit(==60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_createSubmit)]];
    
    [_createSubmit.superview addConstraints:@[pullSubmitToBottom, pullSubmitToLeft]];
    
    // add constraints for cancel btn, bottom / right
    NSLayoutConstraint *pullCancelToBottom = [NSLayoutConstraint constraintWithItem:_btnCancel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-15.0];
    
    NSLayoutConstraint *pullCancelToRight = [NSLayoutConstraint constraintWithItem:_btnCancel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-15.0];
    
    [_btnCancel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_btnCancel(==130)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_btnCancel)]];
    
    [_btnCancel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_btnCancel(==60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_btnCancel)]];
    
    [_btnCancel.superview addConstraints:@[pullCancelToBottom, pullCancelToRight]];

}
#pragma mark - Clear TextFields
-(void)clearTextFields {
    _createUserTextField.text = @"";
    _createEmailTextField.text = @"";
    _createPhoneNumber.text = @"";
    _createPinTextField.text = @"";
    _createPinReTextField.text = @"";

}
#pragma mark - View Did Load
- (void)viewDidLoad {
    [super viewDidLoad];
    _previousTextField  =nil;
    [self addUIElements];
    [self addUIElementConstraints];
    [self clearTextFields];
    
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
}

/*
 * method to limit character input in text fields
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField == _createUserTextField) return (_createUserTextField.text.length + string.length <=16);
    if(textField == _createPinTextField) return (_createPinTextField.text.length + string.length <= 4);
    if(textField == _createPinReTextField) return (_createPinReTextField.text.length + string.length <=4);
    if(textField == _createPhoneNumber) return (_createPhoneNumber.text.length + string.length <=10);
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
    [self animateTextField:textField up:YES withOffset:textField.frame.origin.y / 2];
    
//    [_previousTextField resignFirstResponder];
//    [_previousTextField setInputAccessoryView:nil];
//    currentTextField = textFieldView;
//    [currentTextField setInputAccessoryView:_toolBar];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [_previousTextField resignFirstResponder];
    [_previousTextField setInputAccessoryView:nil];
    return YES;
}
/*
 * method to determine values in text fields - compare pins,
 */
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [self animateTextField:textField up:NO withOffset:textField.frame.origin.y / 2];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return true;
}


- (IBAction)dismissKeyboard:(id)sender {
[_createUserTextField resignFirstResponder];
[_createPinTextField resignFirstResponder];
[_createPinReTextField resignFirstResponder];
[_createEmailTextField resignFirstResponder];
[_createPhoneNumber resignFirstResponder];
    [self.view endEditing:YES];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up withOffset:(CGFloat)offset
{
    const int movementDistance = -offset;
    const float movementDuration = 0.4f;
    int movement = (up ? movementDistance : -movementDistance);
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

/*
 * CREATE - to pull text from text fields and store in account database
 */
#pragma mark - Create Account
- (IBAction)createAccount:(id)sender {
    
    NSLog(@"inside createAccount method");
    
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
        
        NSError *error;
        
        
        [_createAccountSuccess setHidden:NO];
#ifdef DEBUG
        NSLog(@"Succefully created account.");
#endif
        // pass user tf text to home screen
        
        // call saveLastLoginTime method
//        [self saveLastLoginTime];
        
        // get current time
        NSString *timestamp = TimeStamp;
        NSLog(@"current time = %@",timestamp); // ex. 1427178876698.blah
        _loginTime = [[NSDate alloc] init];
        
        // adjust timezone
        NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:_loginTime];
        NSDate *localDate = [_loginTime dateByAddingTimeInterval:timeZoneOffset];
        
        newAccount.lastLogin = localDate;
        NSLog(@"login time = %@",newAccount.lastLogin);
        // save anAccount.lastLogin attribute to Core Data DB
        
        [_managedObjectContext save:&error];
        
        
        
        username = _createUserTextField.text;
        if ([_createUserTextField.text  isEqual:@"root"]){
            UIStoryboard *storyboardLocal = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
            ViewControllerRootHome *rootHome = [storyboardLocal instantiateViewControllerWithIdentifier:@"rootHome"];
            [self presentViewController:rootHome animated:YES completion:nil];
        }
        else {
            // Load ViewControllerHome
            UIStoryboard *storyboardLocal = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
            
            ViewControllerHome *home = [storyboardLocal instantiateViewControllerWithIdentifier:@"Home"];
            home.un = self.createUserTextField.text;

            [self presentViewController:home animated:YES completion:nil];
        }
    }
}

- (void)saveLastLoginTime {
    // get current time
    NSString *timestamp = TimeStamp;
    NSLog(@"current time = %@",timestamp); // ex. 1427178876698.blah
    _loginTime = [[NSDate alloc] init];
    
    // adjust timezone
    NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:_loginTime];
    NSDate *localDate = [_loginTime dateByAddingTimeInterval:timeZoneOffset];
    
    Account *anAccount;
    anAccount.lastLogin = localDate;
    NSLog(@"login time = %@",anAccount.lastLogin);
    // save anAccount.lastLogin attribute to Core Data DB
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
        NSLog(@"error %@", error);
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

#pragma mark - View Will Appear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
#pragma mark - View Will Disappear
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - toolbar next method
- (IBAction) next:(id)sender
{
    if([self.createUserTextField isFirstResponder]) {
        [self.createUserTextField resignFirstResponder];
     [self.createPinTextField becomeFirstResponder];
    }
    
    else if ([self.createPinTextField isFirstResponder]){
        [self.createPinTextField resignFirstResponder];
     [self.createPinReTextField becomeFirstResponder];
    }
    
    else if ([self.createPinReTextField isFirstResponder]){
        [self.createPinReTextField resignFirstResponder];
        [self.createEmailTextField becomeFirstResponder];
    }
    
    else if ([self.createEmailTextField isFirstResponder]){
        [self.createEmailTextField resignFirstResponder];
        [self.createPhoneNumber becomeFirstResponder];
    }
    
    else if ([self.createPhoneNumber isFirstResponder]) {
        [self.createPhoneNumber resignFirstResponder];
        [self.createUserTextField becomeFirstResponder];
    }
}
#pragma mark - toolbar previous method
- (IBAction) prev: (id)sender
{
    if([self.createUserTextField isFirstResponder]) {
        [self.createUserTextField resignFirstResponder];
        [self.createPhoneNumber becomeFirstResponder];
    }
    
    else if ([_createPinTextField isFirstResponder]) {
        [_createPinTextField resignFirstResponder];
        [self.createUserTextField becomeFirstResponder];
    }
    
    else if ([_createPinReTextField isFirstResponder]){
        [_createPinReTextField resignFirstResponder];
        [self.createPinTextField becomeFirstResponder];
    }
    
    else if ([_createEmailTextField isFirstResponder]) {
        [_createEmailTextField resignFirstResponder];
        [self.createPinReTextField becomeFirstResponder];
    }
    
    else if ([_createPhoneNumber isFirstResponder]) {
        [_createPhoneNumber resignFirstResponder];
        [self.createEmailTextField becomeFirstResponder];
    }
}

# pragma mark - device orientation
/*
 * methods to determine screen layout
 */
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
#endif
}
@end