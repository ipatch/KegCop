//
//  Serial.c
//  KegCop
//
//  This file was originally created for the KegPad project.
//  Created by capin on 8/2/12.
//

#include <stdio.h>   /* Standard input/output definitions */
#include <stdlib.h>
#include <string.h>  /* String function definitions */
#include <unistd.h>  /* UNIX standard function definitions */
#include <fcntl.h>   /* File control definitions */
#include <errno.h>   /* Error number definitions */
#include <termios.h> /* POSIX terminal control definitions */

/*
 * 'open_port()' - Open serial port on dock connector pins 13RX / 12TX
 *
 * Returns the file descriptor on success or -1 on error.
 */

int openPort(void)
{
    int fd = -1; /* File descriptor for the port */
    
    struct termios options; 
    
    fd = open("/dev/tty.iap", O_RDWR | O_NOCTTY | O_NDELAY); // O_NOCTTY - don't be controlling terminal, O_NODELAY don't care about DCD signal state
    if ( fd == -1)
    {
        // couldn't open the port
        
        perror("open_port: Unable to open /dev/tty.iap - ");
    }
    else
        fcntl(fd, F_SETFL, 0);
    
    tcgetattr(fd, &options); // get current options for the port
    
    // set the baud rate
    cfsetispeed(&options, B2400);
    cfsetospeed(&options, B2400);
    
    // enable the receiver and set local mode
    options.c_cflag |= (CLOCAL | CREAD);
    
    // set the new options for the port
    tcsetattr(fd, TCSANOW, &options);
    
    return (fd);

}

