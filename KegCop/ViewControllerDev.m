//
//  ViewControllerDev.m
//  KegCop
//
//  Created by capin on 8/13/12.
//

#import "ViewControllerDev.h"
#import "NSData+AES256.h"

@interface ViewControllerDev ()

@end

@implementation ViewControllerDev
@synthesize tf = _tf;
@synthesize btn = _btn;
@synthesize lbl = _lbl;
@synthesize btnValve = _btnValve;
@synthesize btnBlink = _btnBlink;

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
    
    // initialize serial class
    serial = [[JailbrokenSerial alloc] init];
}

- (void)viewDidUnload
{
    [self setTf:nil];
    [self setBtn:nil];
    [self setLbl:nil];
    [self setBtnValve:nil];
    [self setBtnBlink:nil];
    [self setBtnDone:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)submit:(id)sender {
    
    
    NSString *key = @"donkey balls";
    
    NSString *secret;
    secret = _tf.text;
    // convert string to NSData
    NSData *plain = [secret dataUsingEncoding:NSUTF8StringEncoding];
    
    //encrypt string
    NSData *cipher = [plain AES256EncryptWithKey:key];
    printf("%s\n", [[cipher description] UTF8String]);
    
    // convert NSData to Base64 encoded NSData
    NSString *cipherB64 = [self base64forData:cipher];
    
    // convert cipherstring to output label
    _lbl.text = cipherB64;
}



//from: http://www.cocoadev.com/index.pl?BaseSixtyFour
- (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}



- (IBAction)openValve:(id)sender {
    
    // method to open a solenoid cut off valve connected to Arduino using the kegboard-mini shield.
    
    NSLog(@"Open valve btn pressed");
    
    // open serial interface
    
    [serial open:B2400];
    NSLog(@"%c", [serial isOpened]);
    
    // send serial data (tx)
    
    char buffer [11];
    //NSString bufString = @"openvalve";
    buffer[0] = '{';
    buffer[1] = 'o';
    buffer[2] = 'p';
    buffer[3] = 'e';
    buffer[4] = 'n';
    buffer[5] = 'v';
    buffer[6] = 'a';
    buffer[7] = 'l';
    buffer[8] = 'v';
    buffer[9] = 'e';
    buffer[10] = '}';
    
    [serial write:buffer length:11];
    //[serial write:bufString length:9];
}

- (IBAction)blinkFlow_A_LED:(id)sender {
    
    // method to blink the Flow_A LED on the kegboard-mini Arduino sheild.
    
    NSLog(@"blink Flow_A btn pressed");
    
    NSLog(@"hello kyle");
    
    // open serial port / interface
    
    [serial open:B2400];
    if(serial.isOpened)
    {
        NSLog(@"Serial Port Opened");
    }
    else NSLog(@"Serial Port Closed");
    
    // print serial debugging messages
    serial.debug = true;
    
    
    // send serial data (tx)
    
    
//    char buffer [7];
//    
//    buffer[0] = '{';
//    buffer[1] = 'b';
//    buffer[2] = 'l';
//    buffer[3] = 'i';
//    buffer[4] = 'n';
//    buffer[5] = 'k';
//    buffer[6] = '}';
    
    
//    char character;
//    
//    character = 'b';
    
    // delay sending serial data (tx) for a given time period
    
   // NSLog(@"start delay");
    
    // [NSThread sleepForTimeInterval:3.0];
    
   // NSLog(@"delay of 3 seconds ended");
    
    char blink;
    blink = 'b';
    
    [serial write:&blink length:1];
    
    // print message sent
    NSLog(@"the command sent was:%c",blink);
}

- (IBAction)dimissScene:(id)sender {
    
    // close the serial port
    [serial close];
    
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
