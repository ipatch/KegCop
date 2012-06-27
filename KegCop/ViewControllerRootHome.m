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
@synthesize tvDisplayAccount = _tvDisplayAccount;
@synthesize lblArduinoGood = _lblArduinoGood;
@synthesize lblArduinoBad = _lblArduinoBad;

// Core Data
@synthesize managedObjectContext = _managedObjectContext;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // load Home Scrollview
    [_rootHomeScroller setContentSize:CGSizeMake(320,750)];
    
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
   
}

- (void)viewDidUnload
{
    [self setTfDeleteAccount:nil];
    [self setBtnDeleteAccount:nil];
    [self setBtnDisplayAccount:nil];
    [self setTvDisplayAccount:nil];
    [self setLblArduinoGood:nil];
    [self setLblArduinoBad:nil];
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

- (IBAction)deleteAccount:(id)sender {
    
    // TODO - implement method / code to delete a user account
    
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
    
    // delete attributes from Core Data DB
    
    // delete username
    
    // delete pin / repin / keychain
    Account *anAccount = [[Account alloc] init];
    anAccount.prepareForDeletion;
    
    // delete email
    
    // delete phone number

    
}

- (IBAction)dismissKeyboard:(id)sender {
    
    [_tfDeleteAccount resignFirstResponder];
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

@end