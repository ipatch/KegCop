//
//  ViewControllerRootHome.m
//  KegCop
//
//  Created by capin on 6/26/12.
//

#import "ViewControllerRootHome.h"

@interface ViewControllerRootHome ()

@end

@implementation ViewControllerRootHome

@synthesize rootHomeScroller = _rootHomeScroller;
@synthesize tfDeleteAccount = _tfDeleteAccount;
@synthesize btnDeleteAccount = _btnDeleteAccount;
@synthesize btnDisplayAccount = _btnDisplayAccount;
@synthesize btnDisplayEmail = _btnDisplayEmail;
@synthesize tvDisplayAccount = _tvDisplayAccount;

@synthesize switchRfid = _switchRfid;
@synthesize tfCreditUsername = _tfCreditUsername;
@synthesize tfCredit = _tfCredit;
@synthesize btnAddCredit = _btnAddCredit;
@synthesize lblCredit = _lblCredit;
@synthesize lblRootCredit = _lblRootCredit;
@synthesize btnLogout = _btnLogout;
@synthesize btnCheckFlow = _btnCheckFlow;
@synthesize btnSerialConsole = _btnSerialConsole;
@synthesize btnLogs = _btnLogs;
@synthesize btndev = _btndev;

//tabbar crap
@synthesize tbRoot = _tbRoot;
@synthesize tbiUsers = _tbiUsers;
@synthesize tbiMisc = _tbiMisc;
@synthesize tbiDev = _tbiDev;


// added for debugging purposes - program crash when removed :/
@synthesize lblArduinoGood = _lblArduinoGood;
@synthesize lblArduinoBad = _lblArduinoBad;

// added dev3 btn for CoreBluetooth testing.
@synthesize btnDev4 = _btnDev4;


// Core Data
@synthesize managedObjectContext = _managedObjectContext;

// it is no longer necessary to synthesize properties in the .m file,
// Xcode / Obj-C auto synthesizes properties with the "_" i.e.,
// _mybutton



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // load Home Scrollview
    [_rootHomeScroller setContentSize:CGSizeMake(320,1000)];
    
    
    
    // hide Arduino connection labels
    [_lblArduinoGood setHidden:TRUE];
    [_lblArduinoBad setHidden:TRUE];
    
  
    
    // Core Data
    if (_managedObjectContext == nil)
    {
        _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSLog(@"After _managedObjectContext: %@",  _managedObjectContext);
    }
    
    // text view stuff
    [_tvDisplayAccount setScrollEnabled:TRUE];
    [_tvDisplayAccount setUserInteractionEnabled:YES];
    
    // declare nuke button
    nuke = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    // set title for button
    [nuke setTitle:@"Nuke DB" forState:UIControlStateNormal];
    
    // set position (X, Y, bsizeW, bsizeH)
    nuke.frame = CGRectMake(100, 460, 150, 30);
    
    // listen for clicks
    [nuke addTarget:self action:@selector(deleteAllObjects)forControlEvents:UIControlEventTouchUpInside];
    
    // add nuke to the scrollview
    [self.rootHomeScroller addSubview:nuke];
    
    // Core Data - load root credits
    [self rootCreditAmount];
    
    
    // declare / initialize tfEmail
    tfEmail = [[UITextField alloc] initWithFrame:CGRectMake(10, 500, 250, 30)];
    
    tfEmail.borderStyle = UITextBorderStyleRoundedRect;
    tfEmail.textColor = [UIColor blackColor];
    tfEmail.font = [UIFont systemFontOfSize:17.0];
    tfEmail.placeholder = @"Enter Master Paypal Address.";
    tfEmail.backgroundColor = [UIColor whiteColor];
    tfEmail.autocorrectionType = UITextAutocorrectionTypeNo;
    tfEmail.keyboardType = UIKeyboardTypeDefault;
    tfEmail.returnKeyType = UIReturnKeyDone;
    
    [self.rootHomeScroller addSubview:tfEmail];
         
    // declare / initialize btnEmailSave
    btnEmailSave = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [btnEmailSave setTitle:@"SaveMasterEmail" forState:UIControlStateNormal];
    
    btnEmailSave.frame = CGRectMake(100, 550, 150, 30);
    
    [btnEmailSave addTarget:self action:@selector(saveMasterEmail)forControlEvents:UIControlEventTouchUpInside];
    
    [self.rootHomeScroller addSubview:btnEmailSave];
    
    
    // RFID switch
    UISwitch *switchRfid = [[UISwitch alloc] initWithFrame: CGRectMake(20, 550, 50, 50)];
    [switchRfid addTarget: self action: @selector(rfidOnOff) forControlEvents:UIControlEventValueChanged];
    // add switch to the desired frame
    [self.rootHomeScroller addSubview:switchRfid];
    
    [self rootCreditAmount];
    
    //tabbar crap
    //[self.tbRoot setItems: _tbiUsers animated:TRUE];
    self.tbRoot.delegate = self;
    _tbiUsers.tag = 0;
    _tbiMisc.tag = 1;
    _tbiDev.tag = 2;
    
    
    // navBar crap
    _navBar = [[UINavigationBar alloc] init];
    [_navBar setFrame:CGRectMake(0,0,CGRectGetWidth(self.view.frame),80)];
    
    // add barButtonItem to navBar
    
//    UIBarButtonItem *menu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hamburger-menu-42x.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
//
    
//    UIImage *image = [UIImage imageNamed:@"hamburger-menu-42x.png"];
//    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [menuBtn setImage:image forState:UIControlStateNormal];
//    [menuBtn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *menu = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    
    
    
//    self.navigationItem.leftBarButtonItem = menu;
    
    // the below code adds a btn to the _navBar
    
//    UIBarButtonItem *menu = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(showMenu:)];
    
    UIBarButtonItem *hamMenu = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"hamburger-menu-42x.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(showMenu:)];
    
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"KegCop - Admin"];
    
//    navItem.leftBarButtonItem = menu;
    navItem.hidesBackButton = YES;
    navItem.leftBarButtonItem = hamMenu;
    
    
//    [_navBar setTintColor:[UIColor whiteColor]];
//    [_navBar setBackgroundColor:[UIColor blackColor]];
    [_navBar setBarTintColor:[UIColor blackColor]];
    [_navBar setTranslucent:YES];
//    [_navBar pushNavigationItem:navItem animated:NO];
    
    // set navItem "KegCop - Admin" text to white
    _navBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    
    _navBar.items = @[navItem];
//    [_navBar setItems:[NSArray arrayWithObjects:menu, nil]];
    
    
//    self.navigationItem.leftBarButtonItem = menu;
    
    
    [self.view addSubview:_navBar];

}

//- (IBAction)showMenu:(id)sender {
- (IBAction)showMenu:(id)sender {
    NSLog(@"yay \\o/");
}

- (void)viewDidUnload
{
    [self setTfDeleteAccount:nil];
    [self setBtnDeleteAccount:nil];
    [self setBtnDisplayAccount:nil];
    [self setTvDisplayAccount:nil];
    [self setBtnDisplayEmail:nil];
    [self setTfCreditUsername:nil];
    [self setTfCredit:nil];
    [self setBtnAddCredit:nil];
    [self setBtnLogout:nil];
    [self setBtnLogout:nil];
    [self setLblCredit:nil];
    [self setLblRootCredit:nil];
    //[self setBtnLogs:nil];
    [self setBtnLogs:nil];
    [self setBtnCheckFlow:nil];
    [self setBtnSerialConsole:nil];
    [self setBtndev:nil];
    
    
    // added for debugging purposes
    
    [self setLblArduinoGood:nil];
    [self setLblArduinoBad:nil];
    
    
    [self setBtnFlowIndicator:nil];
    //[self setShowFlowIndicator:nil];
    [self setTbiUsers:nil];
    [self setTbiUsers:nil];
    [self setTbRoot:nil];
    [self setTbiMisc:nil];
    [self setTbiDev:nil];
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)displayAccount:(id)sender {

    // CORE DATA
    // setup up the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // define our table / entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:_managedObjectContext];
    [request setEntity:entity];
    
    // define how records are sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"username" ascending:NO];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    [request setSortDescriptors:sortDescriptors];
    
    // Fetch the records and handle an error
    NSError *error;
    NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:& error] mutableCopy];
    
    if (!mutableFetchResults) {
        // handle error.
        // should advise user to restart
    }
    
    NSMutableString *string = [NSMutableString string];
    for ( Account *anAccount in mutableFetchResults) {
        [string appendString:[NSString stringWithFormat:@"%@\n",anAccount.username]];
    }
    
    // print results in text view
    _tvDisplayAccount.text = string;    
}

- (IBAction)displayEmail:(id)sender {
    
    // CORE DATA
    // setup up the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // define our table / entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:_managedObjectContext];
    [request setEntity:entity];
    
    // define how records are sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"email" ascending:NO];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    [request setSortDescriptors:sortDescriptors];
    
    // Fetch the records and handle an error
    NSError *error;
    NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:& error] mutableCopy];
    
    if (!mutableFetchResults) {
        // handle error.
        // should advise user to restart
    }
    
    NSMutableString *string = [NSMutableString string];
    for ( Account *anAccount in mutableFetchResults) {
        [string appendString:[NSString stringWithFormat:@"%@\n",anAccount.email]];
    }
    
    // print results in text view
    _tvDisplayAccount.text = string;
    
    
}

- (IBAction)deleteAccount:(id)sender {
        
    // TODO - implement method / code to delete a user account
    
    // CORE DATA
    // setup up the fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // define our table / entity to use
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:_managedObjectContext];
    [request setEntity:entity];
    
    // Fetch the records and handle an error
    NSError *error;
    NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:& error] mutableCopy];
    
    if (!mutableFetchResults) {
        // handle error.
        // should advise user to restart
    }
    
    // compare text field text / string with results in an array
    for (Account *anAccount in mutableFetchResults) {
        if([anAccount.username isEqualToString:self.tfDeleteAccount.text]) {
            NSLog(@"username found.");
            
            // delete keychain for account
            [anAccount prepareForDeletion];
            
            // delete account object
            [_managedObjectContext deleteObject:anAccount];
            
            // save the managed object context
            [_managedObjectContext save:&error];
           
        }
    }
}

- (IBAction)dismissKeyboard:(id)sender {
    
    [_tfDeleteAccount resignFirstResponder];
    [tfEmail resignFirstResponder];
    [_tfCreditUsername resignFirstResponder];
    [_tfCredit resignFirstResponder];
}


- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *managedObject in items) {
        [_managedObjectContext deleteObject:managedObject];
        NSLog(@"%@ object deleted",entityDescription);
    }
    if (![_managedObjectContext save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}

- (IBAction)saveMasterEmail {
 //- (IBAction)saveMasterEmail:(id)sender {
    
    NSLog(@"save master Email button pressed");
    
}
- (IBAction)rfidOnOff {
//- (IBAction)rfidToggle:(id)sender {
    NSLog(@"toogle");
}

- (IBAction)addCredit:(id)sender {
    
    NSLog(@"Add credit button pressed");
    
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
    for (Account *anAccount in mutableFetchResults) {
        if ([anAccount.username isEqualToString:self.tfCreditUsername.text]) {
            NSLog(@"username found.");
            
            // get value stored in credit tf
            int credit = [_tfCredit.text integerValue];
            
            // get current credit amount in DB
            int creditcurrent = [anAccount.credit intValue];
            
            // add tf with current credit
            int newcredit = credit + creditcurrent;
            NSLog(@"new credit amount = %i",newcredit);
            
            // save new value to anAccount.credit - convert int to NSNumber
            NSNumber *creditnew = [NSNumber numberWithInt:newcredit];
            anAccount.credit = creditnew;
            NSLog(@"new credit amoutn = %@",creditnew); 

            // save to DB
            NSError *error = nil;
            if (![_managedObjectContext save:&error]) {
                NSLog(@"error %@", error);
            }
            // update credit label
            _lblCredit.text = [NSString stringWithFormat:@"Credits added."];
        }
    }
}

- (IBAction)logout:(id)sender {
    NSLog(@"Logout button pressed");
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
//    ViewControllerWelcome *welcome = (ViewControllerWelcome *)[storyboard instantiateViewControllerWithIdentifier:@"Welcome"];
//    [self presentModalViewController:welcome animated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)checkFlow:(id)sender {
    
    // btnCheckFlow pressed
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    ViewControllerCheckFlow *checkFlow = (ViewControllerCheckFlow *)[storyboard instantiateViewControllerWithIdentifier:@"Check Flow"];
    [self presentViewController:checkFlow animated:YES completion:nil];
}

- (IBAction)showSerialConsole:(id)sender {
    
    NSLog(@"Serial Pressed Begin");
    //btnSerialConsole pressed
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    ViewControllerSerialConsole *serialConsole = (ViewControllerSerialConsole *) [storyboard instantiateViewControllerWithIdentifier:@"Serial Console"];
    [self presentViewController:serialConsole animated:YES completion:nil];
    NSLog(@"Serial Pressed End");
}

- (IBAction)showLogs:(id)sender {
    
    // logs btn pressed
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    ViewControllerLogs *logs = (ViewControllerLogs *)[storyboard instantiateViewControllerWithIdentifier:@"Logs"];
    [self presentViewController:logs animated:YES completion:nil];
    

}



- (void)rootCreditAmount {
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
    
    // refine to just root account
    for (Account *anAccount in mutableFetchResults) {
        if ([anAccount.username isEqualToString:@"root"]) {
                        
            NSLog(@"root credit = %@",anAccount.credit);
            
            _lblRootCredit.text = [NSString stringWithFormat:@"root has %@ credits.",anAccount.credit];
        }
    }
}

- (IBAction)showDev:(id)sender {
    
    NSLog(@"dev button pressed");
    //dev button pressed
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//    ViewControllerDev *dev = (ViewControllerDev *) [storyboard instantiateViewControllerWithIdentifier:@"dev"];
//    [self presentModalViewController:dev animated:YES];
    
    UIViewController *dev = [self.storyboard instantiateViewControllerWithIdentifier:@"dev"];
    [self presentViewController:dev animated:YES completion:nil];
    
    
    NSLog(@"dev button press End");
}

- (IBAction)showDev4:(id)sender {
    
    UIViewController *dev4 = [self.storyboard instantiateViewControllerWithIdentifier:@"dev4"];
    [self presentViewController:dev4 animated:YES completion:nil];
}

- (IBAction)showFlowIndicator:(id)sender {
    
    NSLog(@"flow indicator btn pressed");
    
    UIViewController *flow = [self.storyboard instantiateViewControllerWithIdentifier:@"KBFlowIndicator"];
    [self presentViewController:flow animated:YES completion:nil];
    
    
}


// tabbar crap
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    // item is the selected tab item
    if (item.tag==0) {
        UIViewController *users = [self.storyboard instantiateViewControllerWithIdentifier:@"users"];
        [self presentViewController:users animated:YES completion:nil];
    }
    
    if (item.tag==1) {
        
        NSLog(@"misc btn tapped");
        UIViewController *mapview = [self.storyboard instantiateViewControllerWithIdentifier:@"mapView"];
        [self presentViewController:mapview animated:YES completion:nil];
    }
    
    
    if (item.tag==2) {
        NSLog(@"dev btn tapped");
        UIViewController *dev3 = [self.storyboard instantiateViewControllerWithIdentifier:@"dev3"];
        [self presentViewController:dev3 animated:YES completion:nil];
    }
}


// added for debugging purposes - program was crashing when following method / action was removed :/


- (IBAction)testArduinoConnection:(id)sender {
    
    
}



@end