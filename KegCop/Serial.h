//
//  Serial.h
//  KegCop
//
//  Created by capin on 8/2/12.
//


NSInteger openPort(char *portName, NSInteger baudRate);

void sleeperRead(int fileDescriptor, char *data, int length);

// open port first, then call sleeperRead
