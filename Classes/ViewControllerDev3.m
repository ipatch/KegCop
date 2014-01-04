//
//  ViewControllerDev3.m
//  KegCop
//
//  Created by capin on 7/2/13.
//
//

#import "ViewControllerDev3.h"

@interface ViewControllerDev3 ()

@end

@implementation ViewControllerDev3

@synthesize btnDone = _btnDone;
@synthesize btnJBSerialOpen = _btnJBSerialOpen;
@synthesize btnJBSerialClose = _btnJBSerialClose;
@synthesize btnKBSerialOpen = _btnKBSerialOpen;
@synthesize btnKBSerialClose = _btnKBSErialClose;
@synthesize btnOpenValveKBCommand = _btnOpenValveKBCommand;
@synthesize btnOpenValveRawHex = _btnOpenValveRawHex;
@synthesize btnOpenValve = _btnOpenValve;
@synthesize btnOpenValve2 = _btnOpenValve2;

@synthesize lblValveState = _lblValveState;



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
    text = [[NSMutableString alloc] initWithString:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBtnDone:nil];
    [self setBtnJBSerialOpen:nil];
    [self setBtnJBSerialClose:nil];
    [self setBtnKBSerialOpen:nil];
    [self setBtnKBSerialClose:nil];
    [self setBtnOpenValveKBCommand:nil];
    [self setBtnOpenValveRawHex:nil];
    [self setBtnOpenValveRawHex:nil];
    [self setBtnOpenValveKBProcessing:nil];
    [self setBtnOpenValve:nil];
    [self setBtnCloseValve:nil];
    [self setLblValveState:nil];
    [self setBtnOpenValve2:nil];
    text = nil;
    [super viewDidUnload];
}
- (IBAction)dismissScene:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)jbSerialOpen:(id)sender {
    
    NSLog(@"jbSerialOpen method began");
    jbserial = [[JailbrokenSerial alloc] init];
    jbserial.nonBlock = true;
    jbserial.receiver = self;
    // print serial debugging messages
    jbserial.debug = true;
    
    [jbserial open:B115200];
    if(jbserial.isOpened)
    {
        NSLog(@"Serial Port Opened");
    }
    else NSLog(@"Serial Port Closed");
    
}

- (IBAction)jbSerialClose:(id)sender {
    
    NSLog(@"jbSerialClose method began");
    [jbserial close];
    
}

- (IBAction)kbSerialOpen:(id)sender {
    
    NSLog(@"kbSerialOpen method began");
    
}

- (IBAction)kbSerialClose:(id)sender {
    
    NSLog(@"kbSerialClose method began");

    
}

- (IBAction)openValveKBCommand:(id)sender {
    
    NSLog(@"openValveKBCommand method began");
    
    KBKegboardCommandSetOutput *setOutputCommand = [KBKegboardCommandSetOutput kegboardCommandSetOutputWithOutputId:0 outputMode:KBKegboardOutputTypeEnabled];
    [jbserial write:[setOutputCommand bytes] length:[setOutputCommand length]];
    
    NSLog(@"openValveKBCommand method end");
}

- (IBAction)openValveRawHex:(id)sender {
    
    NSLog(@"openValveRawHex method begain");
    
    // See KBKegboardCommandTest.m:20 for the breakdown of this byte string
    char setOutputCommand[] = {0x4b, 0x42, 0x53, 0x50, 0x20, 0x76, 0x31, 0x3a, 0x84, 0x00, 0x06, 0x0, 0x1, 0x1, 0x4, 0x2, 0x1, 0x1, 0xa4, 0x6f, 0xd, 0xa};
    
    //send serial data (tx)
    [jbserial write:setOutputCommand length:22];
    
    NSLog(@"openValveRawHex method end");
}

- (IBAction)openValveKBProcessing:(id)sender {
    
    NSLog(@"openValveKBProcessing method began");
    
    [kegProcessing setKegboardOutputId:0 enabled:YES];

    
    NSLog(@"openValveKBProcessing method end");
}

- (IBAction)openValve:(id)sender {
    
    NSLog(@"{open_valve} btn tapped.");
        
    NSString *command = @"{open_valve}\n";
    
    [jbserial write:command];
}

- (IBAction)closeValve:(id)sender {
    
    NSLog(@"{close_valve} btn tapped.");
    
    NSString *command = @"{close_valve}\n";
    
    [jbserial write:command];
}

- (IBAction)openValve2:(id)sender {
    
    NSLog(@"{open_valve}\n btn tapped.");
    
    [jbserial write:@"{open_valve}\n"];
}

# pragma mark - JailbrokenSerialDelegate
- (void) JailbrokenSerialReceived:(char)ch {
    
    NSLog(@"Received %c", ch);
    [text appendFormat:@"%c", ch];
    //[text stringByAppendingFormat:@"%c",ch];
    NSLog(@"Received %@",text);
    
    if ([text isEqual: @"{valve_open}"]) {
        _lblValveState.text = @"Valve Opened.";
        [text setString:@""];
    }
    
    if ([text isEqual: @"{valve_close}"]) {
        _lblValveState.text =@"Valve Closed.";
        [text setString:@""];
    }
    
}
@end