//
//  ViewControllerSerialConsole.m
//  KegCop
//
//  Created by capin on 7/30/12.
//

#import "ViewControllerSerialConsole.h"
// #import "Serial.h"
# include <stdio.h> /* Standard input/output definitions */
# include <string.h> /* String function definition */
# include <unistd.h> /* UNIX standard function definitions */
# include <fcntl.h> /* File control definitions */
# include <errno.h> /* Error number definitions */
# include <termios.h> /* POSIX terminal control definitions */

static struct termios gOriginalTTYAttrs;

@interface ViewControllerSerialConsole ()


@end

@implementation ViewControllerSerialConsole
@synthesize textEntry = _textEntry;
@synthesize btnSend = _btnSend;
@synthesize serialView = _serialView;
/*
@synthesize btnOpen = _btnOpen;
@synthesize btnClose = _btnClose;
@synthesize btnDone = _btnDone;
 */




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
    
    
    
    
    
    
}
    
- (void)viewDidUnload
{
    [self setTextEntry:nil];
    [self setBtnSend:nil];
    [self setSerialView:nil];
    /*
    [self setBtnOpen:nil];
    [self setBtnClose:nil];
    [self setBtnDone:nil];
     */
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)donePressed:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];    
}

- (IBAction)sendString:(id)sender {
    // dismiss keyboard
    [self.textEntry resignFirstResponder];
}

- (IBAction)serial:(id)sender
{
    /*
    int fd;
    char somechar[8];
    fd=OpenSerialPort();
    if(fd>-1)
    {
        write(fd,"T",1);
        
    }
     */
}

- (IBAction)openSerial:(id)sender
{
    
    
    serial.debug = YES; // debug messaages will be printed out using NSLog() if the flag is set to YES
    
    [serial open:B9600];
    NSLog(@"%c", [serial isOpened]);
    
    serial.nonBlock = true;
    
    serial.receiver = self;
    
    char buffer[12];
    [serial read:buffer length:12]; // will be blocked until read 5 characters.
    
    // print line to textview
    _serialView.text = [NSString stringWithFormat:@"%s",buffer];
    
}

- (IBAction)closeSerial:(id)sender
{
    [serial close];
}



@end
