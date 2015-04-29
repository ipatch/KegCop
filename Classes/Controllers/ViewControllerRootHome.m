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

//@property (nonatomic, strong) ViewControllerRootHomeCenter *viewControllerRootHomeCenter;
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
#ifdef DEBUG
    NSLog(@"inside movePanelRight method");
#endif
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
#ifdef DEBUG
        NSLog(@"After _managedObjectContext: %@",  _managedObjectContext);
#endif
    }
    
    [self rootCreditAmount];
    
    // load array items - TEMP ITEMS TO LOAD IN UIPICKERVIEW
    self.items = [NSArray arrayWithObjects:@"Red",@"Green",@"Blue", nil];
}

- (void)loadPickerView {
    // load picker
    KCModalPickerView *pickerView = [[KCModalPickerView alloc] initWithValues:self.items];
    [pickerView presentInView:self.view withBlock:^(BOOL madeChoice) {
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
#ifdef DEBUG
            NSLog(@"username found.");
#endif
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
#ifdef DEBUG
        NSLog(@"%@ object deleted",entityDescription);
#endif
    }
    if (![_managedObjectContext save:&error]) {
#ifdef DEBUG
        NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
#endif
    }
    
}

- (IBAction)saveMasterEmail {
 //- (IBAction)saveMasterEmail:(id)sender {
#ifdef DEBUG
    NSLog(@"save master Email button pressed");
#endif
    
}
- (IBAction)rfidOnOff {
//- (IBAction)rfidToggle:(id)sender {
#ifdef DEBUG
    NSLog(@"toogle");
#endif
}

- (IBAction)addCredit:(id)sender {
#ifdef DEBUG
    NSLog(@"Add credit button pressed");
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
    for (Account *anAccount in mutableFetchResults) {
        if ([anAccount.username isEqualToString:self.tfCreditUsername.text]) {
#ifdef DEBUG
            NSLog(@"username found.");
#endif
            // get value stored in credit tf
            int credit = [_tfCredit.text integerValue];
            
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

            // save to DB
            NSError *error = nil;
            if (![_managedObjectContext save:&error]) {
#ifdef DEBUG
                NSLog(@"error %@", error);
#endif
            }
            // update credit label
            _lblCredit.text = [NSString stringWithFormat:@"Credits added."];
        }
    }
}

- (IBAction)logout:(id)sender {
#ifdef DEBUG
    NSLog(@"Logout button pressed");
#endif
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
#ifdef DEBUG
            NSLog(@"root credit = %@",anAccount.credit);
#endif
            
            _lblRootCredit.text = [NSString stringWithFormat:@"root has %@ credits.",anAccount.credit];
        }
    }
}

- (IBAction)showDev:(id)sender {
#ifdef DEBUG
    NSLog(@"dev button pressed");
#endif
    UIViewController *dev = [self.storyboard instantiateViewControllerWithIdentifier:@"dev"];
    [self presentViewController:dev animated:YES completion:nil];
#ifdef DEBUG
    NSLog(@"dev button press End");
#endif
}

- (IBAction)showDev4:(id)sender {
    
    UIViewController *dev4 = [self.storyboard instantiateViewControllerWithIdentifier:@"dev4"];
    [self presentViewController:dev4 animated:YES completion:nil];
}

- (IBAction)showFlowIndicator:(id)sender {
#ifdef DEBUG
    NSLog(@"flow indicator btn pressed");
#endif
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
#ifdef DEBUG
        NSLog(@"misc btn tapped");
#endif
        UIViewController *mapview = [self.storyboard instantiateViewControllerWithIdentifier:@"mapView"];
        [self presentViewController:mapview animated:YES completion:nil];
    }
    
    
    if (item.tag==2) {
#ifdef DEBUG
        NSLog(@"dev btn tapped");
#endif
        UIViewController *dev3 = [self.storyboard instantiateViewControllerWithIdentifier:@"dev3"];
        [self presentViewController:dev3 animated:YES completion:nil];
    }
}

// added for debugging purposes - program was crashing when following method / action was removed :/
@end