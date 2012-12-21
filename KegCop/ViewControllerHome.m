//
//  ViewControllerHome.m
//  KegCop
//
//  Created by capin on 6/20/12.
//

#import "ViewControllerHome.h"
// #import "ViewControllerWelcome.h"

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



// Core Data
@synthesize managedObjectContext = _managedObjectContext;

// @synthesize removeAccount = _removeAccount;

// Serial Port
// static NSInteger gFileDescriptor;

- (void)viewDidLoad
{
    // Core Data
    if (_managedObjectContext == nil)
    {
        _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSLog(@"After _managedObjectContext: %@",  _managedObjectContext);
    }

    // load Home Scrollview
    [_homeScroller setContentSize:CGSizeMake(320,750)];
    
    // declare button
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
    
    [super viewDidLoad];
    
    
    // serial stuff
    serial = [[JailbrokenSerial alloc] init];
    serial.debug = true;
    serial.nonBlock = true;
    serial.receiver = self;
    rfidbadgenumber = [[NSMutableString alloc] initWithString:@""];
    
    
    // uialertview init
    // declare an alert with text input
    alertrfid = [[UIAlertView alloc] initWithTitle:@"Scan RFID badge"
                                           message:@"Associate RFID badge with user account"
                                          delegate:self
                                 cancelButtonTitle:@"Dismiss"
                                 otherButtonTitles:@"Save", nil];
    
    
    // RFID stuff
    newrfidtagid = [[NSMutableString alloc] init];
    
    
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
    // welcome
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
    NSLog(@"yes btn pressed");
    
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
    if(serial.isOpened)
    {
        NSLog(@"Open");
    }
    else NSLog(@"closed dingo");
}


# pragma mark - JailbrokenSerialDelegate
- (void) JailbrokenSerialReceived:(char) ch {

    NSLog(@"got it");

    NSString *s = [NSString stringWithFormat:@"%c",ch];
    NSLog(@"s = %@",s);

    [newrfidtagid appendString:s];

    NSLog(@"rfid char  = %@",newrfidtagid);
    
    if (newrfidtagid.length == 10)
    {
        NSLog(@"new tagid = %@",newrfidtagid);
        [alertrfid textFieldAtIndex:0].text = newrfidtagid;
        //[serial open:B2400];
    }
 }

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSLog(@"Range: %@", NSStringFromRange(range));
    return (textField.text.length - range.length + string.length <= 10);
}

// add method for cancel button
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        NSLog(@"The cancel button was clicked");
        
        [serial close];
        
        [alertrfid dismissWithClickedButtonIndex:0 animated:YES];
        [newrfidtagid setString:@""];
        [alertrfid textFieldAtIndex:0].text = @"";
         
        //alertrfid.hidden = TRUE;
        
    }
    
    // do stuff for additonal buttons
}

// close serial port


/* End addRFID - Serial Communication */

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

-(void)hidebtnAddRFID {
    
    // check if account has RFID badge
    
}


@end