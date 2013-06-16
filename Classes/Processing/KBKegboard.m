//
// KBKegboard.m
// KegPad
//
// Created by John Boiles on 7/29/10.
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
//
// TODO - capin
// - clearly define what this class file does
// - fix error on "@synthesize delegate=_delegate"

#import "KBKegboard.h"
#import "crc16ccitt.h"
#import "KBKegboardCommand.h"
#import "KBKegboardUtils.h"

@implementation KBKegboard

static NSInteger gFileDescriptor;

- (id)init {
    if ((self = [super init])) {
        if (gFileDescriptor <= 0) {
            gFileDescriptor = openPort(SERIAL_PORT, BAUD_RATE);
#if !TARGET_IPHONE_SIMULATOR
            if (gFileDescriptor == -1) {
                NSLog(@"Port failed to open");
            }
#endif
            [self start];
        }
    }
    return self;
}

- (id)initWithDelegate:(id<KBKegboardDelegate>)delegate {
    if ((self = [self init])) {
        _delegate = delegate;
    }
    return self;
}

- (void)start {
    if (!_readLoopThread) {
        _readLoopThread = [[NSThread alloc] initWithTarget:self selector:@selector(readLoop) object:nil];
        [_readLoopThread start];
    }
}

- (void)dealloc {
    close(gFileDescriptor);
}

- (void)notifyDelegate:(KBKegboardMessage *)message {
    NSUInteger messageId = [message messageId];
    switch (messageId) {
        case KB_MESSAGE_ID_HELLO:
            [self.delegate kegboard:self didReceiveHello:(KBKegboardMessageHello *)message];
            break;
        case KB_MESSAGE_ID_BOARD_CONFIGURATION:
            [self.delegate kegboard:self didReceiveBoardConfiguration:(KBKegboardMessageBoardConfiguration *)message];
            break;
        case KB_MESSAGE_ID_METER_STATUS:
            [self.delegate kegboard:self didReceiveMeterStatus:(KBKegboardMessageMeterStatus *)message];
            break;
        case KB_MESSAGE_ID_TEMPERATURE_READING:
            [self.delegate kegboard:self didReceiveTemperatureReading:(KBKegboardMessageTemperatureReading *)message];
            break;
        case KB_MESSAGE_ID_OUTPUT_STATUS:
            [self.delegate kegboard:self didReceiveOutputStatus:(KBKegboardMessageOutputStatus *)message];
            break;
        case KB_MESSAGE_ID_AUTH_TOKEN:
            [self.delegate kegboard:self didReceiveAuthToken:(KBKegboardMessageAuthToken *)message];
            break;
    }
}

- (void)readLoop {
//    KBDebug(@"Initializing Read Loop");
  @autoreleasepool {
    // Directly ported from PyKeg to ObjectiveC
    char headerBytes[4];
    char payload[KBSP_PAYLOAD_MAXLENGTH];
    char crc[2];
    char trailer[2];
    crc_t calculatedCRC;
    NSTimeInterval timeStamp;
    
    while (YES) {
        // Find the prefix, re-aligning the messages as needed.
        BOOL loggedFrameError = NO;
        NSInteger headerPosition = 0;
        calculatedCRC = crc_init();
        while (headerPosition < kKBSP_HEADER_PREFIX_SIZE) {
            char byte;
            sleeperRead(gFileDescriptor, &byte, 1);
            if (headerPosition == 0) {
                // NOTE(johnb): According to this Stack Overflow post
                // http://stackoverflow.com/questions/358207/iphone-how-to-get-current-milliseconds
                // CACurrentMediaTime will usually give more accurate relative timestamps than NSDate
                // Since we're mostly interested in relative timestamps (for flow rate), this is the
                // best option.
                timeStamp = CACurrentMediaTime();
            }
            calculatedCRC = crc_update(calculatedCRC, (unsigned char *)&byte, 1);
            // Byte was expected
            if (byte == KBSP_PREFIX[headerPosition]) {
                headerPosition += 1;
                if (loggedFrameError) {
//                    KBDebug(@"Packet framing fixed.");
                    loggedFrameError = NO;
                }
                // Byte wasn't expected
            } else {
                if (!loggedFrameError) {
//                    KBDebug(@"Packet framing broken (found \"%X\", expected \"%X\"); reframing.", byte, KBSP_PREFIX[headerPosition]);
                    loggedFrameError = YES;
                }
                headerPosition = 0;
                calculatedCRC = crc_init();
            }
        }
        
        // Read message type and message length
        sleeperRead(gFileDescriptor, headerBytes, 4);
        calculatedCRC = crc_update(calculatedCRC, (unsigned char *)headerBytes, 4);
        NSInteger messageId = [KBKegboardUtils parseUInt16:headerBytes];
        NSInteger messageLength = [KBKegboardUtils parseUInt16:&headerBytes[2]];
        if (messageLength > KBSP_PAYLOAD_MAXLENGTH) {
//            KBDebug(@"Bogus message length (%d), skipping message", messageLength);
            continue;
        }
        
        // Read payload and trailer
        sleeperRead(gFileDescriptor, payload, messageLength);
        calculatedCRC = crc_update(calculatedCRC, (unsigned char *)payload, messageLength);
        sleeperRead(gFileDescriptor, crc, 2);
        sleeperRead(gFileDescriptor, trailer, 2);
        
        crc_t sentCRC = [KBKegboardUtils parseUInt16:crc];
        if (calculatedCRC != sentCRC) {
            NSLog(@"ERROR: Bad CRC: Calculated crc is %X while sent crc is %X", calculatedCRC, sentCRC);
            continue;
        }
        
        if (trailer[0] != KBSP_TRAILER[0] || trailer[1] != KBSP_TRAILER[1]) {
//            KBDebug(@"Bad trailer characters 0x%X 0x%X (expected 0x%X 0x%X) skipping message", trailer[0], trailer[1], KBSP_TRAILER[0], KBSP_TRAILER[1]);
            continue;
        }
        
        // Create KegboardMessage from id and payload
        KBKegboardMessage *kegboardMessage = [KBKegboardMessage messageWithId:messageId payload:payload length:messageLength timeStamp:timeStamp];
       // KBDebug(@"Got message %@", kegboardMessage);
        // Notify delegate of message
        [self performSelectorOnMainThread:@selector(notifyDelegate:) withObject:kegboardMessage waitUntilDone:NO];
    }
  }
}

- (void)pingKegboard {
    KBKegboardCommandPing *kegboardCommandPing = [KBKegboardCommandPing kegboardCommandPing];
    sendMessage(gFileDescriptor, [kegboardCommandPing bytes], [kegboardCommandPing length]);
}

- (void)setKegboardOutputId:(NSInteger)outputId enabled:(BOOL)enabled {
    KBKegboardCommandSetOutput *kegboardCommandSetOutput = [KBKegboardCommandSetOutput kegboardCommandSetOutputWithOutputId:outputId outputMode:(enabled ? KBKegboardOutputTypeEnabled : KBKegboardOutputTypeDisabled)];
    sendMessage(gFileDescriptor, [kegboardCommandSetOutput bytes], [kegboardCommandSetOutput length]);    
}

@end
