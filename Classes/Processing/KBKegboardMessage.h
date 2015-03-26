//
// KBKegboardMessage.h
// KegPad
//
// Created by John Boiles on 9/27/10.
// Copyright 2010 Yelp. All rights reserved.
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
// a class to represent a message from the board

#define BAUD_RATE 115200

// Size of fields in Kegboard Serial Protocol
#define kKBSP_HEADER_PREFIX_SIZE 8
#define kKBSP_HEADER_MESSAGE_ID_SIZE 2
#define kKBSP_HEADER_PAYLOAD_LENGTH_SIZE 2
#define kKBSP_PAYLOAD_TAG_SIZE 1
#define kKBSP_PAYLOAD_LENGTH_SIZE 1
#define kKBSP_FOOTER_CRC_SIZE 2
#define kKBSP_FOOTER_TRAILER_SIZE 2

#define KBSP_PAYLOAD_MAXLENGTH 112
#define kKBSP_PREFIX "KBSP v1:"
#define kKBSP_TRAILER "\r\n"

extern char *const KBSP_PREFIX;
extern char *const KBSP_TRAILER;

// Message definitions (messages received from the Kegboard)
#define KB_MESSAGE_ID_HELLO 0x01
#define KB_MESSAGE_ID_BOARD_CONFIGURATION 0x02
#define KB_MESSAGE_ID_METER_STATUS 0x10
#define KB_MESSAGE_ID_TEMPERATURE_READING 0x11
#define KB_MESSAGE_ID_OUTPUT_STATUS 0x12
#define KB_MESSAGE_ID_AUTH_TOKEN 0x14
// Command definitions (messages sent to the Kegboard)
#define KB_MESSAGE_ID_PING 0x81
#define KB_MESSAGE_ID_SET_OUTPUT 0x84


/*!
 Abstract base class for objects representing a message received from a Kegboard using the Kegboard Serial Protocol (KBSP).
 */
@interface KBKegboardMessage : NSObject {}
@property (readonly, assign, nonatomic) NSTimeInterval timeStamp;
@property (readonly, nonatomic) NSUInteger messageId;

+ (id)messageWithId:(NSUInteger)messageId payload:(char *)payload length:(NSUInteger)length timeStamp:(NSTimeInterval)timeStamp;

// Subclasses must override this method
+ (NSUInteger)messageId;

// Subclasses must override this message
- (BOOL)parsePayload:(char *)data forTag:(NSUInteger)tag length:(NSUInteger)length;

@end


@interface KBKegboardMessageHello : KBKegboardMessage {}
@property (readonly, assign, nonatomic) NSUInteger protocolVersion;
@end


@interface KBKegboardMessageBoardConfiguration : KBKegboardMessage {}
@property (readonly, retain, nonatomic) NSString *boardName;
@property (readonly, assign, nonatomic) NSUInteger baudRate;
@property (readonly, assign, nonatomic) NSUInteger updateInterval;
@property (readonly, assign, nonatomic) NSUInteger watchdogTimeout;
@end


@interface KBKegboardMessageMeterStatus : KBKegboardMessage {}
@property (readonly, retain, nonatomic) NSString *meterName;
@property (readonly, assign, nonatomic) NSUInteger meterReading;
@end


@interface KBKegboardMessageTemperatureReading : KBKegboardMessage {}
@property (readonly, retain, nonatomic) NSString *sensorName;
@property (readonly, assign, nonatomic) double sensorReading;
@end


@interface KBKegboardMessageOutputStatus : KBKegboardMessage {}
@property (readonly, retain, nonatomic) NSString *outputName;
@property (readonly, assign, nonatomic) BOOL outputReading;
@end


@interface KBKegboardMessageAuthToken : KBKegboardMessage {}
@property (readonly, retain, nonatomic) NSString *deviceName;
@property (readonly, retain, nonatomic) NSString *token;
@property (readonly, assign, nonatomic) BOOL status; // YES if present, NO if removed
@end