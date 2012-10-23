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
    
    // open the serial port - /dev/tty.ipa
    
    // open port
    
    // char = read 1 char
    
    // while ( char ! NL )
     // {
            // append char to end of string
    
            // read next character
     // }
    
    // if string not valid
    
    
    // -------------------------
    
    // while
    
    // read char
    
    // write to console / textview
    
    // end while
       
    //char somechar[8];
    
    // print the serial data to the console
    //NSLog(@"The serial data is %d",serial);
    
    // read data coming across the serial port
    //read(serial,&somechar[0],1);
    
    // print the serial data in the textview
    //_serialView.text = [NSString stringWithFormat:@"%i",serial];
    
    
    // span a new thread for the while loop
    
    // reading off the serial port is an event
    
    FILE *serial_in;
    
    char line_buffer[1000];
    
    // int lineBufferUsed;
    int portnum;
    
    NSLog(@"got to A");
    
    portnum = openPort("/dev/tty.iap",9600);
    
    NSLog(@"got to B");
    
    
    serial_in = fdopen(portnum, "r"); // r = read
    
    NSLog(@"got to C");
    
    while (1) {
        
        NSLog(@"got to D");
        
         fgets (line_buffer, 1000, serial_in); // get up too 1000bytes but stop at \n
        
        NSLog(@"got to E %s",line_buffer);
        
        // print line to textview
       // _serialView.text = [NSString stringWithFormat:@"%s",line_buffer];
        
        NSLog(@"got to F");
    }
    
    
    // main thread is trapped in while loop
    
    
    
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
