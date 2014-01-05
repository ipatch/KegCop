//
//  ViewControllerWelcome.m
//  KegCop
//
//  Created by capin on 6/3/12.
//


#import "ViewControllerWelcome.h"
#import "NSData+AES256.h"
#import <dispatch/dispatch.h> // Grand Central Dispatch
#import "AFNetworking.h" // added to test coacopods implementation
#import <QuartzCore/QuartzCore.h> // added to see if button outlines / borders would respond properly in iOS 7

// GCD doesn't require linking to any new frameworks! :)

@interface ViewControllerWelcome ()
{
// declare private methods here
    dispatch_queue_t scan_queue;
}
@end

@implementation ViewControllerWelcome

//
// Notes
//
// it's bad not to use the "= _" SO USE IT! (-.-)
// synthesize allocates room for the pointer (o.O)
// synthesize creates the setter and the getter
// use the "getter" whenever we want to talk to a UI element.
// all synthesize does is make the instance variable for the pointer
// think of the controller as a way your model is presented to the user
// "id" is a pointer to ANY type of object.
//
//

// Welcome screen
@synthesize welcomeScroller = _welcomeScroller;
@synthesize textFieldUsername = _textFieldUsername;
@synthesize textFieldPin = _textFieldPin;
@synthesize wrongUserPin = _wrongUserPin;
@synthesize welcomeLogin = _welcomeLogin;
@synthesize btnForgot = _btnForgot;
@synthesize btnCreate = _btnCreate;
@synthesize welcomeActivityIndicator = _welcomeActivityIndicator;
@synthesize welcomeAbout = _welcomeAbout;
@synthesize dev = _dev;

// Core Data
@synthesize managedObjectContext = _managedObjectContext;

// keyboard toolbar
@synthesize doneButton = _doneButton;

// end welcome

//
// ViewControllerWelcome Methods
//

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"execution reached here");
    
    
    // add borders for buttons, iOS 7 fix - 5JAN14
    _welcomeLogin.layer.borderWidth=1.0f;
    _welcomeLogin.layer.borderColor=[[UIColor greenColor] CGColor];
    
    
    _btnForgot.layer.borderWidth=1.0f;
    _btnForgot.layer.borderColor=[[UIColor redColor] CGColor];
    
    
    _btnCreate.layer.borderWidth=1.0f;
    _btnCreate.layer.borderColor=[[UIColor blueColor] CGColor];
    
    
    
    // load Welcome Scrollview
    [_welcomeScroller setContentSize:CGSizeMake(320,750)];
    
    // hidden at load
    [_wrongUserPin setHidden:YES];
    
    // enable clear button for text fields
    _textFieldUsername.clearButtonMode=YES;
    _textFieldPin.clearButtonMode = YES;
    
    
    // Core Data
    if (_managedObjectContext == nil)
    {
        _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSLog(@"After _managedObjectContext: %@",  _managedObjectContext);

    }    
    
    // dev button
    _dev.hidden=TRUE;
    
    NSLog(@"execution reached before scan_queue");
    // threading stuff - GCD
    scan_queue = dispatch_queue_create("com.chrisrjones.kegcop", NULL);
    NSLog(@"execution reached after scan_queue");
    
    // put blocks of code into curly braces to run on separate thread
    dispatch_async(scan_queue, ^{
        
        NSLog(@"execution reached before serial handShake");
//        [serial handShake];
        NSLog(@"execution reached after serial handShake");
    
    });
    
    NSLog(@"execution is at end of ViewDidLoad method");
    
    // RFID stuff
    scantagid = [[NSMutableString alloc] init];
}

- (void)viewDidUnload {
    [self setTextFieldUsername:nil];
    [self setTextFieldPin:nil];
    
    [self setWrongUserPin:nil];
    [self setWelcomeLogin:nil];
    [self setWelcomeActivityIndicator:nil];
    
    
    
    [self setWelcomeScroller:nil];
    [self setWelcomeAbout:nil];
    [self setDev:nil];
    [self setBtnForgot:nil];
    [self setBtnCreate:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    // close serial port
    [serial close];
}



-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {  
    return YES; 
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
 
    [textField setInputAccessoryView:toolBar];
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



- (IBAction)processLogin:(id)sender {
    
    // hide keyboard
    [_textFieldUsername resignFirstResponder];
    [_textFieldPin resignFirstResponder];

    
    // First - make activity indicator visible, then start animating, then turn of wrong user / pin label
    _welcomeActivityIndicator.hidden = FALSE;
    [_welcomeActivityIndicator startAnimating ];
    // delay execution of my block for X seconds.
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
    
    
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
    
    NSLog(@"The returned results are %@",results);
    
    
    // check text field against results stored in DB
    for (Account *anAccount in results) {
        if ([anAccount.username isEqualToString:_textFieldUsername.text]){
            NSLog(@"Your username exists");
            
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
            NSLog(@"DB pin = %@",secret);
            
            
            // password - decode base64 NSData
            NSData *cipher = [self base64DataFromString:secret];
            
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
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
                    ViewControllerRootHome *roothome = (ViewControllerRootHome *)[storyboard instantiateViewControllerWithIdentifier:@"rootHome"];
                    [self presentViewController:roothome animated:YES completion:nil];
                    
                    // clear out / blank tfusername and tfpin
                    _textFieldUsername.text = @"";
                    _textFieldPin.text = @"";
                    // stop activityIndicator from spinning once logged in
                    [_welcomeActivityIndicator stopAnimating];
                }
                else {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
                    ViewControllerHome *home = (ViewControllerHome *)[storyboard instantiateViewControllerWithIdentifier:@"Home"];
                    
                    // pass username text to home screen
                    username = _textFieldUsername.text;
                    
                    [self passValues];
                    
                    [self presentViewController:home animated:YES completion:nil];
                    
                    // clear out / blank tfusername and tfpin
                    _textFieldUsername.text = @"";
                    _textFieldPin.text = @"";
                    // stop activityIndicator from spinning once logged in
                    [_welcomeActivityIndicator stopAnimating];
                }
            }
            else {
                NSLog(@"Your pin is wrong");
                [_welcomeActivityIndicator stopAnimating];
                [_wrongUserPin setHidden:NO];
                }
            }
    
        else {
            NSLog(@"Your username was not found");
            [_welcomeActivityIndicator stopAnimating];
            [_wrongUserPin setHidden:NO];
            }
    }
    
   // }); // close curly brace for 2 second delay on login.
}

- (IBAction)showForgotScene:(id)sender {
    
    UIViewController *forgot = [self.storyboard instantiateViewControllerWithIdentifier:@"Forgot"];
    [self presentViewController:forgot animated:YES completion:nil];
}

- (IBAction)showCreateScene:(id)sender {
    
    // display a UIAlertView displaying legal disclaimer.
    alertlegal = [[UIAlertView alloc] initWithTitle:@"Terms of Service" message:@"By clicking agree you abide to the terms of this application.\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Agree", nil];
    
    // set the size of the UIAlertView
    //alertlegal.frame = CGRectMake(0, 200, 200, 200);
    
    // create UITextView containing disclaimer for UIAlertView
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 100, 260, 160)];
    
    // start x, start y, width, height
    
    [textView setText:@"This iOS application is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.\n\nBy creating an account on this system you are NOT PAYING FOR BEER!  YOU ARE MAKING A DONATION TO THE PERSON WHO IS RESPONSIBLE FOR THE ADMIN / ROOT ACCOUNT ON THE SYSTEM  THE PERSON WHO GOVERNS THE ROOT ACCOUNT ON THE SYSTEM IS NOT RESPONSIBLE FOR YOUR DRIINKING OR THE RESULTS FROM THE BEHAVIOR OF YOUR DRINKING.\n\nThat being said, PLEASE DRINK RESPONSIBLY, AND TRY TO HAVE SOME FUN.\n\nBy clicking the agree button seen below this text I am stating that I have read this disclaimer, and that I will agree to the terms posted in this disclaimer."];
    
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


// method keyboard behavior

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
   
    NSLog(@"method was loaded at startup");
    printf("the printf statement is read");
}

// method keyboard behavior

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// method keyboard behavior

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = self->toolBar.frame;
    frame.origin.y = self.view.frame.size.height - 260.0;
    self->toolBar.frame = frame;
    
    [UIView commitAnimations];
}

// method keyboard behavior

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect frame = self->toolBar.frame;
    frame.origin.y = self.view.frame.size.height;
    self->toolBar.frame = frame;
    
    [UIView commitAnimations];
}

// method keyboard behavior - next button

- (IBAction) next:(id)sender
{
    if([self.textFieldUsername isFirstResponder])[self.textFieldPin becomeFirstResponder];
    
    else if([self.textFieldPin isFirstResponder])[self.textFieldUsername becomeFirstResponder];
}

// method keyboard behavior - prev button

- (IBAction) prev:(id)sender
{
    if([self.textFieldUsername isFirstResponder])[self.textFieldPin becomeFirstResponder];
    
    else if([self.textFieldPin isFirstResponder])[self.textFieldUsername becomeFirstResponder];
}

- (IBAction)processDev:(id)sender {
    
    // dev btn pressed
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    ViewControllerDev *dev = (ViewControllerDev *)[storyboard instantiateViewControllerWithIdentifier:@"dev"];
    [self presentViewController:dev animated:YES completion:nil];
    
}

-(void) passValues {
    ModelWelcome *modelwelcome = [ModelWelcome sharedModelWelcome];
    modelwelcome.passedText = username;
}


- (NSData *)base64DataFromString: (NSString *)string
{
unsigned long ixtext, lentext;
unsigned char ch, inbuf[4], outbuf[3];
short i, ixinbuf;
Boolean flignore, flendtext = false;
const unsigned char *tempcstring;
NSMutableData *theData;

if (string == nil)
{
    return [NSData data];
}

ixtext = 0;

tempcstring = (const unsigned char *)[string UTF8String];

lentext = [string length];

theData = [NSMutableData dataWithCapacity: lentext];

ixinbuf = 0;

while (true)
{
    if (ixtext >= lentext)
    {
        break;
    }
    
    ch = tempcstring [ixtext++];
    
    flignore = false;
    
    if ((ch >= 'A') && (ch <= 'Z'))
    {
        ch = ch - 'A';
    }
    else if ((ch >= 'a') && (ch <= 'z'))
    {
        ch = ch - 'a' + 26;
    }
    else if ((ch >= '0') && (ch <= '9'))
    {
        ch = ch - '0' + 52;
    }
    else if (ch == '+')
    {
        ch = 62;
    }
    else if (ch == '=')
    {
        flendtext = true;
    }
    else if (ch == '/')
    {
        ch = 63;
    }
    else
    {
        flignore = true; 
    }
    
    if (!flignore)
    {
        short ctcharsinbuf = 3;
        Boolean flbreak = false;
        
        if (flendtext)
        {
            if (ixinbuf == 0)
            {
                break;
            }
            
            if ((ixinbuf == 1) || (ixinbuf == 2))
            {
                ctcharsinbuf = 1;
            }
            else
            {
                ctcharsinbuf = 2;
            }
            
            ixinbuf = 3;
            
            flbreak = true;
        }
        
        inbuf [ixinbuf++] = ch;
        
        if (ixinbuf == 4)
        {
            ixinbuf = 0;
            
            outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
            outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
            outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
            
            for (i = 0; i < ctcharsinbuf; i++)
            {
                [theData appendBytes: &outbuf[i] length: 1];
            }
        }
        
        if (flbreak)
        {
            break;
        }
    }
}

return theData;
}

-(void)onTick:(NSTimer *)timer {
    // do something
}



// create a method that spawns a new thread to listen for an RFID badge scan / swipe

-(void)checkTagID {
    
    //scan_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(scan_queue, ^ { });
}

-(void)waitForTagScan {
    
}

# pragma mark - JailbrokenSerialDelegate

- (void) JailbrokenSerialReceived:(char) ch {
    
    NSLog(@"inside JailbrokenSerialReceived method");
    
    NSString *s = [NSString stringWithFormat:@"%c",ch];
    
    NSLog(@"s = %@",s);
    
    [scantagid appendString:s];
    
    NSLog(@"scantagid = %@", scantagid);
}




//- (void) openSerial {
//    
//    // serial stuff
//    serial = [[JailbrokenSerial alloc] init];
//    serial.debug = true;
//    serial.nonBlock = true;
//    serial.receiver = self;
//    
//    // serial stuff contd...
//    [serial open:B2400];
//    if (serial.isOpened)
//    {
//        NSLog(@"Serial Port Opened");
//    }
//    else NSLog(@"Serial Port Closed");
//    
//}


@end
