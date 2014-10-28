//
//  ViewControllerHome.m
//  KegCop
//
//  Created by capin on 6/20/12.
//

#import "ViewControllerHome.h"
// Added 5AUG13
#import "ViewControllerCreate.h"
#import "math.h"



@interface ViewControllerHome ()

@end

@implementation ViewControllerHome

@synthesize homeScroller = _homeScroller;
@synthesize lblUSERNAME = _lblUSERNAME;
@synthesize creditX = _creditX;
@synthesize btndrinkbeer = _btndrinkbeer;
@synthesize tfUsername = _tfUsername;
@synthesize tfCredit = _tfCredit;
@synthesize btnTradeCredit = _btnTradeCredit;
@synthesize lblTradeCredit = _lblTradeCredit;
@synthesize btnAddRFID = _btnAddRFID;
@synthesize idleTimerTime = _idleTimerTime;
// Core Data
@synthesize managedObjectContext = _managedObjectContext;



- (void)viewDidLoad
{
    
     [super viewDidLoad];
    
    // Core Data
    if (_managedObjectContext == nil)
    {
        _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSLog(@"After _managedObjectContext: %@",  _managedObjectContext);
    }

    // load Home Scrollview
    [_homeScroller setContentSize:CGSizeMake(320,750)];
    
    // declare rmv button
    removeAccount = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    // set title for button
    [removeAccount setTitle:@"Delete Account" forState:UIControlStateNormal];
    
    // set the position of the button - CGRectMake (X, Y, bsize width, bsize height)
    removeAccount.frame = CGRectMake(100, 440, 150, 30);
    
    // listen for clicks
    [removeAccount addTarget:self action:@selector(removeAccount) forControlEvents:UIControlEventTouchUpInside];
    
    // add the button to the scrollview
    [self.homeScroller addSubview:removeAccount];
    
    // change USERNAME label
    [self changeUSERNAME];
    
    // update credit
    [self updateCredit];
    
   
    
    
    // serial stuff
    serial = [[JailbrokenSerial alloc] init];
    // print serial debugging messages
    serial.debug = true;
    serial.nonBlock = true;
    serial.receiver = self;
    rfidbadgenumber = [[NSMutableString alloc] initWithString:@""];
    
    // 2AUG13 - more serial stuff
    [serial open:B115200];
    if(serial.isOpened)
    {
        NSLog(@"Serial Port Opened");
    }
    else NSLog(@"Serial Port Closed");
    
    
    // uialertview init
    // declare an alert with text input
    alertrfid = [[UIAlertView alloc] initWithTitle:@"Scan RFID badge"
                                           message:@"Associate RFID badge with user account"
                                          delegate:self
                                 cancelButtonTitle:@"Dismiss"
                                 otherButtonTitles:@"Save", nil];
    
    
    // RFID stuff
    newrfidtagid = [[NSMutableString alloc] init];
    
    
    // 5AUG13
    NSLog(@"presenting view controller:%@",[self presentingViewController]);
    
    // 6AUG13 - idle time logout
    _idleTimerTime.text = @"60 secs til";
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
    
    
    
    // Core Bluetooth - added 6FEB14
    self.blunoManager = [DFBlunoManager sharedInstance];
    self.blunoManager.delegate = self;
    NSLog(@"view did load method called");
    [self.blunoManager scan];
    
}

- (void)viewDidUnload
{
    [self setHomeScroller:nil];
    [self setTfUsername:nil];
    [self setTfCredit:nil];
    [self setBtnTradeCredit:nil];
    [self setLblUSERNAME:nil];
    [self setCreditX:nil];
    [self setLblTradeCredit:nil];
    [self setBtndrinkbeer:nil];
    [self setBtnAddRFID:nil];
    [self setBtnLogout:nil];
    [self setIdleTimerTime:nil];
    [super viewDidUnload];
    [serial close];
  
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}



- (IBAction)removeAccount {
    NSLog(@"Button Pressed");
    
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
    NSLog(@"btnTradeCredit pressed.");
    
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
        if ([loggeduser.username isEqualToString:self.lblUSERNAME.text]) {
            
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
            NSLog(@"username found.");
            
            // get current credit amount in DB
            int creditcurrent = [anAccount.credit intValue];
            
            // add tf with current credit
            int newcredit = credit + creditcurrent;
            NSLog(@"new credit amount = %i",newcredit);
            
            // save new value to anAccount.credit - convert int to NSNumber
            NSNumber *creditnew = [NSNumber numberWithInt:newcredit];
            anAccount.credit = creditnew;
            NSLog(@"new credit amoutn = %@",creditnew);
            
                        // save results to DB
            NSError *error = nil;
            if (![_managedObjectContext save:&error]) {
                NSLog(@"error %@", error);
            }
            
            // update label credit trade label
            _lblTradeCredit.text = [NSString stringWithFormat:@"Credits sucessfully traded."];
        }
    }
}

- (IBAction)drinkBeer:(id)sender {
    NSLog(@"pour beer btn pressed");
    
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
        if ([loggeduser.username isEqualToString:self.lblUSERNAME.text]) {
            
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
        }
    }
    
    // save the Core Data context to disk - prevents force quit bug found on 29SEP13
    // save the managed object context / save to DB
    [_managedObjectContext save:&error];

    
    // stuff added 2AUG13
    NSLog(@"{open_valve} btn tapped.");
    
    NSString *command = @"{open_valve}\n";
    
    [serial write:command];
    
    // 6FEB14 - CoreBluetooth - write message to Arduino
    if (self.blunoDev.bReadyToWrite)
    {
        NSString *pourBeer = @"{open_valve}";
        NSData *data = [pourBeer dataUsingEncoding:NSUTF8StringEncoding];
        [self.blunoManager writeDataToDevice:data Device:self.blunoDev];
        NSLog(@"data written = %@",data);
    }

    
}

/* Begin addRFID - Serial Communication */

- (IBAction)addRFID:(id)sender {
    
    // btnAddRFID pressed
    
    NSLog(@"rfid badge # is %@",newrfidtagid);


    // set alert with a text input field
    [alertrfid setAlertViewStyle:UIAlertViewStylePlainTextInput];
    // set text field input to max character length of 10
    //[[alertrfid textFieldAtIndex:0].text substringWithRange:NSMakeRange(0,10)];
    
    [alertrfid show];
    
    // set the delegate for the UIAlertView textfield
    [alertrfid textFieldAtIndex:0].delegate = self;
    
    
    //open serial port
    
    [serial open:B2400];
    if(serial.isOpened) {
        NSLog(@"Serial Port Opened");
    }
    else NSLog(@"Serial Port Closed");
}

- (IBAction)logout:(id)sender {
    NSLog(@"logout method called");
    [serial close];
    
    // this condition is satisfied when a new user creates an account then logs out
    if([self.presentingViewController isKindOfClass:[ViewControllerCreate class]] ) {
        
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion: nil];
    }
    // this is normally called when a user logs in then logs out
    [self.blunoManager stop];
    
    [self.blunoManager disconnectToDevice:self.blunoDev];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    NSLog(@"code execution reached here");
}

- (IBAction)addAvatar:(id)sender {
    
    UIViewController *avatar = [self.storyboard instantiateViewControllerWithIdentifier:@"avatar"];
    [self presentViewController:avatar animated:YES completion:nil];
    
}


# pragma mark - JailbrokenSerialDelegate
- (void) JailbrokenSerialReceived:(char) ch {

//    NSLog(@"got it");
//
//    NSString *s = [NSString stringWithFormat:@"%c",ch];
//    NSLog(@"s = %@",s);
//
//    [newrfidtagid appendString:s];
//
//    NSLog(@"rfid char  = %@",newrfidtagid);
//    
//    if (newrfidtagid.length == 10)
//    {
//        NSLog(@"new tagid = %@",newrfidtagid);
//        [alertrfid textFieldAtIndex:0].text = newrfidtagid;
//    }
 }

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSLog(@"Range: %@", NSStringFromRange(range));
    return (textField.text.length - range.length + string.length <= 10);
}

// delegate method for UIAlertView - handles methods for button presses
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        NSLog(@"The cancel button was clicked");
        
        [serial close];
        
        [alertrfid dismissWithClickedButtonIndex:0 animated:YES];
        [newrfidtagid setString:@""];
        [alertrfid textFieldAtIndex:0].text = @"";
        
    }
    
    // do stuff for additonal buttons
    if (buttonIndex == 1) {
        
        NSLog(@"delegate method - save btn pressed");
        [self saveTagIDtoAccount];
    }
}

/* End addRFID - Serial Communication */

// method to change username label
- (void)changeUSERNAME {
    _lblUSERNAME.text = [ModelWelcome sharedModelWelcome].passedText;
}

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
        if ([anAccount.username isEqualToString:_lblUSERNAME.text]) {
            
            NSLog(@"%@ credit = %@",username,anAccount.credit);
            
            _creditX.text = [NSString stringWithFormat:@"%@",anAccount.credit];
        }
    }
}

-(void)saveTagIDtoAccount {
    
    NSLog(@"inside saveTagIDtoAccount method");
    
    // check validity of tagID
    if( [self tagIDCheck] == FALSE)
    {
    
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
            NSLog(@"_lblUSERNAME = %@",_lblUSERNAME.text);
            
            NSLog(@"%@ RFID tagID will = %@",_lblUSERNAME,newrfidtagid);
            
            // associate tagid to account
            [anAccount setValue:newrfidtagid forKey:@"rfid"];
        }
    }
    }
}

// method to check if account already has tagID, returns a TRUE / FALSE
-(BOOL)tagIDCheck {
    
     NSLog(@"inside tagIDCheck method");
    
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
        NSLog(@"alert tf text = %@",[alertrfid textFieldAtIndex:0].text);
        
        // let user know tagid already taken
        [alertrfid setMessage:@"RFID tag associated to other account."];
        return TRUE;
    }
        else {
            return FALSE;
        }
}

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

- (void)bleDidUpdateState:(BOOL)bleSupported
{
    if(bleSupported)
    {
        [self.blunoManager scan];
    }
}

- (void)didDiscoverDevice:(DFBlunoDevice *)dev
{
    [self.blunoManager connectToDevice:dev];
    NSLog(@"Connected to %@",dev);
    self.blunoDev = dev;
}

- (void)readyToCommunicate:(DFBlunoDevice *)dev
{
//    self.lbReady.text = @"Ready";
}

- (void)didDisconnectDevice:(DFBlunoDevice *)dev
{
//    self.lbReady.text = @"Not Ready!";
    [self.blunoManager scan];
}

- (void)didWriteData:(DFBlunoDevice *)dev
{
    
}

- (void)didReceiveData:(NSData *)data Device:(DFBlunoDevice *)dev
{
//    self.lbReceiveMsg.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end