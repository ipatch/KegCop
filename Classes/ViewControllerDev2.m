//
//  ViewControllerDev2.m
//  KegCop
//
//  Created by capin on 6/25/13.
//
//

#import "ViewControllerDev2.h"

@implementation ViewControllerDev2

@synthesize btnDone = _btnDone;
@synthesize btnOpenValve = _btnOpenValve;
@synthesize btnOpenValveKBCommand = _btnOpenValveKBCommand;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //initialize serial class
    jbserial = [[JailbrokenSerial alloc] init];
    jbserial.nonBlock = true;
    jbserial.receiver = self;
    // print serial debugging messages
    jbserial.debug = true;
}

- (void)viewDidUnload {
    [self setBtnDone:nil];
    [self setBtnOpenValve:nil];
    [self setBtnOpenValveKBCommand:nil];
    // close serial port - hopefully
    [jbserial close];
    [super viewDidUnload];
}
- (IBAction)dismissScene:(id)sender {
    
    // close the serial port
    [jbserial close];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)openValve:(id)sender {
    
    NSLog(@"Open Valve button pressed.");
    
    [jbserial open:B115200];
    if(jbserial.isOpened)
    {
        NSLog(@"Serial Port Opened");
    }
    else NSLog(@"Serial Port Closed");
    
    
    // See KBKegboardCommandTest.m:20 for the breakdown of this byte string
    char setOutputCommand[] = {0x4b, 0x42, 0x53, 0x50, 0x20, 0x76, 0x31, 0x3a, 0x84, 0x00, 0x06, 0x0, 0x1, 0x1, 0x4, 0x2, 0x1, 0x1, 0xa4, 0x6f, 0xd, 0xa};
    
    //send serial data (tx)
    [jbserial write:setOutputCommand length:22];
}

- (IBAction)openValveKBCommand:(id)sender {
    
    NSLog(@"Open Valve KBCommand button pressed.");
    
    [jbserial open:B115200];
    if(jbserial.isOpened)
    {
        NSLog(@"Serial Port Opened");
    }
    else NSLog(@"Serial Port Closed");
    
    KBKegboardCommandSetOutput *setOutputCommand = [KBKegboardCommandSetOutput kegboardCommandSetOutputWithOutputId:0 outputMode:KBKegboardOutputTypeEnabled];
    [jbserial write:[setOutputCommand bytes] length:[setOutputCommand length]];
}

# pragma mark - JailbrokenSerialDelegate
- (void) JailbrokenSerialReceived:(char)ch {
}
@end
