//
//  SerialCom.m
//  KegCop
//
//  Created by capin on 11/9/12.
//
//

#import "SerialCom.h"

#include <stdio.h> /* Standard input/output definitions */
#include <string.h> /* String function definitions */
#include <unistd.h> /* UNIX standard function definitions */
#include <fcntl.h> /* File control definitions */
#include <errno.h> /* Error number definitions */
#include <termios.h> /* POSIX terminal control definitions */

static struct termios gOriginalTTYAttrs;

@implementation SerialCom

static int OpenSerialPort()
{
    int fileDescriptor = -1;
    int handshake;
    struct termios options;
    
    fileDescriptor = open("/dev/tty.iap", O_RDWR | O_NOCTTY | O_NONBLOCK);
    options = gOriginalTTYAttrs;
    printf("Current input baud rate is %d\n", (int) cfgetispeed(&options));
    printf("Current output baud rate is %d\n", (int) cfgetospeed(&options));
    cfmakeraw(&options);
    options.c_cc[VMIN] = 1;
    options.c_cc[VTIME] = 10;
    cfsetspeed(&options, B9600); // set baud rate
    options.c_cflag |= (CS8); // RTS flow control of input
    printf("Iput baud rate changed %d\n", (int) cfgetispeed(&options));
    printf("Output baud rate changed to %d\n", (int) cfgetospeed(&options));
    
    if (tcsetattr(fileDescriptor, TCSANOW, &options) == -1)
    {
        printf("Error setting tty attributes %s - %s(%d).\n", "/dev/tty.iap", strerror(errno), errno);
    }
    
    // Success
    return fileDescriptor;
}

- (IBAction)serialWrite:(id)sender
{
    int fd;
    char somechar[8];
    fd=OpenSerialPort();
    if (fd>-1)
    {
        write(fd,"T",1);
    }
}

@end
