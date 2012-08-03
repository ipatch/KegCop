//
//  ViewControllerSerialConsole.m
//  KegCop
//
//  Created by capin on 7/30/12.
//

#import "ViewControllerSerialConsole.h"
#import "Serial.h"

@interface ViewControllerSerialConsole ()

@end

@implementation ViewControllerSerialConsole
@synthesize textEntry = _textEntry;
@synthesize btnSend = _btnSend;
@synthesize serialView = _serialView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
#if !TARGET_IPHONE_SIMULATOR    
    NSInteger serial = openPort();
    NSLog(@"The serial data is %i",serial);
    //_serialView.text = serial;
#endif
}

- (void)viewDidUnload
{
    [self setTextEntry:nil];
    [self setBtnSend:nil];
    [self setSerialView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)btnPressed:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];    
}

- (IBAction)sendString:(id)sender {
    // dismiss keyboard
    [self.textEntry resignFirstResponder];
}


@end
