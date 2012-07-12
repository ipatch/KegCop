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

// Home screen / scene

@synthesize homeScroller = _homeScroller;
@synthesize lblUSERNAME = _lblUSERNAME;
@synthesize tfUsername = _tfUsername;
@synthesize tfCredit = _tfCredit;
@synthesize btnTradeCredit = _btnTradeCredit;
 // @synthesize username = _username;
// @synthesize removeAccount = _removeAccount;


- (void)viewDidLoad
{
    
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
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setHomeScroller:nil];
    [self setTfUsername:nil];
    [self setTfCredit:nil];
    [self setBtnTradeCredit:nil];
    [self setLblUSERNAME:nil];
    [super viewDidUnload];
  
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
}

- (void)changeUSERNAME {
    _lblUSERNAME.text = [ModelWelcome sharedModelWelcome].passedText;
}    


@end