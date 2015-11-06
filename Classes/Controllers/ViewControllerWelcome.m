//
//  ViewControllerWelcome.m
//  KegCop
//
//  Created by capin on 6/3/12.
//

#import "ViewControllerWelcome.h"

#define TimeStamp [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]
// keyboard offset
#define kOFFSET_FOR_KEYBOARD 300.0

@interface ViewControllerWelcome ()
{
// declare private methods here
    dispatch_queue_t scan_queue;
    UIScrollView *avatarScroll;
}
@property(nonatomic, retain) NSDate *loginTime;
@property(nonatomic, retain) UIButton *avatarButton;
@property(nonatomic, retain) NSArray *results;
@property(nonatomic, retain) NSMutableArray *last5LoginArray;
// GUI
@property (nonatomic, retain) UINavigationBar *navBar;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIScrollView *welcomeScroller;
@property (nonatomic, retain) UITextField *textFieldUsername;
@property (nonatomic, retain) UITextField *textFieldPin;
@property (weak, nonatomic) IBOutlet UILabel *wrongUserPin;
@property (nonatomic, retain) UIButton *welcomeLogin;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *welcomeActivityIndicator;
@property (nonatomic, retain) UILabel *test;
// info button - located lower right
@property(nonatomic, retain) UIButton *welcomeAbout;

@property (weak, nonatomic) IBOutlet UIButton *btnForgot;
@property (nonatomic, retain) UIButton *btnCreate;
// keyboard toolbar
// toolbar
@property (retain, nonatomic) UIToolbar *toolBar;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *doneButton;


@end

@implementation ViewControllerWelcome {
    
    NSString *username;
    // RFID stuff
    NSMutableString *scantagid;
    // legal disclaimer
    UIAlertView *alertlegal;
    AppDelegate *appDelegate;
    UIStoryboard *storyboard;
    bool moved;
}

- (NSString *)receiveUserName {
    return _textFieldUsername.text;
}
#pragma mark - keyboard methods
-(void)keyboardWillShow {
    // animate the current view out of the way
    if (_contentView.frame.origin.y >= 0) {
        [self setViewMovedUp:YES];
    }
    else if (_contentView.frame.origin.y < 0) {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (_contentView.frame.origin.y >= 0) {
        [self setViewMovedUp:YES];
    }
    else if (_contentView.frame.origin.y < 0) {
        [self setViewMovedUp:NO];
    }
}

-(void)setViewMovedUp:(BOOL)movedUp {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = _contentView.frame;
    if (movedUp) {
        // 1. move the view's origin up
        // 2. increase the size of the view,
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else {
        // revert back to the normal state
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    _contentView.frame = rect;
    
    [UIView commitAnimations];
}

#pragma mark - Add GUI Elements
-(void)addGUIElements {
    
    _toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    _toolBar.barStyle = UIBarStyleBlackTranslucent;
    _toolBar.items = [NSArray arrayWithObjects:
                      [[UIBarButtonItem alloc]initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(prev:)],
                      [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(next:)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(textFieldDidEndEditing:)],
                           nil];
    [_toolBar sizeToFit];
    
    
    // navBar
    _navBar = [[UINavigationBar alloc] init];
    [_navBar setFrame:CGRectMake(0,0,CGRectGetWidth(self.view.frame),64)];
    
    UINavigationItem *titleItem = [[UINavigationItem alloc] initWithTitle:@"KegCop"];
    
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
    _welcomeScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _welcomeScroller.userInteractionEnabled = YES;
    _welcomeScroller.scrollEnabled = YES;
    _welcomeScroller.showsHorizontalScrollIndicator = YES;
    _welcomeScroller.showsVerticalScrollIndicator = YES;

    [_welcomeScroller setBackgroundColor:[UIColor colorWithRed:100.0f/255.0f
                                                         green:83.0f/255.0f
                                                          blue:0.0f/255.0f
                                                         alpha:1.0f]];

    [self.view addSubview:_welcomeScroller];
    CGSize welcomeScrollerSize = CGSizeMake(self.view.bounds.size.width, 1000);
    [_welcomeScroller setContentSize:welcomeScrollerSize];
    
    // add the content view (contains auto layout constraints)
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    _contentView = [[UIView alloc] initWithFrame:applicationFrame];
    _contentView.backgroundColor = [UIColor colorWithRed:(245/255.0)
                                                   green:(208/255.0)
                                                    blue:(55/255)
                                                   alpha:(1.0f) ];
    [_welcomeScroller addSubview:_contentView];
    [_contentView addSubview:_navBar];
#ifdef DEBUG
//    // add test label
//    _test = [[UILabel alloc] initWithFrame:CGRectMake(200, 200, 200, 200)];
//    [_test setText:@"TEST"];
//    [_test setFont:[UIFont systemFontOfSize:44]];
//    [_test setBackgroundColor:[UIColor redColor]];
//    [_contentView addSubview:_test];
#endif
    
    // add about btn to lower right
    _welcomeAbout = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [_welcomeAbout addTarget:self action:@selector(showAboutScreen:) forControlEvents:UIControlEventTouchUpInside];
    [_welcomeAbout setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_contentView addSubview:_welcomeAbout];
    
    // add create button just above info button
    _btnCreate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btnCreate addTarget:self action:@selector(showCreateScene:) forControlEvents:UIControlEventTouchUpInside];
    [_btnCreate setTitle:@"CREATE AN ACCOUNT" forState:UIControlStateNormal];
    [_btnCreate setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_contentView addSubview:_btnCreate];
    
    // add login button just above create button
    _welcomeLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_welcomeLogin addTarget:self action:@selector(processLogin:) forControlEvents:UIControlEventTouchUpInside];
    [_welcomeLogin setTitle:@"LOGIN" forState:UIControlStateNormal];
    [_welcomeLogin setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_contentView addSubview:_welcomeLogin];
    
    // add tf pin just above login button
    _textFieldPin = [[UITextField alloc] init];
    [_textFieldPin setTranslatesAutoresizingMaskIntoConstraints:NO];
    _textFieldPin.backgroundColor = [UIColor whiteColor];
    _textFieldPin.layer.cornerRadius = 5;
    [_textFieldPin setSecureTextEntry:YES];
    [_textFieldPin setAutocorrectionType:NO];
    [_textFieldPin setFont:[UIFont systemFontOfSize:30]];
    [_textFieldPin setPlaceholder:@"PIN" ];
    _textFieldPin.delegate = self;
    _textFieldPin.keyboardType = UIKeyboardTypeNumberPad;
    _textFieldPin.inputAccessoryView = _toolBar;
    [_contentView addSubview:_textFieldPin];
    
    // add tf username just above tf pin
    _textFieldUsername = [[UITextField alloc] init];
    [_textFieldUsername setTranslatesAutoresizingMaskIntoConstraints:NO];
    _textFieldUsername.backgroundColor = [UIColor whiteColor];
    _textFieldUsername.layer.cornerRadius = 5;
    [_textFieldUsername setFont:[UIFont systemFontOfSize:30]];
    [_textFieldUsername setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_textFieldUsername setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_textFieldUsername setPlaceholder:@"USERNAME"];
    _textFieldUsername.delegate = self;
    _textFieldUsername.inputAccessoryView = _toolBar;
    [_contentView addSubview:_textFieldUsername];

    // add borders for buttons, iOS 7 fix - 5JAN14
    // use twitterbootstrap color scheme
    // www.javascripter.net/faq/hextorgb.htm
    
    _welcomeLogin.layer.borderWidth=1.0f;
    _welcomeLogin.layer.borderColor=[[UIColor colorWithRed: 57.0f/255.0f
                                                     green: 132.0f/255.0f
                                                      blue: 57.0f/255.0f
                                                     alpha:1.0f] CGColor];
    [_welcomeLogin setBackgroundColor:[UIColor colorWithRed:68.0f/255.0f
                                                      green:157.0f/255.0f
                                                       blue:68.0f/255.0f
                                                      alpha:1.0f]];
    // set btn font color
    [_welcomeLogin setTitleColor:[UIColor colorWithRed:255/255.0
                                                 green:255/255.0
                                                  blue:255/255.0
                                                 alpha:1.0f] forState:UIControlStateNormal];
    _welcomeLogin.layer.cornerRadius = 5;
    // end welcome btn
    
    _btnForgot.layer.borderWidth=1.0f;
    _btnForgot.layer.borderColor=[[UIColor colorWithRed: 172/255.0f
                                                  green: 41/255.0f
                                                   blue: 37/255.0f
                                                  alpha:1.0f] CGColor];
    [_btnForgot setBackgroundColor:[UIColor colorWithRed:201.0f/255.0f
                                                   green:48.0f/255.0f
                                                    blue:44.0f/255.0f
                                                   alpha:1.0f]];
    
    
    // set btn font color
    [_btnForgot setTitleColor:[UIColor colorWithRed:255/255.0
                                              green:255/255.0
                                               blue:255/255.0
                                              alpha:1.0f] forState:UIControlStateNormal];
    _btnForgot.layer.cornerRadius = 5;
    // end forgot btn
    
    
    _btnCreate.layer.borderWidth=1.0f;
    _btnCreate.layer.borderColor=[[UIColor colorWithRed: 53.0f/255.0f
                                                  green: 126.0f/255.0f
                                                   blue: 189.0f/255.0f
                                                  alpha:1.0f] CGColor];
    
    [_btnCreate setBackgroundColor:[UIColor colorWithRed:66.0f/255.0f
                                                   green:139.0f/255.0f
                                                    blue:202.0f/255.0f
                                                   alpha:1.0f]];
    
    
    // set btn font color
    [_btnCreate setTitleColor:[UIColor colorWithRed:255/255.0
                                              green:255/255.0
                                               blue:255/255.0
                                              alpha:1.0f] forState:UIControlStateNormal];
    
    _btnCreate.layer.cornerRadius = 5;
    // end _btnCreate
    
    // hidden at load
    [_wrongUserPin setHidden:YES];
    
    // enable clear button for text fields
    _textFieldUsername.clearButtonMode=YES;
    _textFieldPin.clearButtonMode = YES;
    
    
    // change textfield outline / border color
    _textFieldUsername.layer.borderColor = [UIColor whiteColor].CGColor;
    //    _textFieldUsername.layer.cornerRadius = 5;
    _textFieldUsername.layer.masksToBounds = true;
    
    // change color of txt for tfUserName / tfPin
    _textFieldUsername.textColor = [UIColor colorWithRed:100.0f/255.0f
                                                   green:83.0f/255.0f
                                                    blue:0.0f/255.0f
                                                   alpha:1.0f];
    
    _textFieldPin.textColor = [UIColor colorWithRed:100.0f/255.0f
                                              green:83.0f/255.0f
                                               blue:0.0f/255.0f
                                              alpha:1.0f];
    
    
    // hide forgot pin btn
    _btnForgot.hidden = TRUE;

}
#pragma mark - Add GUI Element Constraints
-(void)addGUIElementConstraints {
    
    // add constraints, bottom / right for _welcomeAbout
    NSLayoutConstraint *pullToBottom = [NSLayoutConstraint constraintWithItem:_welcomeAbout attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10.0];
    
    NSLayoutConstraint *pullToRight = [NSLayoutConstraint constraintWithItem:_welcomeAbout attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10];
    
    [_contentView addConstraints:@[pullToBottom, pullToRight]];
    
    NSLayoutConstraint *pullCreateToBottom = [NSLayoutConstraint constraintWithItem:_btnCreate attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-40.0];
    
    NSLayoutConstraint *pullCreateToRight = [NSLayoutConstraint constraintWithItem:_btnCreate attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-35];
    
     NSLayoutConstraint *pullCreateToLeft = [NSLayoutConstraint constraintWithItem:_btnCreate attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:35];
    
//    [_btnCreate addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_btnCreate(==250)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_btnCreate)]];
    
    [_btnCreate addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_btnCreate(==60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_btnCreate)]];
    
    [_contentView addConstraints:@[pullCreateToBottom, pullCreateToRight, pullCreateToLeft]];
    
    NSLayoutConstraint *pullLoginToBottom = [NSLayoutConstraint constraintWithItem:_welcomeLogin attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-120.0];
    
    NSLayoutConstraint *pullLoginToRight = [NSLayoutConstraint constraintWithItem:_welcomeLogin attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-35];
    
    NSLayoutConstraint *pullLoginToLeft = [NSLayoutConstraint constraintWithItem:_welcomeLogin attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:35];
    
//    [_welcomeLogin addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_welcomeLogin(==250)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_welcomeLogin)]];
    
    [_welcomeLogin addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_welcomeLogin(==60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_welcomeLogin)]];

    [_contentView addConstraints:@[pullLoginToBottom, pullLoginToRight, pullLoginToLeft]];
    
    // add tf pin constraints below
    NSLayoutConstraint *pulltfPinToBottom = [NSLayoutConstraint constraintWithItem:_textFieldPin attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-190.0];
    
    NSLayoutConstraint *pulltfPinToRight = [NSLayoutConstraint constraintWithItem:_textFieldPin attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-35];
    
    NSLayoutConstraint *pulltfPinToLeft = [NSLayoutConstraint constraintWithItem:_textFieldPin attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:35];
    
//    [_textFieldPin addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_textFieldPin(==250)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textFieldPin)]];
    
    [_textFieldPin addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_textFieldPin(==50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textFieldPin)]];

    [_contentView addConstraints:@[pulltfPinToBottom, pulltfPinToRight,pulltfPinToLeft]];
    
    // add tf username constraints below
    NSLayoutConstraint *pulltfUsernameToBottom = [NSLayoutConstraint constraintWithItem:_textFieldUsername attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-260.0];
    
    NSLayoutConstraint *pulltfUsernameToRight = [NSLayoutConstraint constraintWithItem:_textFieldUsername attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-35];
    
    NSLayoutConstraint *pulltfUsernameToLeft = [NSLayoutConstraint constraintWithItem:_textFieldUsername attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:35];
    
//    [_textFieldUsername addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_textFieldUsername(==250)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textFieldUsername)]];
    
    [_textFieldUsername addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_textFieldUsername(==50)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textFieldUsername)]];
    
    [_contentView addConstraints:@[pulltfUsernameToBottom, pulltfUsernameToRight,pulltfUsernameToLeft]];
}
#pragma mark - View Did Load
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addGUIElements];
    [self addGUIElementConstraints];
    
    // Core Data
    if (_managedObjectContext == nil)
    {
        _managedObjectContext = [[AccountsDataModel sharedDataModel]mainContext];
#ifdef DEBUG
    NSLog(@"After _managedObjectContext: %@",  _managedObjectContext);
#endif
    }
    
    // threading stuff - GCD
    scan_queue = dispatch_queue_create("com.chrisrjones.kegcop", NULL);
    // put blocks of code into curly braces to run on separate thread
    dispatch_async(scan_queue, ^{
        // execute on separate thread (non main)
    });
    
    // RFID stuff
    scantagid = [[NSMutableString alloc] init];
    
    // get the status bar back
    // see SO thread - stackoverflow.com/questions/17678881/
    [self setNeedsStatusBarAppearanceUpdate];
    
    // create a subview for avatar buttons
    UIView *avatarView = [[UIView alloc] init];
    avatarView.frame = CGRectMake(20, 125, 280, 100); // don't mess with these values.
//    avatarView.layer.borderColor = [UIColor redColor].CGColor;
//    avatarView.layer.borderWidth = 3.0f;
    [self.view addSubview:avatarView];
    
    avatarScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    avatarScroll.contentSize = CGSizeMake(500, 500);
    avatarScroll.scrollEnabled = YES;
    [avatarView addSubview:avatarScroll];
    
    
//    [self addAvatarsToButtons];
}
# pragma mark - Fill Username from Avatar Button
-(void)fillUserName {
#ifdef DEBUG
    NSLog(@"avatar button press works :)");
#endif
    
    // need to get NSMutableArray *avatars from addAvatarsToButtons method
}
# pragma mark - Fetch Avatars / Create Avatars
-(void)fetchAvatarLoginsAndCreateAvatarButtons {
    // fetch Data from Core Data
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // fetch records and handle error
    NSError *error;
    _results = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // sort results array by lastLogin
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"lastLogin" ascending:NO];
    NSArray *sortedArray = [NSArray arrayWithObject:sort];
    NSArray *sortedArray2 = [_results sortedArrayUsingDescriptors:sortedArray];
    // how to remove values from NSArray
    NSArray *lastLoginArray = [sortedArray2 valueForKey:@"lastLogin"];
    
    _last5LoginArray = [[NSMutableArray alloc] initWithArray:[lastLoginArray subarrayWithRange:NSMakeRange(0, 5)] ];
#ifdef DEBUG
    NSLog(@"last5LoginArray = %@",_last5LoginArray);
#endif
    
    CGFloat staticX = 0;
    CGFloat staticWidth = 80;
    CGFloat staticHeight = 80;
    CGFloat staticPadding = 5;
    
    // need to put the avatars stored in sortedArray2 in the scrollView
    for ( int i = 0; i < 5; i++) {
        // do additional loading for avatars
        _avatarButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        // the last two values control the size of the button
        _avatarButton.frame = CGRectMake(0, 0, 80, 80);
        [_avatarButton setFrame:CGRectMake((staticX + (i * (staticHeight + staticPadding))),5,staticWidth,staticHeight)];
        // make corners round
        _avatarButton.layer.cornerRadius = 40; // value varies -- // 35 yields a pretty good circle.
        _avatarButton.clipsToBounds = YES;
        // assign method / action to button
        [_avatarButton addTarget:self action:@selector(fillUserName) forControlEvents:UIControlEventTouchDown];
        // create a stock image
        UIImage *btnImage = [UIImage imageNamed:@"HomeBrewPoster1.jpg"];
        
        [_avatarButton setBackgroundImage:btnImage forState:UIControlStateNormal];
        
        // this should add 5x buttons
        [avatarScroll addSubview:_avatarButton];
    }
}
# pragma mark - Add Avatar to Button
-(void)addAvatarsToButtons {
    NSMutableArray *avatars = [NSMutableArray arrayWithCapacity:5];
    Account *anAccount;
    for ( anAccount in _results) {
        if( anAccount.avatar == nil) {
            UIImage *avtarImg = [UIImage imageNamed:@"HomeBrewPoster1.jpg"];
            // convert UIImage to NSData
            NSData *imageData = UIImageJPEGRepresentation(avtarImg, 1.0);
            // save data to account
            anAccount.avatar = imageData;
            NSError *error = nil;
            if (![_managedObjectContext save:&error]) {
#ifdef DEBUG
                NSLog(@"error %@", error);
#endif
            }
        }else if([_last5LoginArray containsObject:anAccount.lastLogin]) { // the following line could be trouble
#ifdef DEBUG
            NSLog(@"anAccount.lastLogin = %@",anAccount.lastLogin);
#endif
            UIImage *avatarImg = [UIImage imageWithData:anAccount.avatar ];
            // apply avImg to btn
            [avatars addObject:avatarImg];
        }
    }
#ifdef DEBUG
    NSLog(@"avatars = %@",avatars);
#endif
NSAssert(
         avatars.count == _last5LoginArray.count
,@"The loop is expected to find as many avatars as there are items in last5LoginArray"
);
    for ( int i = 0; i<5; i++) {
        // check that we have enough logins
        if ( i < _last5LoginArray.count) {
            [_avatarButton setBackgroundImage:avatars[i] forState:UIControlStateNormal];
        }
    }
}
#pragma mark - Status bar method
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#pragma mark - text field delegate methods
-(void)textFieldDidBeginEditing:(UITextField *)sender{
 
    [sender setInputAccessoryView:_toolBar];
    
//    if(!moved) {
//        [self animateViewToPosition:_contentView directionUP:YES];
//        moved = YES;
//    }
    
//    if ([sender isEqual:_textFieldUsername]) {
//        // move the main view, so the keyboard doesn't hide it.
//        if (_contentView.frame.origin.y >= 0) {
//            [self setViewMovedUp:YES];
//        }
//    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [_textFieldUsername resignFirstResponder];
    [_textFieldPin resignFirstResponder];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_textFieldUsername resignFirstResponder];
    [_textFieldPin resignFirstResponder];
//    if(moved) {
//        [self animateViewToPosition:_contentView directionUP:NO];
//    }
//    moved = NO;
    return YES;
}
# pragma mark - Animate View - Direction Up
-(void)animateViewToPosition:(UIView *)viewToMove directionUP:(BOOL)up {
    const int movementDistance = -60; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = ( up ? movementDistance : -movementDistance);
    [UIView beginAnimations:@"animateTextField" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    viewToMove.frame = CGRectOffset(viewToMove.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)keyboardDidShow:(NSNotification *) notif{
    // keyboard becomes visible
    _contentView.frame = CGRectMake(_contentView.frame.origin.x,
                                    _contentView.frame.origin.y,
                                    _contentView.frame.size.width,
                                    _contentView.frame.size.height - 120); // move
}

- (void)keyboardDidHide: (NSNotification *) notif{
    //keyboard will hide
    _contentView.frame = CGRectMake(_contentView.frame.origin.x,
                                        _contentView.frame.origin.y,
                                        _contentView.frame.size.width,
                                        _contentView.frame.size.height + 120); // move
}

- (IBAction)dismissKeyboard:(id)sender {
    // welcome
    [_textFieldUsername resignFirstResponder];
    [_textFieldPin resignFirstResponder];
}

// method to dismiss keyboard - return button
- (IBAction) textFieldDoneEditing : (id) sender {
    [sender resignFirstResponder];
}
#pragma mark - Process Login
- (IBAction)processLogin:(id)sender {
    
    // hide keyboard
    [_textFieldUsername resignFirstResponder];
    [_textFieldPin resignFirstResponder];

    
    // First - make activity indicator visible, then start animating, then turn of wrong user / pin label
    _welcomeActivityIndicator.hidden = FALSE;
    [_welcomeActivityIndicator startAnimating ];
    
    [_wrongUserPin setHidden:YES];
        
    // check if username and pin text fields are populated
    if ([_textFieldUsername.text length ] == 0 &&  [_textFieldPin.text length ] == 0)
    {
        [_welcomeActivityIndicator stopAnimating];
        [_wrongUserPin setHidden:NO];   
    }
    
    // CORE DATA
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:_managedObjectContext];
    
    // set entity for request
    [request setEntity:entity];
        
    // filter results using a predicate
    NSPredicate *pred =[NSPredicate predicateWithFormat:(@"username = %@"), _textFieldUsername.text];
    
    // set predicate for the request
    [request setPredicate:pred];
    
    NSError *error = nil;
    
    // store DB usernames in results array
    NSArray *results = [_managedObjectContext executeFetchRequest:request error:&error];
#ifdef DEBUG
    NSLog(@"The returned results are %@",results);
#endif
    // check text field against results stored in DB
    for (Account *anAccount in results) {
        if ([anAccount.username isEqualToString:_textFieldUsername.text]){
#ifdef DEBUG
            NSLog(@"Your username exists");
#endif
            
            // PASSWORD - PIN AUTHENTICATION
            
            /*
             * 0) establish secret key
             * 1) get value stored in DB
             * 1.1) convert / decode base64 string to NSData
             * 2) decrypt NSData
             * 3) convert data to string
             * 4) compare inputted text to decrptyed value
             */
            
            // password - set key
            NSString *key = @"donkey balls";
            
            // password - get value stored in Core Data DB
            NSString *secret = anAccount.pin;
        
            // password - print value of pin stored in DB
#ifdef DEBUG
            NSLog(@"DB pin = %@",secret);
#endif
            // password - decode base64 NSData
            NSData *cipher = [[NSData alloc ]base64DataFromString:secret];
            
            // password - decrypt data
            NSData *plain = [cipher AES256DecryptWithKey:key];
            
            // password - convert data to string
            NSString *strplain = [[NSString alloc] initWithData:plain encoding:NSUTF8StringEncoding];
            
            // password - display string
            // NSLog(@"%@",strplain);
            
            if ([strplain isEqualToString:_textFieldPin.text]){
        
                // play audio bell if user logs in correctly
                CFBundleRef mainBundle = CFBundleGetMainBundle();
                CFURLRef soundFileURLRef;
                soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (CFStringRef) @"Glass", CFSTR("aiff"), NULL);
                UInt32 soundID;
                AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID);
                AudioServicesPlaySystemSound(soundID);
                
                // Load ViewController(Root)Home
                if([anAccount.username isEqualToString:@"root"])
                {
//                    appDelegate = APPDELEGATE;
//                    storyboard = appDelegate.storyboard;
                    UIStoryboard *storyboardLocal = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
                    ViewControllerRootHome *rootHome = [storyboardLocal instantiateViewControllerWithIdentifier:@"rootHome"];
                    [self presentViewController:rootHome animated:YES completion:nil];
                    
                    // clear out / blank tfusername and tfpin
                    _textFieldUsername.text = @"";
                    _textFieldPin.text = @"";
                    // stop activityIndicator from spinning once logged in
                    [_welcomeActivityIndicator stopAnimating];
                }
                else {
//                    appDelegate = APPDELEGATE;
//                    storyboard = appDelegate.storyboard;
                    UIStoryboard *storyboardLocal = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
                    
                    ViewControllerHome *home = [storyboardLocal instantiateViewControllerWithIdentifier:@"Home"];
                   
                    // declare delegate property
//                    home.delegate = self;
                    
                    
                    // pass username text to home screen
                    home.un = _textFieldUsername.text;
                    
//                    [self passValues];
                    
//                    // get current time
//                    NSString *timestamp = TimeStamp;
//                    NSLog(@"current time = %@",timestamp); // ex. 1427178876698.blah
//                    _loginTime = [[NSDate alloc] init];
//                    
//                    // adjust timezone
//                    NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:_loginTime];
//                    NSDate *localDate = [_loginTime dateByAddingTimeInterval:timeZoneOffset];
//                    
//                    anAccount.lastLogin = localDate;
//                    NSLog(@"login time = %@",anAccount.lastLogin);
//                    // save anAccount.lastLogin attribute to Core Data DB
//                    NSError *error = nil;
//                    if (![_managedObjectContext save:&error]) {
//                        NSLog(@"error %@", error);
//                    }

                    [self presentViewController:home animated:YES completion:nil];
                    
                    // clear out / blank tfusername and tfpin
                    _textFieldUsername.text = @"";
                    _textFieldPin.text = @"";
                    // stop activityIndicator from spinning once logged in
                    [_welcomeActivityIndicator stopAnimating];
                }
            }
            else {
#ifdef DEBUG
                NSLog(@"Your pin is wrong");
#endif
                [_welcomeActivityIndicator stopAnimating];
                [_wrongUserPin setHidden:NO];
                }
            }
    
        else {
#ifdef DEBUG
            NSLog(@"Your username was not found");
#endif
            [_welcomeActivityIndicator stopAnimating];
            [_wrongUserPin setHidden:NO];
            }
    }
}

- (IBAction)showForgotScene:(id)sender {
#ifdef DEBUG
    NSLog(@"show Forgot Scene - begin");
#endif
    UIViewController *forgot = [self.storyboard instantiateViewControllerWithIdentifier:@"Forgot"];
    [self presentViewController:forgot animated:YES completion:nil];
#ifdef DEBUG
    NSLog(@"show Forgot Scene - end");
#endif
}

- (IBAction)showCreateScene:(id)sender {
    
    // display a UIAlertView displaying legal disclaimer.
    alertlegal = [[UIAlertView alloc] initWithTitle:@"Terms of Service" message:@"By clicking agree you abide to the terms of this application.\n\nThis iOS application is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the MIT License for more details.\n\nBy creating an account on this system you are NOT PAYING FOR BEER!  YOU ARE MAKING A DONATION TO THE PERSON WHO IS RESPONSIBLE FOR THE ADMIN / ROOT ACCOUNT ON THE SYSTEM  THE PERSON WHO GOVERNS THE ROOT ACCOUNT ON THE SYSTEM IS NOT RESPONSIBLE FOR YOUR DRINKING OR THE RESULTS FROM THE BEHAVIOR OF YOUR DRINKING.\n\nThat being said, PLEASE DRINK RESPONSIBLY, AND TRY TO HAVE SOME FUN." delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Agree", nil];
    
    // set the size of the UIAlertView
    //alertlegal.frame = CGRectMake(0, 200, 200, 200);
    
    // create UITextView containing disclaimer for UIAlertView
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 100, 260, 160)];
    
    // start x, start y, width, height
    
    [textView setText:@"This iOS application is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the MIT License for more details.\n\nBy creating an account on this system you are NOT PAYING FOR BEER!  YOU ARE MAKING A DONATION TO THE PERSON WHO IS RESPONSIBLE FOR THE ADMIN / ROOT ACCOUNT ON THE SYSTEM  THE PERSON WHO GOVERNS THE ROOT ACCOUNT ON THE SYSTEM IS NOT RESPONSIBLE FOR YOUR DRINKING OR THE RESULTS FROM THE BEHAVIOR OF YOUR DRINKING.\n\nThat being said, PLEASE DRINK RESPONSIBLY, AND TRY TO HAVE SOME FUN.\n\nBy clicking the agree button seen below this text I am stating that I have read this disclaimer, and that I will agree to the terms posted in this disclaimer."];
    
    textView.editable = NO;
    
    // testing
    textView.keyboardAppearance = UIKeyboardAppearanceAlert;

    
    // add the textView to the alertview
    [alertlegal addSubview:textView];
    
    [alertlegal show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    if (buttonIndex == 1) {
        
        // display ViewControllerCreate
        UIViewController *create = [self.storyboard instantiateViewControllerWithIdentifier:@"Create"];
        [self presentViewController:create animated:YES completion:nil];
        
    }
}

// to set the alertView frame size.
- (void)willPresentAlertView:(UIAlertView *)alertView {
    
    [alertView setFrame:CGRectMake(10, 100, 300, 320)];
}

- (IBAction)showAboutScreen:(id)sender {
    
    // method to show the About Screen
    UIViewController *about = [self.storyboard instantiateViewControllerWithIdentifier:@"About"];
    [self presentViewController:about animated:YES completion:nil];
}
#pragma mark - View Will Appear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - View Will Disappear
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - Keyboard Will Show
- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = self->_toolBar.frame;
    frame.origin.y = self.view.frame.size.height - 260.0;
    self->_toolBar.frame = frame;
    
    [UIView commitAnimations];
}
#pragma mark - Keyboard Will Hide
- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = self->_toolBar.frame;
    frame.origin.y = self.view.frame.size.height;
    self->_toolBar.frame = frame;
    
    [UIView commitAnimations];
}
#pragma mark - keyboard toolbar method - next
- (IBAction) next:(id)sender
{
    if([self.textFieldUsername isFirstResponder])[self.textFieldPin becomeFirstResponder];
    
    else if([self.textFieldPin isFirstResponder])[self.textFieldUsername becomeFirstResponder];
}
#pragma mark - keyboard toolbar method - prev
- (IBAction) prev:(id)sender
{
    if([self.textFieldUsername isFirstResponder])[self.textFieldPin becomeFirstResponder];
    
    else if([self.textFieldPin isFirstResponder])[self.textFieldUsername becomeFirstResponder];
}

-(void)onTick:(NSTimer *)timer {
    // do something
}
#pragma mark - RFID methods (OBSOLETE)
-(void)checkTagID {
    // create a method that spawns a new thread to listen for an RFID badge scan / swipe
    
    //scan_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(scan_queue, ^ { });
}

-(void)waitForTagScan {
    
}

# pragma mark - device orientation

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
#endif
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
@end