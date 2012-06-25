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
    
    // load Welcome Scrollview
    [_welcomeScroller setContentSize:CGSizeMake(320,750)];
    
    // hidden at load
    [_wrongUserPin setHidden:YES];
    
    // Core Data
    if (_managedObjectContext == nil)
    {
        _managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        NSLog(@"After _managedObjectContext: %@",  _managedObjectContext);

    }    
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
    [_welcomeActivityIndicator startAnimating];
    [_wrongUserPin setHidden:YES];
        
    // check if username and pin text fields are populated
    if ([_textFieldUsername.text length ] == 0 &&  [_textFieldPin.text length ] == 0)
    {
        [_welcomeActivityIndicator stopAnimating];
        [_wrongUserPin setHidden:NO];   
    }
    
    // CORE DATA
    // NSManagedObjectContext *context = _managedObjectContext;
    
    NSFetchRequest *request= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"username=%@",self.textFieldUsername.text];
    
    // TODO check pin
    Account *pinAccount = [[Account alloc] init];
    
    // GETTING ERROR ON BELOW LINE OF CODE! - ERR0R - No visible @interface for 'Account' declares the selector 'password:'
    // [pinAccount password:_textFieldPin.text];
    
    
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    NSError *error = nil;
        
    NSArray *array = [_managedObjectContext executeFetchRequest:request error:&error];
    if (array != nil) {
        NSUInteger count = [array count]; // may be 0 if the object has been deleted.
        NSLog(@"Username may exist, %@",count);
    }
    
    else {
        NSLog(@"Username does not exist.");
    }
}

// method keyboard behavior

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
   
    NSLog(@"method was loaded at startup");
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

@end
