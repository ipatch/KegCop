//
//  ViewControllerWelcome.m
//  KegCop
//
//  Created by capin on 6/3/12.
//

#import "ViewControllerWelcome.h"

#define TimeStamp [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]

@interface ViewControllerWelcome ()
{
// declare private methods here
    dispatch_queue_t scan_queue;
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

@property (nonatomic, retain) UIButton *welcomeLogin;

@property (nonatomic, retain) UILabel *test;
// info button - located lower right
@property(nonatomic, retain) UIButton *welcomeAbout;

@property (weak, nonatomic) IBOutlet UIButton *btnForgot;
@property (nonatomic, retain) UIButton *btnCreate;

// keyboard toolbar
@property (retain, nonatomic) UIToolbar *toolBar;

// Avatar - properties
@property (retain, nonatomic) UIScrollView *avatarScroll;
@property (retain, nonatomic) NSArray *lastFiveLoginResults;
@property (retain, nonatomic) NSMutableDictionary *avatarButtonDictionary;

// delegation
@property (retain, nonatomic)NSString *userNameString;
@property (retain, nonatomic)UIImage *avatarImage;

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

- (void)doneClicked {
    [_textFieldUsername resignFirstResponder];
    [_textFieldPin resignFirstResponder];
}

#pragma mark - Add GUI Elements
-(void)addGUIElements {
    
    // MAKE SURE GUI ELEMENTS ARE INITIALIZED IN THE PROPER ORDER, OR APP WILL CRASH
    
    // add scroller to default view, self.view
    _welcomeScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _welcomeScroller.userInteractionEnabled = YES;
    _welcomeScroller.scrollEnabled = YES;
    _welcomeScroller.showsHorizontalScrollIndicator = YES;
    _welcomeScroller.showsVerticalScrollIndicator = YES;
    
    [_welcomeScroller setBackgroundColor:[UIColor colorWithRed:100.0f/255.0f
                                                         green:83.0f/255.0f
                                                          blue:0.0f/255.0f
                                                         alpha:1.0f]];
    CGSize welcomeScrollerSize = CGSizeMake(self.view.bounds.size.width, 1000);
    [_welcomeScroller setContentSize:welcomeScrollerSize];
    
    [self.view addSubview:_welcomeScroller];
    
    // add the content view (contains auto layout constraints)
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    _contentView = [[UIView alloc] initWithFrame:applicationFrame];
    _contentView.backgroundColor = [UIColor colorWithRed:(245/255.0)
                                                   green:(208/255.0)
                                                    blue:(55/255)
                                                   alpha:(1.0f) ];
    
    [_welcomeScroller addSubview:_contentView];
    
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
    [_contentView addSubview:_navBar];
    // END navBar
    
    // AVATARS
    // create a subview for avatar buttons
    _avatarScroll = [[UIScrollView alloc] init]; // initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    _avatarScroll.contentSize = CGSizeMake(500, 100); // 500 = width, 100 = height
    _avatarScroll.scrollEnabled = YES;

    _avatarScroll.layer.borderColor = [[UIColor colorWithRed:100.0f/255.0f
                                                       green:83.0f/255.0f
                                                        blue:0.0f/255.0f
                                                       alpha:1.0f]CGColor];
    _avatarScroll.layer.borderWidth = 1.0f;

    [_avatarScroll setTranslatesAutoresizingMaskIntoConstraints:NO];
    _avatarScroll.layer.cornerRadius = 5;
    _avatarScroll.backgroundColor = [UIColor colorWithRed:(204/255.0)
                                                    green:(173/255.0)
                                                     blue:(46/255)
                                                    alpha:(1.0f) ];
    [_contentView addSubview:_avatarScroll];
    
    // toolbar - displayed above keypad / keyboard
    _toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    _toolBar.barStyle = UIBarStyleBlackTranslucent;
    _toolBar.items = [NSArray arrayWithObjects:
                      [[UIBarButtonItem alloc]initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self action:@selector(prev:)],
                      [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(next:)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked)],
                           nil];
    [_toolBar sizeToFit];
    
    // add borders for buttons, iOS 7 fix - 5JAN14
    // use twitterbootstrap color scheme
    // www.javascripter.net/faq/hextorgb.htm
    
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
    
    [_contentView addSubview:_btnCreate];
    
    // add login button just above create button
    _welcomeLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_welcomeLogin addTarget:self action:@selector(processLogin:) forControlEvents:UIControlEventTouchUpInside];
    [_welcomeLogin setTitle:@"LOGIN" forState:UIControlStateNormal];
    [_welcomeLogin setTranslatesAutoresizingMaskIntoConstraints:NO];
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
    _textFieldPin.clearButtonMode = YES;
    _textFieldPin.keyboardType = UIKeyboardTypeNumberPad;
    _textFieldPin.inputAccessoryView = _toolBar;
    _textFieldPin.textColor = [UIColor colorWithRed:100.0f/255.0f
                                              green:83.0f/255.0f
                                               blue:0.0f/255.0f
                                              alpha:1.0f];
    
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
    // enable clear button for text fields
    _textFieldUsername.clearButtonMode=YES;
    _textFieldUsername.inputAccessoryView = _toolBar;
    // change textfield outline / border color
    _textFieldUsername.layer.borderColor = [UIColor whiteColor].CGColor;
    //    _textFieldUsername.layer.cornerRadius = 5;
    _textFieldUsername.layer.masksToBounds = true;
    // change color of txt for tfUserName / tfPin
    _textFieldUsername.textColor = [UIColor colorWithRed:100.0f/255.0f
                                                   green:83.0f/255.0f
                                                    blue:0.0f/255.0f
                                                   alpha:1.0f];
    
    [_contentView addSubview:_textFieldUsername];

    // currently, 15NOV15 - _btnForgot is NOT being used / displayed
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
    
    // hide forgot pin btn
    _btnForgot.hidden = TRUE;
    // end forgot btn
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
    
    // add constraints for _avatarScroll
    NSLayoutConstraint *pullAvatarScrollToBottom = [NSLayoutConstraint constraintWithItem:_avatarScroll attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-320.0];
    
    NSLayoutConstraint *pullAvatarScrollToRight = [NSLayoutConstraint constraintWithItem:_avatarScroll attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-35.0];
    
    NSLayoutConstraint *pullAvatarScrollToLeft = [NSLayoutConstraint constraintWithItem:_avatarScroll attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:35.0];
    
    [_avatarScroll addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_avatarScroll(==100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_avatarScroll)]];
    
    [_contentView addConstraints:@[pullAvatarScrollToBottom, pullAvatarScrollToRight, pullAvatarScrollToLeft]];
}

#pragma mark - Set Red Border Around TextField Username

- (void)setRedBorderAroundTextFieldUserName {
    
    _textFieldUsername.layer.borderColor = [[UIColor colorWithRed:255.0f/255.0f
                                                       green:0.0f/255.0f
                                                        blue:0.0f/255.0f
                                                       alpha:1.0f]CGColor];
    _textFieldUsername.layer.borderWidth = 2.0f;
}

#pragma mark - Set Red Border Around TextField Pin

- (void)setRedBorderAroundTextFieldPin {
    
    _textFieldPin.layer.borderColor = [[UIColor colorWithRed:255.0f/255.0f
                                                            green:0.0f/255.0f
                                                             blue:0.0f/255.0f
                                                            alpha:1.0f]CGColor];
    _textFieldPin.layer.borderWidth = 2.0f;
}

#pragma mark - Hide Red Border Around TextField Username

- (void)hideRedBorderAroundTextFieldUserName {
    _textFieldUsername.layer.borderWidth = 0.0f;
}

# pragma mark - Hide Red Border Around TextField Pin

- (void)hideRedBorderAroundTextFieldPin {
    _textFieldPin.layer.borderWidth = 0.0f;
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
    
    
    
    [self fetchLastFiveLogins];
}
# pragma mark - Fill Username from Avatar Button

-(void)fillUserName:(id) sender {
    
    UIButton *button = (UIButton *)sender;
#ifdef DEBUG
    NSLog(@"avatar btn tag = %ld",(long)button.tag);
#endif
    if (button.tag) {
        NSString *key = [NSString stringWithFormat:@"%li", (long)button.tag];
#ifdef DEBUG
        NSLog(@"key %@", key);
#endif
        _textFieldUsername.text = _avatarButtonDictionary[key];

    }
}

# pragma mark - Fetch Last Five Logins

- (void)fetchLastFiveLogins {
    
    // this method fetches the last 5 logged in users and displays their avatar on a button in the VCWelcome
    
    // need to access Core Data to retrieve the last five logins
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // define table / entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account"inManagedObjectContext:_managedObjectContext];
    [request setEntity:entity];

    [request setPropertiesToFetch:@[@"avatar",@"username",@"lastLogin"]];
    
    // sort / filter "results" to display the last five "lastLogin(s)"
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastLogin" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [request setFetchLimit:5];
    
    [request setSortDescriptors:sortDescriptors];
    
    //     fetch records and handle error
    NSError *error;
    _lastFiveLoginResults = [_managedObjectContext executeFetchRequest:request error:&error];
    
    if (!_lastFiveLoginResults) {
        // handle error
        // also if there is login data handle error so app doesn't crash
    }
    Account *anAccount;
    
    _avatarButtonDictionary = [[NSMutableDictionary alloc] init];
    
    // create a stock image
    UIImage *btnImage = [UIImage imageNamed:@"HomeBrewPoster1.jpg"];
    
    NSMutableArray *avatars = [NSMutableArray arrayWithCapacity:5];
    NSInteger tempTag = 1000;
    for ( anAccount in _lastFiveLoginResults) {
        if(anAccount.lastLogin) {
            [_avatarButtonDictionary setObject:anAccount.username forKey:[NSString stringWithFormat:@"%li", (long)tempTag]];
            if (anAccount.avatar != nil) {
                UIImage *avatarImg = [UIImage imageWithData:anAccount.avatar ];
                [avatars addObject:avatarImg];
            }
            else {
                [avatars addObject:btnImage];
            }
            tempTag++;
        }
    }
    for ( NSInteger i = 0; i < 4; i++) {
        // Check that we have enough logins
        if (i < _lastFiveLoginResults.count) {
//            NSLog(@"avatars =%@",avatars[i]);
            
            CGFloat staticX = 0;
            CGFloat staticWidth = 80;
            CGFloat staticHeight = 80;
            CGFloat staticPadding = 5;
            
            _avatarButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            
            // the last two values control the size of the button
            _avatarButton.frame = CGRectMake(0, 0, 80, 80);
            [_avatarButton setFrame:CGRectMake((staticX + (i * (staticHeight + staticPadding))),5,staticWidth,staticHeight)];
            
            // make corners round
            _avatarButton.layer.cornerRadius = 40; // value varies -- // 35 yields a pretty good circle.
            _avatarButton.clipsToBounds = YES;
            
            // set the button tag to the index of the array
            _avatarButton.tag = i+1000;
            
            // assign method / action to button
            [_avatarButton addTarget:self action:@selector(fillUserName:) forControlEvents:UIControlEventTouchDown];

            [_avatarButton setBackgroundImage:[avatars objectAtIndex:i] forState:UIControlStateNormal];
            
            [_avatarScroll addSubview:_avatarButton];
        }
    }
}

# pragma mark - View Did Appear

- (void)viewDidAppear:(BOOL)animated {
    [self fetchLastFiveLogins];
}

# pragma mark Add Item ViewController - _un

- (void)addItemViewController:(ViewControllerHome *)controller didFinishEnteringItem:(NSString *)_un {
#ifdef DEBUG
    NSLog(@"This was returned from ViewControllerB %@",_un);
#endif
    _un = _userNameString;
}

# pragma mark - Delegate Method - Add Avatar To View Controller Welcome

- (void)addAvatarToViewControllerWelcome:(ViewControllerHome *)controller didFinishSendingItem:(UIImage *)_avatar {
    
    _avatar = _avatarImage;
}

- (void)sendUserNameToWelcomeVC:(NSString *)_un {
    
}

#pragma mark - Status bar method
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#pragma mark - text field delegate methods

#pragma mark - textFieldDidBeginEditing
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self animateTextField:textField up:YES withOffset:textField.frame.origin.y / 2];
    [self hideRedBorderAroundTextFieldUserName];
    [self hideRedBorderAroundTextFieldPin];
}
#pragma mark - textFieldDidEndEditing
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [_textFieldUsername resignFirstResponder];
    [_textFieldPin resignFirstResponder];
    [self animateTextField:textField up:NO withOffset:textField.frame.origin.y / 2];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_textFieldUsername resignFirstResponder];
    [_textFieldPin resignFirstResponder];
    [textField resignFirstResponder];
    return true;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

#pragma mark - Animate TextField

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


#pragma mark - Process Login

- (IBAction)processLogin:(id)sender {
    
    // hide keyboard
    [_textFieldUsername resignFirstResponder];
    [_textFieldPin resignFirstResponder];
    
    // check if username and pin text fields are populated
    if ([_textFieldUsername.text length ] == 0 &&  [_textFieldPin.text length ] == 0)
    {
        // add red borders to tfUN / tfPin
        [self setRedBorderAroundTextFieldUserName];
        [self setRedBorderAroundTextFieldUserName];
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
            [self authenticate:anAccount];
            
            NSError *error = nil;
            if (![_managedObjectContext save:&error]) {
#ifdef DEBUG
                    NSLog(@"error %@", error);
#endif
            }
        }
    }
    if(results == nil || [results count] == 0) {
#ifdef DEBUG
        NSLog(@"username invalid");
#endif
        [self setRedBorderAroundTextFieldUserName];
    }
} // end of method

- (void)authenticate:(Account *) anAccount {
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
        
        [self saveLastLoginTime:anAccount]; // save anAccount.lastLogin attribute to Core Data DB
    
        // Load ViewController(Root)Home
        if([anAccount.username isEqualToString:@"root"]) {
            UIStoryboard *storyboardLocal = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
            ViewControllerRootHome *rootHome = [storyboardLocal instantiateViewControllerWithIdentifier:@"rootHome"];
            [self presentViewController:rootHome animated:YES completion:nil];
            
            // clear out / blank tfusername and tfpin
            _textFieldUsername.text = @"";
            _textFieldPin.text = @"";
        }
    
        else {
            UIStoryboard *storyboardLocal = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
            ViewControllerHome *home = [storyboardLocal instantiateViewControllerWithIdentifier:@"Home"];
            // pass username text to home screen
            home.un = _textFieldUsername.text;
            [self presentViewController:home animated:YES completion:nil];
            
            // clear out / blank tfusername and tfpin
            _textFieldUsername.text = @"";
            _textFieldPin.text = @"";
        }
    }
    else {
        [self setRedBorderAroundTextFieldPin];
    }
}

- (void)saveLastLoginTime:(Account *) anAccount {
    // get current time
    NSString *timestamp = TimeStamp;
#ifdef DEBUG
    NSLog(@"current time = %@",timestamp); // ex. 1427178876698.blah
#endif
    _loginTime = [[NSDate alloc] init];
    
    // adjust timezone
    NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:_loginTime];
    NSDate *localDate = [_loginTime dateByAddingTimeInterval:timeZoneOffset];
    
    anAccount.lastLogin = localDate;
#ifdef DEBUG
    NSLog(@"login time = %@",anAccount.lastLogin);
#endif
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

}
#pragma mark - View Will Disappear
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

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