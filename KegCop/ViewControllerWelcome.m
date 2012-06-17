//
//  ViewControllerWelcome.m
//  KegCop
//
//  Created by capin on 6/3/12.
//


#import "ViewControllerWelcome.h"
#import "Account.h"
#import "AppDelegate.h"

@interface ViewControllerWelcome ()

// declare private methods here

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
@synthesize welcomeActivityIndicator = _welcomeActivityIndicator;
@synthesize welcomeAbout = _welcomeAbout;
// end welcome

// Core Data
@synthesize managedObjectContext = _managedObjectContext;


//
// ViewControllerWelcome Methods
//

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // load Welcome Scrollview
    //[_welcomeScroller setScrollerEnabled:YES];
    [_welcomeScroller setContentSize:CGSizeMake(320,750)];
    
    // hidden at load
    [_wrongUserPin setHidden:YES];            
}

- (void)viewDidUnload {
    [self setTextFieldUsername:nil];
    [self setTextFieldPin:nil];
    
    [self setWrongUserPin:nil];
    [self setWelcomeLogin:nil];
    [self setWelcomeActivityIndicator:nil];
    
    
    
    [self setWelcomeScroller:nil];
    [self setWelcomeAbout:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {  
    return YES; 
}


- (IBAction)dismissKeyboard:(id)sender {
    // welcome
    [_textFieldUsername resignFirstResponder];
    [_textFieldPin resignFirstResponder];
    
}


// method to dismiss keyboard
- (IBAction) textFieldDoneEditing : (id) sender {
    [sender resignFirstResponder];
}



- (IBAction)processLogin:(id)sender {
    
    // check if username and pin text fields are populated
    if ([_textFieldUsername.text length ] == 0 &&  [_textFieldPin.text length ] == 0)
    {
        [_wrongUserPin setHidden:NO];   
    }
    
    // check if username is in Account DB
    NSString *inputUser = _textFieldUsername.text;
    
    // fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // fetchRequest.entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:_managedObjectContext];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"self.name == %@", inputUser];
    fetchRequest.fetchLimit = 1;
    
   // NSError *error = nil;
    //NSArray *users = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    
    
    // Set up a predicate (or search criteria) for checking the username
    //NSPredicate *pred = [NSPredicate predicateWithFormat:@"(username == %@)", [_textFieldUsername text]];
    
    // check if _textFieldPin matches pin stored in keychain
   
    // if ([pin = *password]);
                          
                          
    // - (NSString*)password 
    
    
    /*
    NSString *inputKey = _textFieldPin.text;
    NSString *password = [KeychainHelper getPasswordForKey:inputKey];
    if ([password isEqualToString:inputKey]) {
        NSLog(@"password matches stored pin");
    }
    else {
        [_wrongUserPin setHidden:NO];
    }
    */
    
    //+ (NSString*)getPasswordForKey:(NSString*)aKey;
    
    
    // Actually run the query in Core Data and return the count of found users with these details
    // Obviously if it found ANY then we got the username right!
    
    
    
    // check if username and pin are a match
    
    /*
    // check if username = root
    NSString *string = @"root";
    // get the value inputted in textFieldUsername and put it in a string object.
    NSString *tf_Username = [_textFieldUsername text ];
    
    // compare "root" with tf_Username
    if ([string isEqualToString: tf_Username])  {
        // load root Welcome Screen
        [self performSegueWithIdentifier:@"AdminSegue" sender:sender];
    }
    else {
        // load user Welcome screen
        [self performSegueWithIdentifier:@"UserSegue" sender: sender];
    }
    */
	
	_welcomeActivityIndicator.hidden = FALSE;
	[_welcomeActivityIndicator startAnimating];
	
	// _welcomeLogin.enabled = FALSE;
}
@end
