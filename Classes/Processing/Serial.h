//
// Serial.h
// SerialTest
//
// Created by John Boiles on 7/28/10.
// Copyright Yelp 2010. All rights reserved.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.
//

/*!
 C-style utility methods for communicating through the serial port. Really this is just a wrapper for the normal POSIX serial port functions. It doesn't do a whole lot. In the future it'd make sense to blow away Serial.h and Serial.c and use a more appropriate Objective-C wrapper. Or just roll this into KBKegboard.
 */

NSInteger openPort(char *portName, NSInteger baudRate);

void sleeperRead(int fileDescriptor, char *data, int length);

//! Super simple method to send data out the serial port. Really it's just a wrapper for write(). Feel free to replace with something better.
void sendMessage(int fileDescriptor, char *data, int length);