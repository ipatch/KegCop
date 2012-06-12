//
//  ViewControllerWelcome.m
//  KegCop
//
//  Created by capin on 6/3/12.
//


#import "ViewControllerWelcome.h"

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


//
// ViewControllerWelcome Methods
//

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // load Welcome Scrollview
    //[_welcomeScroller setScrollerEnabled:YES];
    [_welcomeScroller setContentSize:CGSizeMake(320,1000)];
    
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
    
    //http://www.riccomini.name/Topics/Mobile/iPhone/SimpleLoginScreen/
    // TODO: spawn a login thread
    
    
    NSString *string = @"root";
    // get the value inputted in textFieldUsername and put it in a string object.
    NSString *tf_Username = [_textFieldUsername text ];
    
    // compare "admin" with tf_Username
    if ([string isEqualToString: tf_Username])  {
        // do my bidding!!!
        [self performSegueWithIdentifier:@"AdminSegue" sender:sender];
    }
    else {
        [self performSegueWithIdentifier:@"UserSegue" sender: sender];
    }
    
	
	_welcomeActivityIndicator.hidden = FALSE;
	[_welcomeActivityIndicator startAnimating];
	
	_welcomeLogin.enabled = FALSE;
}
@end
