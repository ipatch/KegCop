//
//  ViewControllerRootHome.m
//  KegCop
//
//  Created by capin on 6/26/12.
//

// this ViewController (ViewControllerRootHome) is equivalent of the MainViewController
// see www.raywenderlich.com/32054

#import "ViewControllerRootHome.h"
#import "ViewControllerRootHomeCenter.h"
#import "ViewControllerRootHomeLeftPanel.h"
#import <QuartzCore/QuartzCore.h>
#import "KCModalPickerView.h"

#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2

#define CORNER_RADIUS 4

#define SLIDE_TIMING .25
#define PANEL_WIDTH 60


@interface ViewControllerRootHome () <ViewControllerRootHomeCenterDelegate>

@property (nonatomic, strong) ViewControllerRootHomeCenter *viewControllerRootHomeCenter;
@property (nonatomic, strong) ViewControllerRootHomeLeftPanel *viewControllerRootHomeLeftPanel;
@property (nonatomic, assign) BOOL showingLeftPanel;

@property (nonatomic, assign) BOOL showPanel;

@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) UIPickerView *pickerView;

@end

@implementation ViewControllerRootHome {
    
}

// synthesize the delegate
@synthesize delegate; // synthesize ViewControllerRootHome delegate




#pragma mark - load VC Root Home
-(void)loadVCRH
{
    // Load your RootMenu view here! (Check the .m file for LeftPanel where I updated the method that calls this if you're wondering how it gets called).
    [self movePanelToOriginalPosition];
}

#pragma mark - View Will/Did Appear

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - View Will/Did Disappear

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (UIView *)getLeftView {
    // init view if it doesn't already exist
    if (_viewControllerRootHomeLeftPanel == nil) {
        
        // this is where you define the view for the left panel
        self.viewControllerRootHomeLeftPanel = [[ViewControllerRootHomeLeftPanel alloc] initWithNibName:@"LeftPanelViewController" bundle:nil];
        self.viewControllerRootHomeLeftPanel.view.tag = LEFT_PANEL_TAG;
        // self.viewControllerRootHomeLeftPanel.delegate = _viewControllerRootHomeCenter; WTF is this
        
        // add via Owatch
        [self.viewControllerRootHomeLeftPanel setMyDelegate:self];
        
        [self.view addSubview:self.viewControllerRootHomeLeftPanel.view];
        
        [self addChildViewController:_viewControllerRootHomeLeftPanel];
        [_viewControllerRootHomeLeftPanel didMoveToParentViewController:self];
        
        _viewControllerRootHomeLeftPanel.view.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    self.showingLeftPanel = YES;
    
    // set up view shadows
    [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = self.viewControllerRootHomeLeftPanel.view;
    return view;
    
}


-(void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset {
    
    if(value)
    {
        [_viewControllerRootHomeCenter.view.layer setCornerRadius:CORNER_RADIUS];
        [_viewControllerRootHomeCenter.view.layer setShadowColor:[UIColor blackColor].CGColor
         ];
        [_viewControllerRootHomeCenter.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
    else
    {
        [_viewControllerRootHomeCenter.view.layer setCornerRadius:0.0f];
        [_viewControllerRootHomeCenter.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}

#pragma mark -
#pragma mark Delegate Actions

-(void)movePanelRight {
    
    NSLog(@"inside movePanelRight method");
    
    UIView *childView = [self getLeftView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _viewControllerRootHomeCenter.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             _viewControllerRootHomeCenter.leftButton.tag = 0;
                             _viewControllerRootHomeCenter.hamMenu.tag = 0;
                         }
                     }];
}

-(void)movePanelToOriginalPosition {
//    [self.delegate movePanelToOriginalPosition:self];
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _viewControllerRootHomeCenter.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self resetMainView];
                         }
                     }];
}

-(void)resetMainView {
    // remove left and right views, and reset variables, if needed
    if (_viewControllerRootHomeLeftPanel != nil) {
        [self.viewControllerRootHomeLeftPanel.view removeFromSuperview];
        self.viewControllerRootHomeLeftPanel = nil;
        _viewControllerRootHomeCenter.leftButton.tag = 1;
        _viewControllerRootHomeCenter.hamMenu.tag = 1;
        self.showingLeftPanel = NO;
    }
    
    // NO RIGHT PANEL IMPLEMENTED
    
//    if (_rightPanelViewController != nil) {
//        [self.rightPanelViewController.view removeFromSuperview];
//        self.rightPanelViewController = nil;
//        _centerViewController.rightButton.tag = 1;
//        self.showingRightPanel = NO;
//    }
    // remove view shadows
    [self showCenterViewWithShadow:NO withOffset:0];
}

#pragma mark - Setup View

- (void)setupView {
    self.viewControllerRootHomeCenter = [[ViewControllerRootHomeCenter alloc] initWithNibName:@"CenterViewController" bundle:nil];
    self.viewControllerRootHomeCenter.view.tag = CENTER_TAG;
    self.viewControllerRootHomeCenter.delegate = self;
    
    [self.view addSubview:self.viewControllerRootHomeCenter.view];
    [self addChildViewController:_viewControllerRootHomeCenter];
    
    [_viewControllerRootHomeCenter didMoveToParentViewController:self];
    
}

#pragma mark - View Did Load/Unload

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
    
    // load Home Scrollview
//    [_rootHomeScroller setContentSize:CGSizeMake(320,1000)];
    
    
    
    // hide Arduino connection labels
//    [_lblArduinoGood setHidden:TRUE];
//    [_lblArduinoBad setHidden:TRUE];
    
  
    
    // Core Data
    if (_managedObjectContext == nil)
    {
        _managedObjectContext = [[AccountsDataModel sharedDataModel]mainContext];
        NSLog(@"After _managedObjectContext: %@",  _managedObjectContext);
    }
    
    // text view stuff
//    [_tvDisplayAccount setScrollEnabled:TRUE];
//    [_tvDisplayAccount setUserInteractionEnabled:YES];
    
    // declare nuke button
//    nuke = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    // set title for button
//    [nuke setTitle:@"Nuke DB" forState:UIControlStateNormal];
    
    // set position (X, Y, bsizeW, bsizeH)
//    nuke.frame = CGRectMake(100, 460, 150, 30);
    
    // listen for clicks
//    [nuke addTarget:self action:@selector(deleteAllObjects)forControlEvents:UIControlEventTouchUpInside];
    
    // add nuke to the scrollview
//    [self.rootHomeScroller addSubview:nuke];
    
    // Core Data - load root credits
    [self rootCreditAmount];
    
    
    // declare / initialize tfEmail
//    tfEmail = [[UITextField alloc] initWithFrame:CGRectMake(10, 500, 250, 30)];
//    
//    tfEmail.borderStyle = UITextBorderStyleRoundedRect;
//    tfEmail.textColor = [UIColor blackColor];
//    tfEmail.font = [UIFont systemFontOfSize:17.0];
//    tfEmail.placeholder = @"Enter Master Paypal Address.";
//    tfEmail.backgroundColor = [UIColor whiteColor];
//    tfEmail.autocorrectionType = UITextAutocorrectionTypeNo;
//    tfEmail.keyboardType = UIKeyboardTypeDefault;
//    tfEmail.returnKeyType = UIReturnKeyDone;
//    
//    [self.rootHomeScroller addSubview:tfEmail];
    
//    // declare / initialize btnEmailSave
//    btnEmailSave = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    
//    [btnEmailSave setTitle:@"SaveMasterEmail" forState:UIControlStateNormal];
//    
//    btnEmailSave.frame = CGRectMake(100, 550, 150, 30);
//    
//    [btnEmailSave addTarget:self action:@selector(saveMasterEmail)forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.rootHomeScroller addSubview:btnEmailSave];
    
    
//    // RFID switch
//    UISwitch *switchRfid = [[UISwitch alloc] initWithFrame: CGRectMake(20, 550, 50, 50)];
//    [switchRfid addTarget: self action: @selector(rfidOnOff) forControlEvents:UIControlEventValueChanged];
//    // add switch to the desired frame
//    [self.rootHomeScroller addSubview:switchRfid];
//    
//    [self rootCreditAmount];
    
//    //tabbar crap
//    //[self.tbRoot setItems: _tbiUsers animated:TRUE];
//    self.tbRoot.delegate = self;
//    _tbiUsers.tag = 0;
//    _tbiMisc.tag = 1;
//    _tbiDev.tag = 2;
    
    // load array items - TEMP ITEMS TO LOAD IN UIPICKERVIEW
    self.items = [NSArray arrayWithObjects:@"Red",@"Green",@"Blue", nil];
//    [self loadPickerView];
    
    
    

}

- (void)loadPickerView {
    // load picker
    KCModalPickerView *pickerView = [[KCModalPickerView alloc] initWithValues:self.items];
    [pickerView presentInView:self.view withBlock:^(BOOL madeChoice) {
        NSLog(@"Made choice? %d", madeChoice);
    }];
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