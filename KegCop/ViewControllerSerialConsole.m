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

/*
static int OpenSerialPort()
{
    int fileDescriptor = -1;
    int handshake;
    struct termios options;

    fileDescriptor = opne("dev/tty.iap", O_RDWR | O_NOCTTY  | O_NONBLOCK);
    options = gOriginalTTYAttrs;
    printf("Current input baud rate is %d\n", (int) cfgetispeed(&options));
    printf("Current ouput baud rate is %d\n", (int) cfgetospeed(&options));
    cfmakeraw(&options);
    options.c_cc[VMIN] = 1;
    options.c_cc[VTIME] = 10;
    cfsetspeed(&options, B9600);
    options.c_cflag |= (CS8);
    printf("input baud rate changed to %d\n", (int) cfgetispeed(&options));
    printf("Output baud rate changed to %d\n", (int) cfgetospeed(&options));
       
    if (tcsetattr(fileDescriptor, TCSANOW, &options) == -1)
    {
           printf("Error setting tty attributes %s - %s(%d).\n", "/dev/tty.iap", strerror(errno), errno);
    }
    // Success
    return fileDescriptor;
       
    }

*/
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
    
    JailbrokenSerial *serial = [[JailbrokenSerial alloc] init];
    
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




@end
