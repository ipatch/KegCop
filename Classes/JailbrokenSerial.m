//
//  JailbrokenSerial.m
//  HackSerialTest
//
//  Created by Sunjun Kim on 8/9/11.
//  Copyright 2011 KAIST. All rights reserved.
//

#include <stdio.h>   /* Standard input/output definitions */
#include <string.h>  /* String function definitions */
#include <unistd.h>  /* UNIX standard function definitions */
#include <fcntl.h>   /* File control definitions */
#include <errno.h>   /* Error number definitions */

#include <sys/ioctl.h>

#import "JailbrokenSerial.h"

@interface JailbrokenSerial ()
- (void)readPoller;
@property (nonatomic, retain) NSThread *thread;
@end

@implementation JailbrokenSerial

//@synthesize receiver = _receiver;
@synthesize debug, nonBlock;
@synthesize thread;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        fd = -1;
        debug = false;
        nonBlock = false;
        self.thread = nil;
    }
    
    return self;
}

- (id)initWithReceiver:(id<JailbrokenSerialDelegate>) receiver {
    self = [self init];
    if(self) {
        [self setReceiver:receiver];
    }
    
    return self;
}

- (void)dealloc {
    [thread cancel];
    //[thread release];
    
   // [super dealloc];
}

- (void)readPoller {
    //  // Top-level pool
    char ch;
    int buf_len;
    
   // NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
    
    while(![[NSThread currentThread] isCancelled]) {
        
        buf_len = read(fd,&ch,1); // Read 1 byte  over serial.  This will block
        //        NSLog(@"Loop");
        
        // If something can be read
        if(buf_len == 1) {
            receivedCh = ch;
            [self performSelectorOnMainThread:@selector(sendReadMessage) withObject:nil waitUntilDone:YES];
        }
        else if(buf_len == -1) {
            [NSThread sleepForTimeInterval:0.01]; // set the wait time for the read loop - IMPORTANT
        }
        [myRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
    //[pool release];
}

- (void)sendReadMessage {
    [self.receiver JailbrokenSerialReceived:receivedCh];
}

- (ssize_t)read:(void *)buffer length:(size_t)len {
    return read(fd, buffer, len);
}

- (BOOL)open:(int)baudRate {
    struct termios  options;
    
    int fileDescriptor = open("/dev/tty.iap", O_RDWR | O_NOCTTY | O_NONBLOCK);
    //    int fileDescriptor = open("/dev/tty.iap", O_RDWR | O_NOCTTY | O_NDELAY);
    if (fileDescriptor == -1)
    {
        if(debug) NSLog(@"Error opening serial port %@ - %s(%d).", @"/dev/tty.iap", strerror(errno), errno);
        close(fileDescriptor);
        return false;
    }
    
    if(ioctl(fileDescriptor, TIOCEXCL) == -1) {
        if(debug) NSLog(@"Error setting TIOCEXCL on %@ - %s(%d).", @"/dev/tty.iap", strerror(errno), errno);
        close(fileDescriptor);
        return false;
    }
    
    if(nonBlock) {
        if(fcntl(fileDescriptor, F_SETFL, O_NONBLOCK) == -1) {
            if(debug) NSLog(@"Error setting O_NONBLOCK on %@ - %s(%d).", @"/dev/tty.iap", strerror(errno), errno);
            close(fileDescriptor);
            return false;
        }
    }
    else {
        if(fcntl(fileDescriptor, F_SETFL, 0) == -1) {
            if(debug) NSLog(@"Error clearing O_NONBLOCK on %@ - %s(%d).", @"/dev/tty.iap", strerror(errno), errno);
            close(fileDescriptor);
            return false;
        }
    }
    tcgetattr(fileDescriptor, &gOriginalTTYAttrs);
    
    options = gOriginalTTYAttrs;
    
    if(debug) {
        NSLog(@"Current input baud rate is %d\n", (int) cfgetispeed(&options));
        NSLog(@"Current output baud rate is %d\n", (int) cfgetospeed(&options));
    }
    
    // Set raw input (non-canonical) mode, with reads blocking until either a single character
    // has been received or a one second timeout expires.
    // See tcsetattr(4) ("man 4 tcsetattr") and termios(4) ("man 4 termios") for details.
    cfmakeraw(&options);
    options.c_cc[VMIN] = 1;
    options.c_cc[VTIME] = 10;
    
    // The baud rate, word length, and handshake options can be set as follows:
    
    cfsetspeed(&options, baudRate);    // Set 19200 baud
    options.c_cflag &= ~PARENB;      // Set as 8-1-N
    options.c_cflag &= ~CSTOPB;
    options.c_cflag &= ~CSIZE;
    options.c_cflag |= CS8;
    
    if(debug) {
        NSLog(@"Input baud rate changed to %d\n", (int) cfgetispeed(&options));
        NSLog(@"Output baud rate changed to %d\n", (int) cfgetospeed(&options));
    }
    
    tcsetattr(fileDescriptor, TCSANOW, &options);
    
    fd = fileDescriptor;
    
    if(nonBlock) {
        self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(readPoller) object:nil];
        [thread start];
    }
    
    return true;
}

- (BOOL)isOpened {
    if(fd==-1)
        return false;
    else
        return true;
}

- (void)close{
    if(fd != -1) {
        close(fd);
        fd = -1;
        [thread cancel];
        self.thread = nil;
        
        if(debug)
            NSLog(@"Closed");
    }
}

- (void)write:(const char *)message length:(int)len {
    if(fd != -1) {
        write(fd, message, len);
    }
    if(debug) {
        NSLog(@"%d bytes wrote", len);
    }
}

- (void)write:(NSString *)message {
    [self write:[message UTF8String] length:[message length]];
}

/* commented handShake method to remove build warning 
- (void) handShake {
    
    
    // open serial port
    [self open:B2400];
    
    int i = 0;
    while(i < 1) {
    
        NSString *str = @"Hello Arduino";
        
        [self write:str];
        
        char buffer[12];
        
        [self read:buffer length:12];
        
        NSString *s = [NSString stringWithFormat:@"%s",buffer] ;
        
        NSLog(@"String s = %@",s);
        
        if(s == @"Hello iPhone")
        {
            i++;
            NSLog(@"Handshake successful");
            break;
        }
        else
        {
            NSLog(@"Handshake failed");
        }
    }
 }
*/
@end
