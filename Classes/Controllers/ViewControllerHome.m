//
//  ViewControllerHome.m
//  KegCop
//
//  Created by capin on 6/20/12.
//

#import "ViewControllerHome.h"
#import "ViewControllerCreate.h"
#import "math.h"
#import "AccountsDataModel.h"
#import "ViewControllerAvatar4.h"
#import "Account.h"

@interface ViewControllerHome () {
}
@property (nonatomic, retain) UIScrollView *homeScroller;
@property (nonatomic, retain) UINavigationBar *navBar;
@property (nonatomic, retain) UIImage *avatar;
@property (nonatomic, retain) UILabel *lblUSERNAME;
@property (nonatomic, retain) NSString *credit;
@property (nonatomic, retain) UILabel *creditX;
@property (nonatomic, retain) UIButton *btndrinkbeer;
@property (nonatomic, retain) UIButton *btnLogout;
@end

@implementation ViewControllerHome { }
#pragma mark - Add UI Elements
-(void)addUIElements {
    _navBar = [[UINavigationBar alloc] init];
    [_navBar setFrame:CGRectMake(0,0,CGRectGetWidth(self.view.frame),60)];
    
    UINavigationItem *titleItem = [[UINavigationItem alloc] initWithTitle:@"Home"];
    
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
    
    // load Home Scrollview
    [_homeScroller setContentSize:CGSizeMake(320,750)];
    
    [self.view addSubview:_navBar];
    // end navBar
    
    // setup code to draw / display avatar
    UIView *avatarView = [[UIView alloc] init];
    avatarView.frame = CGRectMake(20, 60, 280, 100);
#ifdef DEBUG
    avatarView.layer.borderColor = [UIColor redColor].CGColor;
    avatarView.layer.borderWidth = 3.0f;
#endif
    [self.view addSubview:avatarView];
    
    // do additional loading for avatars
    UIButton *avatarButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // the last two values control the size of the button
    avatarButton.frame = CGRectMake(0, 0, 80, 80);
    // make corners round
    avatarButton.layer.cornerRadius = 40; // value varies -- // 35 yields a pretty good circle.
    avatarButton.clipsToBounds = YES;
    
    // setup lblUSERNAME
    _lblUSERNAME = [[UILabel alloc] init];
    _lblUSERNAME.textColor = [UIColor colorWithRed:255/255.0
                                               green:255/255.0
                                                blue:255/255.0
                                               alpha:1.0f];
    [_lblUSERNAME setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_lblUSERNAME];
    
    // setup label for displaying credits
    _creditX = [[UILabel alloc] init];
    _creditX.textColor = [UIColor colorWithRed:255/255.0
                                         green:255/255.0
                                          blue:255/255.0
                                         alpha:1.0f];
    [_creditX setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.view addSubview:_creditX];

    // setup pour beer button, btndrinkbeer - set colors
    _btndrinkbeer = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btndrinkbeer addTarget:self
                   action:@selector(drinkBeer:)
         forControlEvents:UIControlEventTouchUpInside];
    [_btndrinkbeer setTitle:@"POUR BEER"  forState:UIControlStateNormal ];
    [_btndrinkbeer setTranslatesAutoresizingMaskIntoConstraints:NO];
    _btndrinkbeer.layer.borderWidth=1.0f;
    _btndrinkbeer.layer.cornerRadius = 5.0f;
    // add roundness to btns
    _btndrinkbeer.layer.cornerRadius = 5;
    _btndrinkbeer.layer.borderWidth=1.0f;
    _btndrinkbeer.layer.borderColor=[[UIColor colorWithRed: 57.0f/255.0f
                                                     green: 132.0f/255.0f
                                                      blue: 57.0f/255.0f
                                                     alpha:1.0f] CGColor];
    [_btndrinkbeer setBackgroundColor:[UIColor colorWithRed:68.0f/255.0f
                                                      green:157.0f/255.0f
                                                       blue:68.0f/255.0f
                                                      alpha:1.0f]];
    // set btn font color
    [_btndrinkbeer setTitleColor:[UIColor colorWithRed:255/255.0
                                                 green:255/255.0
                                                  blue:255/255.0
                                                 alpha:1.0f] forState:UIControlStateNormal];
    [self.view addSubview:_btndrinkbeer];
    
    
    
    
    
    // hide capture avatar btn
    _captureAvatar.hidden = true;
    
    
    if (_avatar == nil) {
#ifdef DEBUG
        NSLog(@"couldn't find avatar");
#endif
    } else {
        [avatarButton setBackgroundImage:_avatar forState:UIControlStateNormal];
    }
    // add button to subview
    [avatarView addSubview:avatarButton];

    // 6AUG13 - idle time logout
    _idleTimerTime.text = @"60 secs til";
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
    self.idleTimerTime.textColor = [UIColor colorWithRed:255/255.0
                                                   green:255/255.0
                                                    blue:255/255.0
                                                   alpha:1.0f];

    // setup logout button, btnLogout - set colors
    _btnLogout = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_btnLogout addTarget:self
                      action:@selector(logout:)
            forControlEvents:UIControlEventTouchUpInside];
    [_btnLogout setTitle:@"LOGOUT"  forState:UIControlStateNormal ];
    [_btnLogout setTranslatesAutoresizingMaskIntoConstraints:NO];
    _btnLogout.layer.borderWidth=1.0f;
    _btnLogout.layer.cornerRadius = 5.0f;
//    _btnLogout.layer.cornerRadius = 5;
    _btnLogout.layer.borderColor=[[UIColor colorWithRed: 172/255.0f
                                                  green: 41/255.0f
                                                   blue: 37/255.0f
                                                  alpha:1.0f] CGColor];
    [_btnLogout setBackgroundColor:[UIColor colorWithRed:201.0f/255.0f
                                                   green:48.0f/255.0f
                                                    blue:44.0f/255.0f
                                                   alpha:1.0f]];
    
    [_btnLogout setTitleColor:[UIColor colorWithRed:255/255.0
                                              green:255/255.0
                                               blue:255/255.0
                                              alpha:1.0f] forState:UIControlStateNormal];
    [self.view addSubview:_btnLogout];
}
#pragma mark - Add UI Element Constraints
-(void)addUIElementConstraints {
    
    // setup lblUSERNAME constraints
    NSLayoutConstraint *pulllblUserNameToTop = [NSLayoutConstraint constraintWithItem:_lblUSERNAME attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_lblUSERNAME.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:180.0];
    
    NSLayoutConstraint *pulllblUserNameToLeft = [NSLayoutConstraint constraintWithItem:_lblUSERNAME attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_lblUSERNAME.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15.0];
    
    [_lblUSERNAME.superview addConstraints:@[pulllblUserNameToTop, pulllblUserNameToLeft]];
    
    
    // setup pour beer button constraints
    NSLayoutConstraint *pullPourBeerToTop = [NSLayoutConstraint constraintWithItem:_btndrinkbeer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_btndrinkbeer.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:220.0];
    
    NSLayoutConstraint *pullPourBeerToRight = [NSLayoutConstraint constraintWithItem:_btndrinkbeer attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_btndrinkbeer.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:-15.0];
    
    NSLayoutConstraint *pullPourBeerToLeft = [NSLayoutConstraint constraintWithItem:_btndrinkbeer attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_btndrinkbeer.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15.0];
    
    [_btndrinkbeer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_btndrinkbeer(==60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_btndrinkbeer)]];
    
    [_btndrinkbeer.superview addConstraints:@[pullPourBeerToTop, pullPourBeerToRight, pullPourBeerToLeft]];

    // setup logout button constraints
    NSLayoutConstraint *pullLogOutToBottom = [NSLayoutConstraint constraintWithItem:_btnLogout attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_btnLogout.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-15.0];
    
    NSLayoutConstraint *pullLogOutToRight = [NSLayoutConstraint constraintWithItem:_btnLogout attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_btnLogout.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:-15.0];
    
    NSLayoutConstraint *pullLogOutToLeft = [NSLayoutConstraint constraintWithItem:_btnLogout attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_btnLogout.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15.0];
    
    [_btnLogout addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_btnLogout(==60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_btnLogout)]];
    
    [_btnLogout.superview addConstraints:@[pullLogOutToBottom, pullLogOutToRight, pullLogOutToLeft]];
    
    
}
#pragma mark - View Did Load
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_managedObjectContext == nil) {
        _managedObjectContext = [[AccountsDataModel sharedDataModel] mainContext];
#ifdef DEBUG
        NSLog(@"After _managedObjectContext: %@",  _managedObjectContext);
#endif
    }
//    _un = [NSString stringWithFormat:[self.delegate receiveUserName]];
    
    
    [self addUIElements];
    [self addUIElementConstraints];
    // update credit
    [self updateCredit];
//    _credit = [NSString stringWithFormat:@"%@",_creditX.text];
    
    // change USERNAME label
    [_lblUSERNAME setText:[NSString stringWithFormat:@"%@ you have %@ credits.",_un,_credit]];

    // Core Bluetooth - added 6FEB14
    self.blunoManager = [DFBlunoManager sharedInstance];
    self.blunoManager.delegate = self;
    [self.blunoManager scan];
    
    
    
//    // retrieve image from Core Data and place on UIButton
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    
//    // define table / entity to use
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account"inManagedObjectContext:_managedObjectContext];
//    [request setEntity:entity];
////    [request setResultType:NSDictionaryResultType];
//    [request setReturnsDistinctResults:YES];
//    [request setPropertiesToFetch:@[@"avatar",@"username"]];
    
    // fetch records and handle error
//    NSError *error;
//    NSArray *results = [_managedObjectContext executeFetchRequest:request error:&error];
//    
//    if (!results) {
//        // handle error
//    }
//    NSLog(@"results = %@",results);
//    // find specific value in array
    
    // convert UILabel.text to NSString for searching
    
//    for (Account *anAccount in results) {
//        if ([anAccount.username isEqualToString:search]) {
//            NSLog(@"username found.");
//            _avatar = [[UIImage alloc] initWithData:anAccount.avatar];
//            NSLog(@"avatar = %@",_avatar);
//        }
//    }
}

- (IBAction)removeAccount {
#ifdef DEBUG
    NSLog(@"Button Pressed");
#endif
    
    // TODO present alertview to confirm deletion of account
    alert = [[UIAlertView alloc]initWithTitle:@"Do you really want to delete this account?" message:@"This can not be undone!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];    
    // display the alert    
    [alert show];
    
    // TODO data needs to be fetched from CORE DATA
    
    // TODO delete username & all related information from Core Data DB
    
    // TODO delete username
    
    // TODO delete keychain asosciated user account - dele pin & repin
    
    // TODO delete email address
    
    // TODO dele phone number
    
}

- (IBAction)dismissKeyboard:(id)sender {
    [_tfUsername resignFirstResponder];
    [_tfCredit resignFirstResponder];
}

- (IBAction)tradeCredit:(id)sender {
#ifdef DEBUG
    NSLog(@"btnTradeCredit pressed.");
#endif
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // define table / entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:_managedObjectContext];
    [request setEntity:entity];
    
    // fetch records and handle error
    NSError *error;
    NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (!mutableFetchResults) {
        // handle error
    }
    
    // TRADE CREDITS
    
    // get value stored in credit tf
    int credit = [_tfCredit.text integerValue];
    
    // SUBTRACT - GLOBAL - subtract credit from logged in user
    for (Account *loggeduser in mutableFetchResults) {
        if ([loggeduser.username isEqualToString:_lblUSERNAME.text]) {
            
            // get current credit of logged in user
            int loggedusercurrentcredit = [loggeduser.credit intValue];
            if (loggedusercurrentcredit <= 0) {
                // update credit trade label
                _lblTradeCredit.text = [NSString stringWithFormat:@"Not enough tradable credits."];
                return;
            }
            
            // subtract current credit DB from text field
            if (credit > loggedusercurrentcredit) {
                _lblTradeCredit.text = [NSString stringWithFormat:@"Can't trade more credits than you have."];
                return;
            }
            int loggedusernewcredit = loggedusercurrentcredit - credit;
            
            
            // save new value in DB to loggeduser
            NSNumber *loggedusercreditnew = [NSNumber numberWithInt:loggedusernewcredit];
            loggeduser.credit = loggedusercreditnew;
            
            // update creditX label
            _creditX.text = [NSString stringWithFormat:@"%@",loggeduser.credit];
        }
    }
    // ADD - GLOBAL
    for (Account *anAccount in mutableFetchResults) {
        if ([anAccount.username isEqualToString:self.tfUsername.text]) {
#ifdef DEBUG
            NSLog(@"username found.");
#endif
            
            // get current credit amount in DB
            int creditcurrent = [anAccount.credit intValue];
            
            // add tf with current credit
            int newcredit = credit + creditcurrent;
#ifdef DEBUG
            NSLog(@"new credit amount = %i",newcredit);
#endif
            // save new value to anAccount.credit - convert int to NSNumber
            NSNumber *creditnew = [NSNumber numberWithInt:newcredit];
            anAccount.credit = creditnew;
#ifdef DEBUG
            NSLog(@"new credit amoutn = %@",creditnew);
#endif
                        // save results to DB
            NSError *error = nil;
            if (![_managedObjectContext save:&error]) {
#ifdef DEBUG
                NSLog(@"error %@", error);
#endif
            }
            
            // update label credit trade label
            _lblTradeCredit.text = [NSString stringWithFormat:@"Credits sucessfully traded."];
        }
    }
}
#pragma mark - Drink Beer
- (IBAction)drinkBeer:(id)sender {
#ifdef DEBUG
    NSLog(@"pour beer btn pressed");
#endif
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // define table / entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:_managedObjectContext];
    [request setEntity:entity];
    
    // fetch records and handle error
    NSError *error;
    NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (!mutableFetchResults) {
        // handle error
    }
    
    int credit = 1;
    
    // SUBTRACT - GLOBAL - subtract credit from logged in user
    for (Account *loggeduser in mutableFetchResults) {
        if ([loggeduser.username isEqualToString:_un]) {
            
            // get current credit of logged in user
            int loggedusercurrentcredit = [loggeduser.credit intValue];
            if (loggedusercurrentcredit <= 0) {
                // update credit trade label
                _lblTradeCredit.text = [NSString stringWithFormat:@"Not enough credits to pour beer."];
                return;
            }
            
            // subtract current credit DB from text field
            int loggedusernewcredit = loggedusercurrentcredit - credit;
                        
            // save new value in DB to loggeduser
            NSNumber *loggedusercreditnew = [NSNumber numberWithInt:loggedusernewcredit];
            loggeduser.credit = loggedusercreditnew;
            
            // update creditX label
            _creditX.text = [NSString stringWithFormat:@"%@",loggeduser.credit];
            _credit = [NSString stringWithFormat:@"%@",loggeduser.credit];
        }
    }
    
    // save the Core Data context to disk - prevents force quit bug found on 29SEP13
    // save the managed object context / save to DB
    [_managedObjectContext save:&error];
#ifdef DEBUG
    NSLog(@"{open_valve} btn tapped.");
#endif
    
    // 6FEB14 - CoreBluetooth - write message to Arduino
    if (self.blunoDev.bReadyToWrite) {
        NSString *pourBeer = @"{open_valve}";
        NSData *data = [pourBeer dataUsingEncoding:NSUTF8StringEncoding];
        [self.blunoManager writeDataToDevice:data Device:self.blunoDev];
#ifdef DEBUG
        NSLog(@"data written = %@",data);
#endif
    }
    [self updateCredit];
}

/* 
 * Begin addRFID - Serial Communication
 */
#pragma mark - Add RFID
- (IBAction)addRFID:(id)sender {
    
    // btnAddRFID pressed
#ifdef DEBUG
    NSLog(@"rfid badge # is %@",newrfidtagid);
#endif

    // set alert with a text input field
    [alertrfid setAlertViewStyle:UIAlertViewStylePlainTextInput];
    // set text field input to max character length of 10
    //[[alertrfid textFieldAtIndex:0].text substringWithRange:NSMakeRange(0,10)];
    
    [alertrfid show];
    
    // set the delegate for the UIAlertView textfield
    [alertrfid textFieldAtIndex:0].delegate = self;
}
#pragma mark - Logout
- (IBAction)logout:(id)sender {
    // this condition is satisfied when a new user creates an account then logs out
    if([self.presentingViewController isKindOfClass:[ViewControllerCreate class]] ) {
        
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion: nil];
    }
    // this is normally called when a user logs in then logs out
    [self.blunoManager stop];
    
    [self.blunoManager disconnectToDevice:self.blunoDev];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}
# pragma mark - addAvatar
- (IBAction)addAvatar:(id)sender {
    ViewControllerAvatar4 *avatarVC = [[ViewControllerAvatar4 alloc] initWithNibName:@"avatar" bundle:nil];
    // set the delegate before launching vc
    avatarVC.delegate = self;
    [self presentViewController:avatarVC animated:YES completion:nil];
}
# pragma mark - delegate method - Give Me Data
- (NSDictionary *) giveMeData {
    NSMutableDictionary *dataToReturn = [[NSMutableDictionary alloc] init];
    
    // how to add lblUSERNAME(.text) to mutable dictionary ?
    [dataToReturn setObject:_lblUSERNAME.text  forKey:@"username"];
    
    return dataToReturn;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
#ifdef DEBUG
    NSLog(@"Range: %@", NSStringFromRange(range));
#endif
    return (textField.text.length - range.length + string.length <= 10);
}

/*
 * delegate method for UIAlertView - handles methods for button presses
 */
#pragma mark - UIAlertView delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
#ifdef DEBUG
        NSLog(@"The cancel button was clicked");
#endif
        
        [alertrfid dismissWithClickedButtonIndex:0 animated:YES];
        [newrfidtagid setString:@""];
        [alertrfid textFieldAtIndex:0].text = @"";
        
    }
    
    // do stuff for additonal buttons
    if (buttonIndex == 1) {
#ifdef DEBUG
        NSLog(@"delegate method - save btn pressed");
#endif
        [self saveTagIDtoAccount];
    }
}
#pragma mark - Update Credit
-(void)updateCredit {
    // Core Data - root credit amount
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // define our table / entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:_managedObjectContext];
    [request setEntity:entity];
    
    // fetch records and handle error
    NSError *error;
    NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (!mutableFetchResults) {
        // handle error.
        // should advise user to restart
    }
    
    // refine to just logged in user account
    for (Account *anAccount in mutableFetchResults) {
        // the below line is causing null credits
#ifdef DEBUG
        NSLog(@"_un = %@",_un);
#endif
        if ([anAccount.username isEqualToString:_un]) {
#ifdef DEBUG
            NSLog(@"%@ credit = %@",anAccount.username,anAccount.credit);
#endif
            _creditX.text = [NSString stringWithFormat:@"%@",anAccount.credit];
            _credit = [NSString stringWithFormat:@"%@",anAccount.credit];
            // change USERNAME label
            [_lblUSERNAME setText:[NSString stringWithFormat:@"%@ you have %@ credits.",_un,_credit]];
        }
    }
}
#pragma mark - RFID
-(void)saveTagIDtoAccount {
#ifdef DEBUG
    NSLog(@"inside saveTagIDtoAccount method");
#endif
    // check validity of tagID
    if( [self tagIDCheck] == FALSE) {
    // Core Data - query Core Data DB
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // define our table / entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:_managedObjectContext];
    [request setEntity:entity];
    
    // fetch records and handle error
    NSError *error;
    NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (!mutableFetchResults) {
        // handle error.
        // should advise user to restart
    }
    
    // refine to just logged in user account
    for (Account *anAccount in mutableFetchResults) {
        if ([anAccount.username isEqualToString:_lblUSERNAME.text]) {
            
            //log the text of _lblUSERNAME.text
#ifdef DEBUG
            NSLog(@"_lblUSERNAME = %@",_lblUSERNAME.text);
#endif
#ifdef DEBUG
            NSLog(@"%@ RFID tagID will = %@",_lblUSERNAME,newrfidtagid);
#endif
            // associate tagid to account
            [anAccount setValue:newrfidtagid forKey:@"rfid"];
        }
    }
    }
}

// method to check if account already has tagID, returns a TRUE / FALSE
#pragma mark - RFID - Tag ID Check
-(BOOL)tagIDCheck {
#ifdef DEBUG
     NSLog(@"inside tagIDCheck method");
#endif
    // check if account already has tagID
    
    // query Core Data DB to see if username is already created
    
    // define table/entity to use
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"Account" inManagedObjectContext:_managedObjectContext];
    
    // setup fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    // sort the records
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"rfid" ascending:NO];
    NSArray *records = [NSArray arrayWithObject:sort];
    
    [request setSortDescriptors:records];
    
    // fetch the records and handle an error
    NSError *fetchError;
    NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&fetchError] mutableCopy];
    
    if (!mutableFetchResults) {
        // handle error.
        // serious error
    }
    
    // compare tagid tf with fetched results
    if ([[mutableFetchResults valueForKey:@"rfid"] containsObject:[alertrfid textFieldAtIndex:0].text]) {
        
        // log
#ifdef DEBUG
        NSLog(@"alert tf text = %@",[alertrfid textFieldAtIndex:0].text);
#endif
        // let user know tagid already taken
        [alertrfid setMessage:@"RFID tag associated to other account."];
        return TRUE;
    }
        else {
            return FALSE;
        }
}
#pragma mark - RFID
-(void)hidebtnAddRFID {
    
    // check if account has RFID badge
    
}

#pragma mark - Handling idle timeout
-(void)countDown:(NSTimer *) idleTimer2 {
    _idleTimerTime.text = [NSString stringWithFormat:@"%d secs til",[_idleTimerTime.text intValue] -1];
    if([_idleTimerTime.text isEqualToString:@"0 secs til"]) {
        [idleTimer2 invalidate];
        [self logout:nil];
    }
}

// method is fired when user touches screen.
- (UIResponder *)nextResponder {
    _idleTimerTime.text = @"60 secs til";
    return [super nextResponder];
}

#pragma mark - DFBlunoDelegate
- (void)bleDidUpdateState:(BOOL)bleSupported {
    if(bleSupported) {
        [self.blunoManager scan];
    }
}

- (void)didDiscoverDevice:(DFBlunoDevice *)dev {
    [self.blunoManager connectToDevice:dev];
#ifdef DEBUG
    NSLog(@"Connected to %@",dev);
#endif
    self.blunoDev = dev;
}

- (void)readyToCommunicate:(DFBlunoDevice *)dev {
//    self.lbReady.text = @"Ready";
}

- (void)didDisconnectDevice:(DFBlunoDevice *)dev {
//    self.lbReady.text = @"Not Ready!";
    [self.blunoManager scan];
}

- (void)didWriteData:(DFBlunoDevice *)dev {
    
}

- (void)didReceiveData:(NSData *)data Device:(DFBlunoDevice *)dev {
}

# pragma mark - device orientation
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
@end