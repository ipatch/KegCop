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
#include <sys/ioctl.h>

/*! openPort(portName, baudRate) - Open serial port
 Example:
 NSInteger fileDescriptor = openPort("/dev/tty.iap", 9600)
 write(fileDescriptor, "hello world", 12)
 */

int openPort(char *portName, int baudRate) {
    int fileDescriptor;
    struct termios options;
    printf("Trying to open port!\n");
    fileDescriptor = open(portName, O_RDWR | O_NOCTTY | O_NONBLOCK);
    if (fileDescriptor == -1) {
        char *errorString = malloc(100);
        sprintf(errorString, "Open_port: Unable to open port %s", portName);
        perror(errorString);
        free(errorString);
    } else {
        fcntl(fileDescriptor, F_SETFL, 0);
    }
    
    // Get the current options for the port...
    tcgetattr(fileDescriptor, &options);
    
    // Set baud rate
    cfsetispeed(&options, baudRate);
    cfsetospeed(&options, baudRate);
    
    // Enable the receiver and set local mode...
    options.c_cflag |= (CLOCAL | CREAD);
    
    // Set the new options for the port...
    tcsetattr(fileDescriptor, TCSANOW, &options);
    
    return (fileDescriptor);
}

// For non-blocking reads, collects data until [length] bytes are collected
void sleeperRead(int fileDescriptor, char *data, int length) {
    int index = 0;
    while (index < length) {
        int bytesRead = read(fileDescriptor, &data[index], length - index);
        if (bytesRead == 0) usleep(10000); // Sleep 10ms
        index += bytesRead;
    }
    /* Uncomment for debugging
     for (int i = 0; i < length; i++) {
     printf("%2X %c\n", data[i], data[i]);
     }
     */
}
